module cvlm::nondet;

use cvlm::asserts::cvlm_assume_msg;

public native fun nondet<T>(): T;

public macro fun nondet_with<$T>($msg: vector<u8>, $f: |$T| -> bool): $T {
    let value = nondet<$T>();
    cvlm_assume_msg($f(value), $msg);
    value
}

/// Returns true if the type of T is not statically known to the Prover.  For example, a generic rule's type arguments
/// are nondeterministic; `is_nondet_type<T>()` will return true for such type arguments.
public native fun is_nondet_type<T>(): bool;