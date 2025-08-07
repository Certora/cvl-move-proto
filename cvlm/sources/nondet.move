module cvlm::nondet;

use cvlm::asserts::cvlm_assume_msg;

public native fun nondet<T>(): T;

public macro fun nondet_with<$T>($msg: vector<u8>, $f: |$T| -> bool): $T {
    let value = nondet<$T>();
    cvlm_assume_msg($f(value), $msg);
    value
}
