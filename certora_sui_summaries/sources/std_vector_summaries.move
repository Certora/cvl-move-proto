#[allow(unused_function)]
module certora::std_vector_summaries;

use cvlm::asserts::cvlm_assume;
use cvlm::ghost::ghost_write;
use cvlm::nondet::nondet;
use cvlm::manifest::summary;

fun cvlm_manifest() {
    summary(b"contains", @std, b"vector", b"contains");
    summary(b"reverse", @std, b"vector", b"reverse");
}

// #[summary(std::vector::contains)]
fun contains<Element>(_: &vector<Element>, _: &Element): bool { nondet() }

// #[summary(std::vector::reverse)]
fun reverse<Element>(v: &mut vector<Element>) {
    let len = v.length();
    ghost_write(v, nondet());
    cvlm_assume!(v.length() == len);
}