const std = @import("std");

const http = @import("zig_toy_http_server");

const Context = struct {};

fn handle(context: *Context, req: *http.Request, res: *http.Response) anyerror!void {
    _ = context;
    _ = res;
    var buffer: [4096]u8 = undefined;
    @memset(buffer[0..buffer.len], 0);
    const readLen = try req.reader.readSliceShort(buffer[0..buffer.len]);
    std.debug.print("{s}", .{buffer[0..readLen]});
}

pub fn main() !void {
    var general_purpose_allocator: std.heap.GeneralPurposeAllocator(.{}) = .init;
    const gpa = general_purpose_allocator.allocator();

    var server = http.Server(Context).init(.{}, handle);
    try server.listenAndServe(gpa, "127.0.0.1:80");
}
