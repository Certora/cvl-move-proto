#[allow(unused_function)]
module certora::std_vector_summaries;

use cvlm::asserts::cvlm_assume;
use cvlm::ghost::{ ghost_write, destroy };
use cvlm::nondet::nondet;
use cvlm::manifest::summary;

fun cvlm_manifest() {
    summary(b"contains", @std, b"vector", b"contains");
    summary(b"reverse", @std, b"vector", b"reverse");
    summary(b"append", @std, b"vector", b"append");
}

// #[summary(std::vector::contains)]
fun contains<Element>(_: &vector<Element>, _: &Element): bool { nondet() }

// #[summary(std::vector::reverse)]
fun reverse<Element>(v: &mut vector<Element>) {
    // TODO consider adding a cvlr function to reverse a vector
    let len = v.length();
    ghost_write(v, nondet());
    cvlm_assume!(v.length() == len);
}

// #[summary(std::vector::append)]
fun append<Element>(lhs: &mut vector<Element>, other: vector<Element>) {
    // TODO consider adding a cvlr function to relate a vector region to another vector region
    let len = lhs.length();
    ghost_write(lhs, nondet());
    cvlm_assume!(lhs.length() == len + other.length());
    destroy(other);
}