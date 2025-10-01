#[allow(unused_function)]
module certora::std_string_summaries;

use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    summary(b"internal_check_utf8", @std, b"string", b"internal_check_utf8");
    ghost(b"internal_check_utf8");
}

native fun internal_check_utf8(v: &vector<u8>): bool;