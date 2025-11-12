const zig_toy_http_server = @import("zig_toy_http_server");

const Handler = struct {};

pub fn main() !void {
    _ = zig_toy_http_server.Server(Handler).init(.{});
    // _ = server;
}
