#[allow(unused_function)]
module certora::std_vector_summaries;

use cvlm::nondet::nondet;
use cvlm::manifest::summary;

fun cvlm_manifest() {
    summary(b"contains", @std, b"vector", b"contains");
}

// #[summary(std::vector::contains)]
fun contains<Element>(_: &vector<Element>, _: &Element): bool { nondet() }
