const std = @import("std");
const builtin = @import("builtin");

pub const ZigLibC = struct {
    pub var allocator: *std.mem.Allocator = undefined;
    pub var endianness: std.builtin.Endian = builtin.cpu.arch.endian();
};