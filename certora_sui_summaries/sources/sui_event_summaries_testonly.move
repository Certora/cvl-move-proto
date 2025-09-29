#[allow(unused_function)]
#[test_only]
module certora::sui_event_summaries_testonly;

use cvlm::manifest::summary;
use certora::sui_event_summaries::{ event_count, events };

fun cvlm_manifest() {
    summary(b"num_events", @sui, b"event", b"num_events");
    summary(b"events_by_type", @sui, b"event", b"events_by_type");
}

// #[summary(sui::event::num_events)]
fun num_events(): u32 {
    *event_count()    
}

// #[summary(sui::event::events_by_type)]
fun events_by_type<T: copy + drop>(): vector<T> {
    *events<T>()
}