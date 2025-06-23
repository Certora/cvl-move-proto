#[allow(unused_function)]
module certora::sui_hex_summaries;

use cvlm::nondet::nondet;
use cvlm::manifest::{ summary };

fun cvlm_manifest() {
    summary(b"encode", @sui, b"hex", b"encode");
    summary(b"decode", @sui, b"hex", b"decode");
}

// #[summary(sui::hex::encode)]
fun encode(_: vector<u8>): vector<u8> { nondet() }

// #[summary(sui::hex::decode)]
fun decode(_: vector<u8>): vector<u8> { nondet()}