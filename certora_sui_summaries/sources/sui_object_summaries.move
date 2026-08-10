#[allow(unused_function)]
module certora::sui_object_summaries;

use cvlm::asserts::cvlm_assume_msg;
use cvlm::manifest::{ summary, ghost, field_access };
use cvlm::nondet::is_nondet_type;

fun cvlm_manifest() {
    ghost(b"is_id");
    ghost(b"deleted");
    field_access(b"borrow_uid_field", b"id");
    ghost(b"borrow_nondet_type_uid");
    // summary(b"record_new_uid", @sui, b"object", b"record_new_uid");
    summary(b"record_new_uid_from_hash", @sui, b"object", b"record_new_uid_from_hash");
    summary(b"delete_impl", @sui, b"object", b"delete_impl");
    summary(b"borrow_uid", @sui, b"object", b"borrow_uid");
    
}


// #[ghost]
public native fun deleted(id: address): &mut bool;

// #[field_access(id)]
native fun borrow_uid_field<T: key>(obj: &T): &UID;

// #[ghost]
native fun borrow_nondet_type_uid<T>(obj: &T): &UID;

// #[summary(sui::object::borrow_uid)]
fun borrow_uid<T: key>(obj: &T): &UID {
    if (is_nondet_type<T>()) {
        borrow_nondet_type_uid(obj)
    } else {
        borrow_uid_field(obj)
    }
}

// #[ghost]
native fun is_id(id: address): &mut bool;

// #[summary(sui::object::record_new_uid)]
public fun record_new_uid(id: address) {
    let is_id = is_id(id);
    cvlm_assume_msg(!*is_id, b"id is newly allocated");
    *is_id = true;
}

// #[summary(sui::object::record_new_uid_from_hash)]
public fun record_new_uid_from_hash(parent: address, bytes: address) {
    let is_id = is_id(bytes);
    cvlm_assume_msg(!*is_id, b"id is newly allocated");
    *is_id = true;
}

// #[summary(sui::object::delete_impl)]
fun delete_impl(id: address) {
    cvlm_assume_msg(!*deleted(id), b"Deleted existing object");
    *deleted(id) = true;
}

