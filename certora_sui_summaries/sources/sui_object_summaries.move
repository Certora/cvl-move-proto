#[allow(unused_function)]
module certora::sui_object_summaries;

use cvlm::asserts::cvlm_assume;
use cvlm::manifest::{ summary, ghost, field_access };

fun cvlm_manifest() {
    ghost(b"is_id");
    summary(b"record_new_id", @sui, b"object", b"record_new_id");
    summary(b"delete_impl", @sui, b"object", b"delete_impl");
    field_access(b"borrow_uid", b"id");
}

// #field_access(id)
native fun borrow_uid<T: key>(obj: &T): &UID;

// #[ghost]
native fun is_id(id: address): &mut bool;

// #[summary(sui::object::record_new_id)]
fun record_new_id(id: address) {
    let is_id = is_id(id);
    cvlm_assume!(!*is_id(id));
    *is_id = true;
}

public fun delete_impl(_: address) {
    // The Sui implementation does some bookkeeping that isn't visible to user code
}

