#[allow(unused_function)]
module certora::sui_transfer_summaries;

use cvlm::ghost::ghost_destroy;
use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    ghost(b"transfers");
    summary(b"transfer_impl", @sui, b"transfer", b"transfer_impl");
    summary(b"freeze_object_impl", @sui, b"transfer", b"freeze_object_impl");
}

public struct Transfer<T: key> {
    value: T,
    recipient: address
}
public fun value<T: key>(transfer: &Transfer<T>): &T { &transfer.value }
public fun recipient<T: key>(transfer: &Transfer<T>): address { transfer.recipient }

// #[ghost]
public native fun transfers<T: key>(): &mut vector<Transfer<T>>;

// #[summary(sui::transfer::transfer_impl)]
fun transfer_impl<T: key>(obj: T, recipient: address) {
    transfers<T>().push_back(
        Transfer<T> {
            value: obj,
            recipient: recipient
        }
    );
}

// #[summary(sui::transfer::freeze_object_impl)]
fun freeze_object_impl<T: key>(obj: T) {
    ghost_destroy(obj);
}