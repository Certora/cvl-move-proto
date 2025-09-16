#[allow(unused_function)]
module certora::std_type_name_summaries;

use std::type_name::TypeName;
use std::ascii::String;
use cvlm::nondet::nondet;
use cvlm::manifest::{ summary, shadow, hash, ghost };

fun cvlm_manifest() {
    shadow(b"type_name_shadow");
    hash(b"type_name_value");
    ghost(b"type_name_name");
    ghost(b"type_name_address");
    summary(b"get", @std, b"type_name", b"get");
    summary(b"into_string", @std, b"type_name", b"into_string");
    summary(b"get_address", @std, b"type_name", b"get_address");
}

// #[shadow]
native fun type_name_shadow(type_name: &TypeName): &mut u256;

// #[hash]
native fun type_name_value<T>(): u256;

// #[ghost]
native fun type_name_name(type_name: &TypeName): &String;

// #[ghost]
native fun type_name_address(type_name: &TypeName): &String;

// #[summary(std::type_name::get)]
fun get<T>(): TypeName {
    let name = nondet<TypeName>();
    *type_name_shadow(&name) = type_name_value<T>();
    name
}

// #[summary(std::type_name::into_string)]
fun into_string(self: TypeName): String { *type_name_name(&self) }

// #[summary(std::type_name::get_address)]
fun get_address(type_name: &TypeName): String { *type_name_address(type_name) }