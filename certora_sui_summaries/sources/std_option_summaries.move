#[allow(unused_function, unused_mut_parameter)]
module certora::std_option_summaries;

use cvlm::manifest::{ summary, shadow };
use cvlm::nondet::nondet;
use cvlm::ghost::{ ghost_read, ghost_write, ghost_destroy };

fun cvlm_manifest() {
    shadow(b"shadow_option");
    summary(b"none", @std, b"option", b"none");
    summary(b"some", @std, b"option", b"some");
    summary(b"is_none", @std, b"option", b"is_none");
    summary(b"is_some", @std, b"option", b"is_some");
    summary(b"contains", @std, b"option", b"contains");
    summary(b"borrow", @std, b"option", b"borrow");
    summary(b"borrow_with_default", @std, b"option", b"borrow_with_default");
    summary(b"get_with_default", @std, b"option", b"get_with_default");
    summary(b"fill", @std, b"option", b"fill");
    summary(b"extract", @std, b"option", b"extract");
    summary(b"borrow_mut", @std, b"option", b"borrow_mut");
    summary(b"swap", @std, b"option", b"swap");
    summary(b"swap_or_fill", @std, b"option", b"swap_or_fill");
    summary(b"destroy_with_default", @std, b"option", b"destroy_with_default");
    summary(b"destroy_some", @std, b"option", b"destroy_some");
    summary(b"destroy_none", @std, b"option", b"destroy_none");
    summary(b"to_vec", @std, b"option", b"to_vec");
}

public struct ShadowOption<Element> {
    value: Element,
    present: bool
}

native fun shadow_option<Element>(_: &Option<Element>): &mut ShadowOption<Element>;

fun none<Element>(): Option<Element> { 
    let option = nondet<Option<Element>>();
    shadow_option(&option).present = false;
    option
}

fun some<Element>(e: Element): Option<Element> { 
    let option = nondet<Option<Element>>();
    let shadow = shadow_option(&option);
    shadow.present = true;
    ghost_write(&mut shadow.value, e);
    option
}

/// Used by other summaries to avoid branching
public(package) fun maybe_some<Element>(present: bool, e: Element): Option<Element> {
    let option = nondet<Option<Element>>();
    let shadow = shadow_option(&option);
    shadow.present = present;
    ghost_write(&mut shadow.value, e);
    option
}

fun is_none<Element>(t: &Option<Element>): bool {
    !shadow_option(t).present
}

fun is_some<Element>(t: &Option<Element>): bool {
    shadow_option(t).present
}

fun contains<Element>(t: &Option<Element>, e_ref: &Element): bool {
    let shadow = shadow_option(t);
    shadow.present && &shadow.value == e_ref
}

fun borrow<Element>(t: &Option<Element>): &Element {
    let shadow = shadow_option(t);
    assert!(shadow.present);
    &shadow.value
}

fun borrow_with_default<Element>(t: &Option<Element>, default_ref: &Element): &Element {
    let shadow = shadow_option(t);
    if (shadow.present) { &shadow.value } else { default_ref }
}

fun get_with_default<Element: copy + drop>(t: &Option<Element>, default: Element): Element {
    let shadow = shadow_option(t);
    if (shadow.present) { shadow.value } else { default }
}

fun fill<Element>(t: &mut Option<Element>, e: Element) {
    let shadow = shadow_option(t);
    assert!(!shadow.present);
    shadow.present = true;
    ghost_write(&mut shadow.value, e);
}

fun extract<Element>(t: &mut Option<Element>): Element {
    let shadow = shadow_option(t);
    assert!(shadow.present);
    shadow.present = false;
    ghost_read(&shadow.value)
}

fun borrow_mut<Element>(t: &mut Option<Element>): &mut Element {
    let shadow = shadow_option(t);
    assert!(shadow.present);
    &mut shadow.value
}

fun swap<Element>(t: &mut Option<Element>, e: Element): Element {
    let shadow = shadow_option(t);
    assert!(shadow.present);
    let old_value = ghost_read(&shadow.value);
    ghost_write(&mut shadow.value, e);
    old_value
}

fun swap_or_fill<Element>(t: &mut Option<Element>, e: Element): Option<Element> {
    let old_opt = ghost_read(t);
    let shadow = shadow_option(t);
    shadow.present = true;
    ghost_write(&mut shadow.value, e);
    old_opt
}

fun destroy_with_default<Element: drop>(t: Option<Element>, default: Element): Element {
    let shadow = shadow_option(&t);
    if (shadow.present) { ghost_read(&shadow.value) } else { default }
}

fun destroy_some<Element>(t: Option<Element>): Element {
    let shadow = shadow_option(&t);
    assert!(shadow.present);
    let e = ghost_read(&shadow.value);
    ghost_destroy(t);
    e
}

fun destroy_none<Element>(t: Option<Element>) {
    let shadow = shadow_option(&t);
    assert!(!shadow.present);
    ghost_destroy(t);
}

fun to_vec<Element>(t: Option<Element>): vector<Element> {
    let shadow = shadow_option(&t);
    let vec = if (shadow.present) {
        vector[ghost_read(&shadow.value)]
    } else {
        vector[]
    };
    ghost_destroy(t);
    vec
}
