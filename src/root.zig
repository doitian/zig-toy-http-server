const std = @import("std");

pub const Request = struct {};

pub const Response = struct {};

pub fn Server(comptime Handler: type) type {
    if (@typeInfo(Handler) != .@"struct") {
        @compileError("Server handler must be a struct, got: " ++ @tagName(@typeInfo(Handler)));
    }
    return struct {
        handler: Handler,

        const Self = @This();

        pub fn init(handler: Handler) Self {
            return .{
                .handler = handler,
            };
        }
    };
}
