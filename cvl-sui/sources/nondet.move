module cvl_sui::nondet;

/// Returns a nondeterministic value of type T.
public macro fun nondet<$T>(): $T {
    cvl_sui::intrinsics::CVT_havoc()
}
