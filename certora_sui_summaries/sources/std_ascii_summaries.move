#[allow(unused_function)]
module certora::std_ascii_summaries;

use cvlm::manifest::{ summary };
use cvlm::nondet::nondet;
use std::ascii::String;

fun cvlm_manifest() {
    summary(b"try_string", @std, b"ascii", b"try_string");
}

public fun try_string(_: vector<u8>): Option<String> {
    nondet()
}