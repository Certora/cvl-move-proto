module cvlm::asserts;

public native fun cvlm_assert_checked(cond: bool);
public native fun cvlm_assert_checked_msg(cond: bool, msg: vector<u8>);
public native fun cvlm_assume_checked(cond: bool);
public native fun cvlm_assume_checked_msg(cond: bool, msg: vector<u8>);

public macro fun cvlm_assert($cond: bool) {
    cvlm_assert_checked_msg($cond);
}
public macro fun cvlm_assert_msg($cond: bool, $msg: vector<u8>) {
    cvlm_assert_checked_msg($cond, $msg);
}
public macro fun cvlm_assume($cond: bool) {
    cvlm_assume_checked($cond);
}
public macro fun cvlm_assume_msg($cond: bool, $msg: vector<u8>) {
    cvlm_assume_checked_msg($cond, $msg);
}
