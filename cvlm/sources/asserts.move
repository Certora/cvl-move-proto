module cvlm::asserts;

public native fun cvlm_assert_checked(cond: bool);
public native fun cvlm_assume_checked(cond: bool);

public macro fun cvlm_assert($cond: bool) {
    cvlm_assert_checked($cond);
}
public macro fun cvlm_assume($cond: bool) {
    cvlm_assume_checked($cond);
}
