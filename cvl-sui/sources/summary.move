module cvl_sui::summary;

/// Marks a function as a summary function, summarizing the behavior of `$summarized`.
public macro fun summary($summarized: vector<u8>) {
    cvl_sui::intrinsics::CVT_summarize($summarized);
}