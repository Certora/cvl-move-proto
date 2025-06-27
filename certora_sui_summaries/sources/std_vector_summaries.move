#[allow(unused_function)]
module certora::std_vector_summaries;

use cvlm::asserts::cvlm_assume;
use cvlm::ghost::{ ghost_write, ghost_destroy };
use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    summary(b"contains", @std, b"vector", b"contains");
    ghost(b"contains");
    summary(b"reverse", @std, b"vector", b"reverse");
    ghost(b"reverse_ghost");
    summary(b"append", @std, b"vector", b"append");
    ghost(b"append_ghost");
}

// #[summary(std::vector::contains), ghost]
native fun contains<Element>(v: &vector<Element>, e: &Element): bool;


// #ghost
native fun reverse_ghost<Element>(v: &vector<Element>): vector<Element>;

// #[summary(std::vector::reverse)]
fun reverse<Element>(v: &mut vector<Element>) {
    let reversed = reverse_ghost(v);
    let reversed_again = reverse_ghost(&reversed);
    cvlm_assume!(reversed_again == v);
    cvlm_assume!(reversed.length() == v.length());
    ghost_write(v, reversed);
    ghost_destroy(reversed_again);
}

// #[ghost]
native fun append_ghost<Element>(lhs: &vector<Element>, other: vector<Element>): vector<Element>;

// #[summary(std::vector::append)]
fun append<Element>(lhs: &mut vector<Element>, other: vector<Element>) {
    let required_length = lhs.length() + other.length();
    let appended = append_ghost(lhs, other);
    cvlm_assume!(appended.length() == required_length);
    ghost_write(lhs, appended);
}