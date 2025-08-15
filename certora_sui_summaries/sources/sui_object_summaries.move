#[allow(unused_function)]
module certora::sui_object_summaries;

use cvlm::asserts::cvlm_assume_msg;
use cvlm::manifest::{ summary, ghost, field_access };

fun cvlm_manifest() {
    ghost(b"is_id");
    ghost(b"deleted");
    field_access(b"borrow_uid", b"id");
    summary(b"record_new_uid", @sui, b"object", b"record_new_uid");
    summary(b"delete_impl", @sui, b"object", b"delete_impl");
    summary(b"borrow_uid", @sui, b"object", b"borrow_uid");
    
}


public native fun deleted(id: address): &mut bool;

// #[field_access(id), summary(sui::object::borrow_uid)]
native fun borrow_uid<T: key>(obj: &T): &UID;

// #[ghost]
native fun is_id(id: address): &mut bool;

// #[summary(sui::object::record_new_uid)]
public fun record_new_uid(id: address) {
    let is_id = is_id(id);
    cvlm_assume_msg(!*is_id, b"id is newly allocated");
    *is_id = true;
}

// #[summary(sui::object::delete_impl)]
fun delete_impl(id: address) {
    cvlm_assume_msg(!*deleted(id), b"Deleted existing object");
    *deleted(id) = true;
}

