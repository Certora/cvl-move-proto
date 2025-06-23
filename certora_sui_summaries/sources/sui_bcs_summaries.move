#[allow(unused_function)]
module certora::sui_bcs_summaries;

use sui::bcs::BCS;

use cvlm::nondet::nondet;
use cvlm::manifest::summary;

fun cvlm_manifest() {
    summary(b"peel_vec_u8", @sui, b"bcs", b"peel_vec_u8");
}

// #[summary(sui::bcs::peel_vec_u8)]
fun peel_vec_u8(_: &mut BCS): vector<u8> { nondet() }