#[allow(unused_function)]
module certora::std_u8_summaries;

use cvlm::manifest::{ summary, ghost };
use std::string::String;

fun cvlm_manifest() {
    ghost(b"to_string");
    summary(b"to_string", @std, b"u8", b"to_string");
}

native fun to_string(x: u8): String;