#[allow(unused_function)]
module certora::sui_funds_accumulator_summaries;

use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    ghost(b"accumulator_deposits");
    summary(
        b"add_to_accumulator_address",
        @sui,
        b"funds_accumulator",
        b"add_to_accumulator_address",
    );
}

public struct AccumulatorDeposit<T: store> {
    accumulator: address,
    recipient: address,
    value: T,
}

// #[ghost]
public native fun accumulator_deposits<T: store>(): &mut vector<AccumulatorDeposit<T>>;

// #[summary(sui::funds_accumulator::add_to_accumulator_address)]
fun add_to_accumulator_address<T: store>(accumulator: address, recipient: address, value: T) {
    accumulator_deposits<T>().push_back(
        AccumulatorDeposit<T> { accumulator, recipient, value },
    );
}