module cvlm::mathint;

public native struct MathInt has copy, drop;

public fun from_u8(value: u8): MathInt { from_u256(value as u256) }
public fun from_u16(value: u16): MathInt { from_u256(value as u256) }
public fun from_u32(value: u32): MathInt { from_u256(value as u256) }
public fun from_u64(value: u64): MathInt { from_u256(value as u256) }
public fun from_u128(value: u128): MathInt { from_u256(value as u256) }
public native fun from_u256(value: u256): MathInt;

public native fun add(a: MathInt, b: MathInt): MathInt;
public native fun sub(a: MathInt, b: MathInt): MathInt;
public native fun mul(a: MathInt, b: MathInt): MathInt;
public native fun div(a: MathInt, b: MathInt): MathInt;
public native fun mod(a: MathInt, b: MathInt): MathInt;
public native fun neg(a: MathInt): MathInt;

public native fun eq(a: MathInt, b: MathInt): bool;
public fun ne(a: MathInt, b: MathInt): bool { !eq(a, b) }
public native fun lt(a: MathInt, b: MathInt): bool;
public native fun le(a: MathInt, b: MathInt): bool;
public fun gt(a: MathInt, b: MathInt): bool { b.le(a) }
public fun ge(a: MathInt, b: MathInt): bool { b.lt(a) }

public fun max(a: MathInt, b: MathInt): MathInt { if (a.ge(b)) { a } else { b } }
public fun min(a: MathInt, b: MathInt): MathInt { if (a.le(b)) { a } else { b } }
