#[allow(unused_function)]
module certora::std_debug_summaries;

use cvlm::manifest::summary;

fun cvlm_manifest() {
    summary(b"print", @std, b"debug", b"print");
}

fun print<T>(_: &T) {}
