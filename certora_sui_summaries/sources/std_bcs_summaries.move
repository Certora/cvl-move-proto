#[allow(unused_function)]
module certora::std_bcs_summaries;

use cvlm::nondet::nondet;
use cvlm::manifest::summary;

fun cvlm_manifest() {
    summary(b"to_bytes", @std, b"bcs", b"to_bytes");
}

// #[summary(std::bcs::to_bytes)]
fun to_bytes<MoveValue>(_: &MoveValue): vector<u8> { nondet() }
