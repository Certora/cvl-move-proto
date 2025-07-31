#[allow(unused_function)]
module certora::sui_tx_context_summaries;

use cvlm::asserts::cvlm_assume_msg;
use cvlm::nondet::nondet;
use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    ghost(b"sender");
    ghost(b"epoch");
    ghost(b"epoch_timestamp_ms");
    ghost(b"gas_price");
    ghost(b"gas_budget");
    ghost(b"sponsor");

    summary(b"native_sender", @sui, b"tx_context", b"native_sender");
    summary(b"native_epoch", @sui, b"tx_context", b"native_epoch");
    summary(b"native_epoch_timestamp_ms", @sui, b"tx_context", b"native_epoch_timestamp_ms");
    summary(b"native_gas_price", @sui, b"tx_context", b"native_gas_price");
    summary(b"native_gas_budget", @sui, b"tx_context", b"native_gas_budget");
    summary(b"native_sponsor", @sui, b"tx_context", b"native_sponsor");
    summary(b"fresh_id", @sui, b"tx_context", b"fresh_id");
}

// #[ghost]
native fun sender(): &mut address;
// #[ghost]
native fun epoch(): &mut u64;
// #[ghost]
native fun epoch_timestamp_ms(): &mut u64;
// #[ghost]
native fun gas_price(): &mut u64;
// #[ghost]
native fun gas_budget(): &mut u64;
// #[ghost]
native fun sponsor(): &mut vector<address>;

// #[summary(sui::tx_context::native_sender)]
fun native_sender(): address { *sender() }

// #[summary(sui::tx_context::native_epoch)]
fun native_epoch(): u64 { *epoch() }

// #[summary(sui::tx_context::native_epoch_timestamp_ms)]
fun native_epoch_timestamp_ms(): u64 { *epoch_timestamp_ms() }

// #[summary(sui::tx_context::native_gas_price)]
fun native_gas_price(): u64 { *gas_price() }

// #[summary(sui::tx_context::native_gas_budget)]
fun native_gas_budget(): u64 { *gas_budget() }

// #[summary(sui::tx_context::native_sponsor)]
fun native_sponsor(): vector<address> {
    // The sponsor vector is effectively an option<address>; it has at most one element.
    cvlm_assume_msg(sponsor().length() <= 1, b"sponsor vector has at most one element");
    *sponsor()
}

// #[summary(sui::tx_context::fresh_id)]
fun fresh_id(): address {
    let id = nondet<address>();
    certora::sui_object_summaries::record_new_uid(id);
    id
}