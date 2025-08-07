module cvlm::asserts;

public native fun cvlm_assert(cond: bool);
public native fun cvlm_assert_msg(cond: bool, msg: vector<u8>);
public native fun cvlm_satisfy(cond: bool);
public native fun cvlm_satisfy_msg(cond: bool, msg: vector<u8>);
public native fun cvlm_assume_msg(cond: bool, msg: vector<u8>);
