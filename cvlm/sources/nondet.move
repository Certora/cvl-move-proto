module cvlm::nondet;

use cvlm::asserts::cvlm_assume;

public native fun nondet<T>(): T;

public macro fun nondet_with<$T>($f: |$T| -> bool): $T {
    let value = nondet<$T>();
    cvlm_assume!($f(value));
    value
}
