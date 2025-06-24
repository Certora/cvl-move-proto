#[allow(unused_function)]
module certora::sui_ecdsa_k1_summaries;

use cvlm::nondet::nondet;
use cvlm::manifest::summary;

fun cvlm_manifest() {
    summary(b"secp256k1_ecrecover", @sui, b"ecdsa_k1", b"secp256k1_ecrecover");
    summary(b"decompress_pubkey", @sui, b"ecdsa_k1", b"decompress_pubkey");
}

// #[summary(sui::ecdsa_k1::secp256k1_ecrecover)]
fun secp256k1_ecrecover(_: &vector<u8>, _: &vector<u8>, _: u8): vector<u8> { nondet() }

// #[summary(sui::ecdsa_k1::decompress_pubkey)]
fun decompress_pubkey(_: &vector<u8>): vector<u8> { nondet() }