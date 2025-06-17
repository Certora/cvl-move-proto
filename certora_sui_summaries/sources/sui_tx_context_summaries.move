#[allow(unused_function)]
module certora::sui_tx_context_summaries;

use cvlm::asserts::cvlm_assume;
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
}

native fun sender(): &mut address;
fun native_sender(): address { *sender() }

native fun epoch(): &mut u64;
fun native_epoch(): u64 { *epoch() }

native fun epoch_timestamp_ms(): &mut u64;
fun native_epoch_timestamp_ms(): u64 { *epoch_timestamp_ms() }

native fun gas_price(): &mut u64;
fun native_gas_price(): u64 { *gas_price() }

native fun gas_budget(): &mut u64;
fun native_gas_budget(): u64 { *gas_budget() }

native fun sponsor(): &mut vector<address>;
fun native_sponsor(): vector<address> {
    // The sponsor vector is effectively an option<address>; it has at most one element.
    cvlm_assume!(sponsor().length() <= 1);
    *sponsor()
}