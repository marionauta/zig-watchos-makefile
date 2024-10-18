pub export fn something(a: c_int, b: c_int) c_int {
    return 10 * (a + b);
}

pub export fn zighello() [*:0]const u8 {
    return "Hello from Zig";
}
