module cvl_sui::intrinsics;

public native fun CVT_assert(cond: bool);
public native fun CVT_assume(cond: bool);
public native fun CVT_havoc<T>(): T;
public native fun CVT_summarize(summarized: vector<u8>);
