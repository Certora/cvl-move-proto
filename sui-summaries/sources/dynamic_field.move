#[allow(unused_function)]
module sui_summaries::dynamic_field;

use cvl::ref::{force_read, force_write};
use cvl::assert::cvl_assume;
use cvl::manifest::{summary, ghost_mapping, hash_fun};
use sui::object::id_address;

fun cvl_manifest() {
    ghost_mapping(b"child_object_value");
    ghost_mapping(b"child_object_present");
    ghost_mapping(b"child_object_present_ty");

    hash_fun(b"hash_type_and_key");

    summary(b"hash_type_and_key", b"sui::dynamic_field::hash_type_and_key");
    summary(b"has_child_object", b"sui::dynamic_field::has_child_object");
    summary(b"borrow_child_object", b"sui::dynamic_field::borrow_child_object");
    summary(b"add_child_object", b"sui::dynamic_field::add_child_object");
    summary(b"remove_child_object", b"sui::dynamic_field::remove_child_object");
}

// #[ghost_mapping]
native fun child_object_value<Child: key>(parent: address, id: address): &mut Child;
// #[ghost_mapping]
native fun child_object_present(parent: address, id: address): &mut bool;
// #[ghost_mapping]
native fun child_object_present_ty<Child: key>(parent: address, id: address): &mut bool;

// #[hash_fun, summary(sui::dynamic_field::hash_type_and_key)]
native fun hash_type_and_key<Key: copy + drop + store>(parent: address, key: Key): address;

// #[summary(sui::dynamic_field::has_child_object)]
fun has_child_object(parent: address, id: address): bool {
    *child_object_present(parent, id)
}

// #[summary(sui::dynamic_field::borrow_child_object)]
fun borrow_child_object<Child: key>(object: &UID, id: address): &Child {
    let parent = object.to_address();
    assert!(*child_object_present_ty<Child>(parent, id), 0);
    child_object_value(parent, id)
}

// #[summary(sui::dynamic_field::add_child_object)]
fun add_child_object<Child: key>(parent: address, child: Child) {
    let id = id_address(&child);
    let child_present = child_object_present(parent, id);
    cvl_assume(!*child_present);
    *child_present = true;
    *child_object_present_ty<Child>(parent, id) = true;
    force_write(child_object_value<Child>(parent, id), child);
}

// #[summary(sui::dynamic_field::remove_child_object)]
fun remove_child_object<Child: key>(parent: address, id: address): Child {
    let child_present = child_object_present(parent, id);
    cvl_assume(*child_present);
    *child_present = false;
    *child_object_present_ty<Child>(parent, id) = false;
    force_read(child_object_value(parent, id))
}