#[allow(unused_function)]
module certora::std_type_name_summaries;

use std::type_name::TypeName;
use cvlm::nondet::nondet;
use cvlm::manifest::{ summary, shadow, hash };

fun cvlm_manifest() {
    shadow(b"type_name_shadow");
    hash(b"type_name_value");
    summary(b"get", @std, b"type_name", b"get");
}

// #[shadow]
native fun type_name_shadow(typeName: &TypeName): &mut u256;

// #[hash]
native fun type_name_value<T>(): u256;

// #[summary(std::type_name::get)]
fun get<T>(): TypeName {
    let name = nondet<TypeName>();
    *type_name_shadow(&name) = type_name_value<T>();
    name
}