#[allow(unused_function)]
module certora::std_bcs_summaries;

use cvlm::nondet::nondet;
use cvlm::manifest::{ summary, ghost };
use cvlm::ghost;
use std::bcs;

fun cvlm_manifest() {
    ghost(b"bcs_encode");
    summary(b"to_bytes", @std, b"bcs", b"to_bytes");
}

// #[ghost]
native fun bcs_encode<MoveValue>(value: &MoveValue): &vector<u8>;

// #[summary(std::bcs::to_bytes)]
fun to_bytes<MoveValue>(value: &MoveValue): vector<u8> { *bcs_encode(value) }
