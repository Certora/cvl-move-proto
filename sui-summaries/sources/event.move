#[allow(unused_function)]
module sui_summaries::event;

use cvl::manifest::{summary, ghost_mapping};

fun cvl_manifest() {
    ghost_mapping(b"event_count");
    ghost_mapping(b"events");

    summary(b"emit", b"sui::event::emit");
    summary(b"num_events", b"sui::event::num_events");
    summary(b"events_by_type", b"sui::event::events_by_type");
}

//#[ghost_mapping]
native fun eventCount(): &mut u32;

//#[ghost_mapping]
native fun events<T: copy + drop>(): &mut vector<T>;

// #[summary(sui::event::emit)]
fun emit<T: copy + drop>(event: T) {
    let count = eventCount();
    *count = *count + 1;
    events<T>().push_back(event);
}

// #[summary(sui::event::num_events)]
fun num_events(): u32 {
    *eventCount()    
}

// #[summary(sui::event::events_by_type)]
fun events_by_type<T: copy + drop>(): vector<T> {
    *events<T>()
}