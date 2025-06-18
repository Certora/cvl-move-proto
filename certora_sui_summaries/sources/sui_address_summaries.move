#[allow(unused_function)]
module certora::sui_address_summaries;

use cvlm::manifest::summary;
use cvlm::conversions::u256_to_address;

fun cvlm_manifest() {
    summary(b"from_u256", @sui, b"address", b"from_u256");
}

fun from_u256(n: u256): address { u256_to_address(n) }