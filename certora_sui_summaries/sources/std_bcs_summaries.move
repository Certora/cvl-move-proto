#[allow(unused_function)]
module certora::std_bcs_summaries;

use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    summary(b"to_bytes", @std, b"bcs", b"to_bytes");
    ghost(b"to_bytes");
}

// #[summary(std::bcs::to_bytes), ghost]
native fun to_bytes<MoveValue>(value: &MoveValue): vector<u8>;
