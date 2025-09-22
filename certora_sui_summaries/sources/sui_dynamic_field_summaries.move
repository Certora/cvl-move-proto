#[allow(unused_function)]
module certora::sui_dynamic_field_summaries;

use cvlm::asserts::cvlm_assume_msg;
use cvlm::ghost::{ ghost_read, ghost_write };
use cvlm::manifest::{ summary, ghost, hash };
use std::type_name;
use std::type_name::TypeName;
use sui::object::id_address;

fun cvlm_manifest() {
    ghost(b"child_object_value");
    ghost(b"child_object_type");

    hash(b"raw_hash_type_and_key");

    summary(b"hash_type_and_key", @sui, b"dynamic_field", b"hash_type_and_key");
    summary(b"has_child_object", @sui, b"dynamic_field", b"has_child_object");
    summary(b"has_child_object_with_ty", @sui, b"dynamic_field", b"has_child_object_with_ty");
    summary(b"borrow_child_object", @sui, b"dynamic_field", b"borrow_child_object");
    summary(b"borrow_child_object_mut", @sui, b"dynamic_field", b"borrow_child_object_mut");
    summary(b"add_child_object", @sui, b"dynamic_field", b"add_child_object");
    summary(b"remove_child_object", @sui, b"dynamic_field", b"remove_child_object");
}

// #[ghost]
native fun child_object_value<Child: key>(parent: address, id: address): &mut Child;
// #[ghost]
native fun child_object_type(parent: address, id: address): &mut TypeName;

// Type for use in child_object_type, when the child object is not present.
public struct NotPresent {}


// #[hash]
native fun raw_hash_type_and_key<Key: copy + drop + store>(parent: address, key: Key): u256;

// #[summary(sui::dynamic_field::hash_type_and_key)]
fun hash_type_and_key<Key: copy + drop + store>(parent: address, key: Key): address {
    sui::address::from_u256(raw_hash_type_and_key(parent, key))
}

// #[summary(sui::dynamic_field::has_child_object)]
fun has_child_object(parent: address, id: address): bool {
    child_object_type(parent, id) != type_name::get<NotPresent>()
}

// #[summary(sui::dynamic_field::has_child_object_with_ty)]
fun has_child_object_with_ty<Child: key>(parent: address, id: address): bool {
    *child_object_type(parent, id) == type_name::get<Child>()
}

// #[summary(sui::dynamic_field::borrow_child_object)]
fun borrow_child_object<Child: key>(object: &UID, id: address): &Child {
    let parent = object.to_address();
    assert!(has_child_object_with_ty<Child>(parent, id));
    child_object_value(parent, id)
}

// #[summary(sui::dynamic_field::borrow_child_object_mut)]
#[allow(unused_mut_parameter)]
fun borrow_child_object_mut<Child: key>(object: &mut UID, id: address): &mut Child {
    let parent = object.to_address();
    assert!(has_child_object_with_ty<Child>(parent, id));
    child_object_value(parent, id)
}

// #[summary(sui::dynamic_field::add_child_object)]
fun add_child_object<Child: key>(parent: address, child: Child) {
    let id = id_address(&child);
    assert!(!has_child_object(parent, id));
    *child_object_type(parent, id) = type_name::get<Child>();
    ghost_write(child_object_value(parent, id), child);
}

// #[summary(sui::dynamic_field::remove_child_object)]
fun remove_child_object<Child: key>(parent: address, id: address): Child {
    assert!(has_child_object_with_ty<Child>(parent, id));
    *child_object_type(parent, id) = type_name::get<NotPresent>();
    ghost_read(child_object_value(parent, id))
}