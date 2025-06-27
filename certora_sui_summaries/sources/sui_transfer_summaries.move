#[allow(unused_function)]
module certora::sui_transfer_summaries;

use cvlm::ghost::ghost_destroy;
use cvlm::nondet::nondet;
use cvlm::manifest::summary;

fun cvlm_manifest() {
    summary(b"transfer_impl", @sui, b"transfer", b"transfer_impl");
    summary(b"freeze_object_impl", @sui, b"transfer", b"freeze_object_impl");
}

// #[summary(sui::transfer::transfer_impl)]
fun transfer_impl<T: key>(obj: T, _recipient: address) {
    ghost_destroy(obj);
}

// #[summary(sui::transfer::freeze_object_impl)]
fun freeze_object_impl<T: key>(obj: T) {
    ghost_destroy(obj);
}