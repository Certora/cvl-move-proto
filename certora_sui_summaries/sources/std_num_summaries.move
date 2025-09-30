#[allow(unused_function)]
module certora::std_num_summaries;

use cvlm::manifest::summary;
use cvlm::math_int;

fun cvlm_manifest() {
    summary(b"u8_pow", @std, b"u8", b"pow");
    summary(b"u16_pow", @std, b"u16", b"pow");
    summary(b"u32_pow", @std, b"u32", b"pow");
    summary(b"u64_pow", @std, b"u64", b"pow");
    summary(b"u128_pow", @std, b"u128", b"pow");
    summary(b"u256_pow", @std, b"u256", b"pow");
}

fun u8_pow(base: u8, exp: u8): u8 { math_int::from_u8(base).pow(math_int::from_u8(exp)).to_u8() }
fun u16_pow(base: u16, exp: u8): u16 { math_int::from_u16(base).pow(math_int::from_u8(exp)).to_u16() }
fun u32_pow(base: u32, exp: u8): u32 { math_int::from_u32(base).pow(math_int::from_u8(exp)).to_u32() }
fun u64_pow(base: u64, exp: u8): u64 { math_int::from_u64(base).pow(math_int::from_u8(exp)).to_u64() }
fun u128_pow(base: u128, exp: u8): u128 { math_int::from_u128(base).pow(math_int::from_u8(exp)).to_u128() }
fun u256_pow(base: u256, exp: u8): u256 { math_int::from_u256(base).pow(math_int::from_u8(exp)).to_u256() }