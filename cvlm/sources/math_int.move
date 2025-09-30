module cvlm::math_int;

/// An arbitrary-precision signed integer type.
public native struct MathInt has copy, drop;

public fun zero(): MathInt { from_u256(0) }
public fun one(): MathInt { from_u256(1) }

public fun from_u8(value: u8): MathInt { from_u256(value as u256) }
public fun from_u16(value: u16): MathInt { from_u256(value as u256) }
public fun from_u32(value: u32): MathInt { from_u256(value as u256) }
public fun from_u64(value: u64): MathInt { from_u256(value as u256) }
public fun from_u128(value: u128): MathInt { from_u256(value as u256) }
public native fun from_u256(value: u256): MathInt;
public fun from(value: u256): MathInt { from_u256(value) }

public fun to_u8(value: MathInt): u8 { value.to_u256() as u8 }
public fun to_u16(value: MathInt): u16 { value.to_u256() as u16 }
public fun to_u32(value: MathInt): u32 { value.to_u256() as u32 }
public fun to_u64(value: MathInt): u64 { value.to_u256() as u64 }
public fun to_u128(value: MathInt): u128 { value.to_u256() as u128 }
public native fun to_u256(value: MathInt): u256;

public native fun add(a: MathInt, b: MathInt): MathInt;
public native fun sub(a: MathInt, b: MathInt): MathInt;
public native fun mul(a: MathInt, b: MathInt): MathInt;
public native fun div(a: MathInt, b: MathInt): MathInt;
public native fun mod(a: MathInt, b: MathInt): MathInt;
public native fun pow(a: MathInt, b: MathInt): MathInt;

public native fun lt(a: MathInt, b: MathInt): bool;
public native fun le(a: MathInt, b: MathInt): bool;
public native fun gt(a: MathInt, b: MathInt): bool;
public native fun ge(a: MathInt, b: MathInt): bool;

public fun max(a: MathInt, b: MathInt): MathInt { if (a.ge(b)) { a } else { b } }
public fun min(a: MathInt, b: MathInt): MathInt { if (a.le(b)) { a } else { b } }
public fun neg(a: MathInt): MathInt { zero().sub(a) }
public fun abs(a: MathInt): MathInt { if (a.ge(zero())) { a } else { neg(a) } }
