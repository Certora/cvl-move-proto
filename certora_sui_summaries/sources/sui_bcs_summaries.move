#[allow(unused_function)]
module certora::sui_bcs_summaries;

use sui::bcs::BCS;

use cvlm::nondet::nondet;
use cvlm::manifest::{ summary, shadow };

fun cvlm_manifest() {
    shadow(b"shadow_bcs");
    summary(b"new", @sui, b"bcs", b"new");
    summary(b"peel_u8", @sui, b"bcs", b"peel_u8");
    summary(b"peel_vec_u8", @sui, b"bcs", b"peel_vec_u8");
    summary(b"peel_vec_u64", @sui, b"bcs", b"peel_vec_u64");
    summary(b"peel_vec_vec_u8", @sui, b"bcs", b"peel_vec_vec_u8");
    summary(b"into_remainder_bytes", @sui, b"bcs", b"into_remainder_bytes");
}

// Shadow BCS just to make sure the Sui implementation is not used
public struct ShadowBCS has copy, drop, store {}

// #[shadow]
native fun shadow_bcs(_: &BCS): &mut ShadowBCS;

// #[summary(sui::bcs::new)]
fun new(_: vector<u8>): BCS { nondet()}

// #[summary(sui::bcs::peel_u8)]
fun peel_u8(_: &mut BCS): u8 { nondet() }

// #[summary(sui::bcs::peel_vec_u8)]
fun peel_vec_u8(_: &mut BCS): vector<u8> { nondet() }

// #[summary(sui::bcs::peel_vec_u64)]
fun peel_vec_u64(_: &mut BCS): vector<u64> { nondet() }

// #[summary(sui::bcs::peel_vec_vec_u8)]
fun peel_vec_vec_u8(_: &mut BCS): vector<vector<u8>> { nondet() }

// #[summary(sui::bcs::into_remainder_bytes)]
fun into_remainder_bytes(_: BCS): vector<u8> { nondet() }