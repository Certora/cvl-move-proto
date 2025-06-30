#[allow(unused_function)]
module certora::sui_ecdsa_k1_summaries;

use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    ghost(b"ghost_secp256k1_ecrecover");
    ghost(b"ghost_decompress_pubkey");
    summary(b"secp256k1_ecrecover", @sui, b"ecdsa_k1", b"secp256k1_ecrecover");
    summary(b"decompress_pubkey", @sui, b"ecdsa_k1", b"decompress_pubkey");
}

// #[ghost]
native fun ghost_secp256k1_ecrecover(
    signature: &vector<u8>,
    msg: &vector<u8>,
    hash: u8,
): vector<u8>;

// #[summary(sui::ecdsa_k1::secp256k1_ecrecover)]
fun secp256k1_ecrecover(
    signature: &vector<u8>,
    msg: &vector<u8>,
    hash: u8,
): vector<u8> {
    assert!(signature.length() == 65);
    ghost_secp256k1_ecrecover(signature, msg, hash)
}

// #[ghost]
native fun ghost_decompress_pubkey(pubkey: &vector<u8>): &vector<u8>;

// #[summary(sui::ecdsa_k1::decompress_pubkey)]
fun decompress_pubkey(pubkey: &vector<u8>): vector<u8> {
    *ghost_decompress_pubkey(pubkey)
}