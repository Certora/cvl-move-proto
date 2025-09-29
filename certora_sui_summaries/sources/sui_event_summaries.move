#[allow(unused_function)]
module certora::sui_event_summaries;

use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    ghost(b"event_count");
    ghost(b"events");

    summary(b"emit", @sui, b"event", b"emit");
}

//#[ghost]
public(package) native fun event_count(): &mut u32;

//#[ghost]
public(package) native fun events<T: copy + drop>(): &mut vector<T>;

// #[summary(sui::event::emit)]
fun emit<T: copy + drop>(event: T) {
    let count = event_count();
    *count = *count + 1;
    events<T>().push_back(event);
}
