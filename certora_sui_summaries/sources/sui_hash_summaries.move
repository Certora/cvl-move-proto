#[allow(unused_function)]
module certora::sui_hash_summaries;

use cvlm::nondet::nondet;
use cvlm::manifest::summary;

fun cvlm_manifest() {
    summary(b"keccak256", @sui, b"hash", b"keccak256");
}

// #[summary(sui::hash::keccak256)]
fun keccak256(_: &vector<u8>): vector<u8> { nondet()}