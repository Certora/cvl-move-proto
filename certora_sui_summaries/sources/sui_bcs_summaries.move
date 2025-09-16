#[allow(unused_function)]
module certora::sui_bcs_summaries;

use sui::bcs::BCS;

use cvlm::nondet::nondet;
use cvlm::manifest::{ summary, shadow, ghost };
use cvlm::asserts::cvlm_assume_msg;

fun cvlm_manifest() {
    shadow(b"shadow_bcs");
    ghost(b"peel_size_map");
    ghost(b"peel_value_map");
    ghost(b"peel_remainder_map");
    summary(b"new", @sui, b"bcs", b"new");
    summary(b"into_remainder_bytes", @sui, b"bcs", b"into_remainder_bytes");
    summary(b"peel_u8", @sui, b"bcs", b"peel_u8");
    summary(b"peel_vec_u8", @sui, b"bcs", b"peel_vec_u8");
    summary(b"peel_vec_u64", @sui, b"bcs", b"peel_vec_u64");
    summary(b"peel_vec_vec_u8", @sui, b"bcs", b"peel_vec_vec_u8");
}

// Replace the BCS struct with a simple vector, holding the remaining bytes to be deserialized.  Unlike the Sui BCS
// implementation, we don't reverse this vector.
native fun shadow_bcs(_: &BCS): &mut vector<u8>;

fun new(bytes: vector<u8>): BCS { 
    let bcs = nondet<BCS>();
    *shadow_bcs(&bcs) = bytes;
    bcs
}

fun into_remainder_bytes(bcs: BCS): vector<u8> { 
    *shadow_bcs(&bcs)
}

// Maps remaining bytes to the size of the next value of type T.  Note that we don't model the size precisely, but just
// provide consistent results.
native fun peel_size_map<T>(remainder: vector<u8>): u64;

// Maps remaining bytes to the next value of type T.  We don't model the value precisely, but just provide consistent 
// results.
native fun peel_value_map<T>(remainder: vector<u8>): T;

// Maps remaining bytes to the remaining bytes after peeling a value of type T. We don't model this precisely, but just 
// provide consistent results.
native fun peel_remainder_map<T>(remainder: vector<u8>): vector<u8>;

fun peel<T>(bcs: &mut BCS): T {
    let shadow = shadow_bcs(bcs);
    let prev_vec = *shadow;
    let peelSize = peel_size_map<T>(prev_vec);
    cvlm_assume_msg(peelSize > 0, b"peel size must be greater than zero");
    let new_vec = peel_remainder_map<T>(prev_vec);
    cvlm_assume_msg(new_vec.length() == prev_vec.length() - peelSize, b"remainder length must decrease");
    cvlm_assume_msg(new_vec != prev_vec, b"new vector must be different from previous vector");
    *shadow = new_vec;
    peel_value_map<T>(prev_vec)
}

fun peel_u8(bcs: &mut BCS): u8 { peel(bcs) }
fun peel_vec_u8(bcs: &mut BCS): vector<u8> { peel(bcs) }
fun peel_vec_u64(bcs: &mut BCS): vector<u64> { peel(bcs) }
fun peel_vec_vec_u8(bcs: &mut BCS): vector<vector<u8>> { peel(bcs) }
