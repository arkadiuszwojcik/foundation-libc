//! implementation of `stdlib.h`

const std = @import("std");
const ziglibc = @import("../config.zig").ZigLibC;

/// https://en.cppreference.com/w/c/string/byte/atoi
export fn atoi(str: ?[*:0]const c_char) c_int {
    const s = str orelse return 0;

    var i: usize = 0;
    while (std.ascii.isWhitespace(@bitCast(s[i]))) {
        i += 1;
    }

    const slice = std.mem.sliceTo(s + i, 0);

    return std.fmt.parseInt(c_int, @ptrCast(slice), 10) catch return 0;
}

export fn malloc(size: usize) ?*anyopaque {
    const raw_mem = ziglibc.allocator.alloc(u8, @sizeOf(usize) + size) catch return null;
    std.mem.writeInt(usize, raw_mem[0..@sizeOf(usize)], size, ziglibc.endianness);
    const user_mem = raw_mem[@sizeOf(usize)..];
    return @ptrCast(user_mem.ptr);
}

export fn free(ptr: *anyopaque) void {
    const user_mem_ptr = @as([*]u8, @ptrCast(ptr));
    const raw_mem_ptr = user_mem_ptr - @sizeOf(usize);
    const raw_mem = @as([*]u8, @ptrCast(raw_mem_ptr));

    const size = std.mem.readInt(usize, raw_mem[0..@sizeOf(usize)], ziglibc.endianness);
    const raw_mem_slice = raw_mem[0..size];
    ziglibc.allocator.free(raw_mem_slice);
}