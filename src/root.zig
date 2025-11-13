const std = @import("std");
const net = std.net;

pub const Request = struct {
    reader: *std.Io.Reader,
};

pub const Response = struct {};

pub fn Server(comptime Context: type) type {
    if (@typeInfo(Context) != .@"struct") {
        @compileError("expected struct argument, found " ++ @typeName(Context));
    }
    return struct {
        const Handler = *const fn (context: *Context, req: *Request, res: *Response) anyerror!void;
        const Self = @This();

        context: Context,
        handle: Handler,

        pub fn init(context: Context, handle: Handler) Self {
            return .{
                .context = context,
                .handle = handle,
            };
        }

        pub fn listenAndServe(self: *Self, allocator: std.mem.Allocator, address: []const u8) !void {
            var parsed_address = try net.Address.parseIpAndPort(address);
            // Use 80 as default port
            if (parsed_address.getPort() == 0) {
                parsed_address.setPort(80);
            }
            var server = try parsed_address.listen(.{});
            std.debug.print("Listening on {f}\n", .{parsed_address});
            while (true) {
                const conn = try server.accept();
                const buffer = try allocator.alloc(u8, 4096);
                defer allocator.free(buffer);
                var reader = conn.stream.reader(buffer);
                var req = Request{ .reader = reader.interface() };
                var resp = Response{};
                try self.handle(&self.context, &req, &resp);
            }
        }
    };
}
