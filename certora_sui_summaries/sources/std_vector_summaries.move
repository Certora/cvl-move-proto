#[allow(unused_function)]
module certora::std_vector_summaries;

use cvlm::asserts::cvlm_assume_msg;
use cvlm::ghost::{ ghost_write, ghost_destroy };
use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    summary(b"contains", @std, b"vector", b"contains");
    ghost(b"contains");
    ghost(b"index_of_element");
    summary(b"index_of", @std, b"vector", b"index_of");
    summary(b"reverse", @std, b"vector", b"reverse");
    ghost(b"reverse_ghost");
    summary(b"append", @std, b"vector", b"append");
    ghost(b"append_ghost");
    summary(b"remove", @std, b"vector", b"remove");
    ghost(b"remove_ghost");
}

// #[summary(std::vector::contains), ghost]
native fun contains<Element>(v: &vector<Element>, e: &Element): bool;

native fun index_of_element<Element>(v: &vector<Element>, e: &Element): u64;

// #[summary(std::vector::index_of)]
fun index_of<Element>(v: &vector<Element>, e: &Element): (bool, u64) {
    if (contains(v, e)) {
        let index = index_of_element(v, e);
        cvlm_assume_msg(index < v.length(), b"index is within bounds");
        cvlm_assume_msg(&v[index] == e, b"element at index matches searched element");
        (true, index)
    } else {
        (false, 0)
    }
}

// #ghost
native fun reverse_ghost<Element>(v: &vector<Element>): vector<Element>;

// #[summary(std::vector::reverse)]
fun reverse<Element>(v: &mut vector<Element>) {
    let reversed = reverse_ghost(v);
    let reversed_again = reverse_ghost(&reversed);
    cvlm_assume_msg(reversed_again == v, b"reversing twice yields the original vector");
    cvlm_assume_msg(reversed.length() == v.length(), b"reversed length matches original");
    ghost_write(v, reversed);
    ghost_destroy(reversed_again);
}

// #[ghost]
native fun append_ghost<Element>(lhs: &vector<Element>, other: vector<Element>): vector<Element>;

// #[summary(std::vector::append)]
fun append<Element>(lhs: &mut vector<Element>, other: vector<Element>) {
    let required_length = lhs.length() + other.length();
    let appended = append_ghost(lhs, other);
    cvlm_assume_msg(appended.length() == required_length, b"appended length is original plus other");
    ghost_write(lhs, appended);
}

// #[ghost]
native fun remove_ghost<Element>(v: &vector<Element>, i: u64): vector<Element>;

// #[summary(std::vector::remove)]
public fun remove<Element>(v: &mut vector<Element>, i: u64): Element {
    let v_length = v.length();
    let removed = v[i];
    v = remove_ghost(v, i);
    cvlm_assume_msg(v.length() == v_length - 1, b"length decreases by one after removal");
    removed
}