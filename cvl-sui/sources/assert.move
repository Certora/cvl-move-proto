module cvl_sui::assert;

/// Instructs the Certora Prover to assert that the condition `cond` holds.
public macro fun cvl_assert($cond: bool) {
    cvl_sui::intrinsics::CVT_assert($cond);
}
/// Instructs the Certora Prover to assume that the condition `cond` holds.
public macro fun cvl_assume($cond: bool) {
    cvl_sui::intrinsics::CVT_assume($cond);
}
