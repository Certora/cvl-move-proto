#[allow(unused_function)]
module certora::sui_dynamic_field_summaries;

use cvlm::asserts::cvlm_assume;
use cvlm::ghost::{ ghost_read, ghost_write };
use cvlm::manifest::{ summary, ghost, hash };
use sui::object::id_address;

fun cvlm_manifest() {
    ghost(b"child_object_value");
    ghost(b"child_object_present");
    ghost(b"child_object_present_ty");

    hash(b"hash_type_and_key");

    summary(b"hash_type_and_key", @sui, b"dynamic_field", b"hash_type_and_key");
    summary(b"has_child_object", @sui, b"dynamic_field", b"has_child_object");
    summary(b"borrow_child_object", @sui, b"dynamic_field", b"borrow_child_object");
    summary(b"borrow_child_object_mut", @sui, b"dynamic_field", b"borrow_child_object_mut");
    summary(b"add_child_object", @sui, b"dynamic_field", b"add_child_object");
    summary(b"remove_child_object", @sui, b"dynamic_field", b"remove_child_object");
}

// #[ghost]
native fun child_object_value<Child: key>(parent: address, id: address): &mut Child;
// #[ghost]
native fun child_object_present(parent: address, id: address): &mut bool;
// #[ghost]
native fun child_object_present_ty<Child: key>(parent: address, id: address): &mut bool;

// #[hash, summary(sui::dynamic_field::hash_type_and_key)]
native fun hash_type_and_key<Key: copy + drop + store>(parent: address, key: Key): address;

// #[summary(sui::dynamic_field::has_child_object)]
fun has_child_object(parent: address, id: address): bool {
    *child_object_present(parent, id)
}

// #[summary(sui::dynamic_field::borrow_child_object)]
fun borrow_child_object<Child: key>(object: &UID, id: address): &Child {
    borrow_child_object_mut<Child>(object, id)
}

// #[summary(sui::dynamic_field::borrow_child_object_mut)]
fun borrow_child_object_mut<Child: key>(object: &UID, id: address): &mut Child {
    let parent = object.to_address();
    assert!(*child_object_present_ty<Child>(parent, id), 0);
    child_object_value(parent, id)
}

// #[summary(sui::dynamic_field::add_child_object)]
fun add_child_object<Child: key>(parent: address, child: Child) {
    let id = id_address(&child);
    let child_present = child_object_present(parent, id);
    cvlm_assume!(!*child_present);
    *child_present = true;
    *child_object_present_ty<Child>(parent, id) = true;
    ghost_write(child_object_value<Child>(parent, id), child);
}

// #[summary(sui::dynamic_field::remove_child_object)]
fun remove_child_object<Child: key>(parent: address, id: address): Child {
    let child_present = child_object_present(parent, id);
    cvlm_assume!(*child_present);
    *child_present = false;
    *child_object_present_ty<Child>(parent, id) = false;
    ghost_read(child_object_value(parent, id))
}