#[allow(unused_function)]
#[test_only]
module certora::sui_event_summaries;

use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    ghost(b"event_count");
    ghost(b"events");

    summary(b"emit", @sui, b"event", b"emit");
    summary(b"num_events", @sui, b"event", b"num_events");
    summary(b"events_by_type", @sui, b"event", b"events_by_type");
}

//#[ghost]
native fun event_count(): &mut u32;

//#[ghost]
native fun events<T: copy + drop>(): &mut vector<T>;

// #[summary(sui::event::emit)]
fun emit<T: copy + drop>(event: T) {
    let count = event_count();
    *count = *count + 1;
    events<T>().push_back(event);
}

// #[summary(sui::event::num_events)]
fun num_events(): u32 {
    *event_count()    
}

// #[summary(sui::event::events_by_type)]
fun events_by_type<T: copy + drop>(): vector<T> {
    *events<T>()
}