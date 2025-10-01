#[allow(unused_function)]
module certora::std_type_name_summaries;

use std::type_name::TypeName;
use std::ascii::String;
use cvlm::nondet::nondet;
use cvlm::manifest::{ summary, shadow, hash, ghost };
use cvlm::asserts::cvlm_assume_msg;

fun cvlm_manifest() {
    shadow(b"type_name_shadow");
    hash(b"type_name_value");
    ghost(b"type_name_name");
    ghost(b"type_name_address");
    ghost(b"type_name_module");
    summary(b"get", @std, b"type_name", b"get");
    summary(b"get_with_original_ids", @std, b"type_name", b"get_with_original_ids");
    summary(b"into_string", @std, b"type_name", b"into_string");
    summary(b"get_address", @std, b"type_name", b"get_address");
    summary(b"get_module", @std, b"type_name", b"get_module");
}

// #[shadow]
native fun type_name_shadow(type_name: &TypeName): &mut u256;

// #[hash]
native fun type_name_value<T>(): u256;

// #[ghost]
native fun type_name_name(type_name: &TypeName): &String;

// #[ghost]
native fun type_name_address(type_name: &TypeName): &String;

// #[ghost]
native fun type_name_module(type_name: &TypeName): &String;

// A bound on the value returned by type_name_value<T>().
const TYPE_NAME_VALUE_BOUND: u256 = 0x100000000; 

// #[summary(std::type_name::get)]
fun get<T>(): TypeName {
    let name = nondet<TypeName>();
    let value = type_name_value<T>();
    cvlm_assume_msg(value < TYPE_NAME_VALUE_BOUND, b"type_name_value bounds");
    *type_name_shadow(&name) = value;
    name
}

// #[summary(std::type_name::get_with_original_ids)]
fun get_with_original_ids<T>(): TypeName {
    let name = nondet<TypeName>();
    let value = type_name_value<T>();
    cvlm_assume_msg(value < TYPE_NAME_VALUE_BOUND, b"type_name_value bounds");
    // We distinguish this from get<T> by adding TYPE_NAME_VALUE_BOUND to the shadow value.
    *type_name_shadow(&name) = value + TYPE_NAME_VALUE_BOUND;
    name
}

// #[summary(std::type_name::into_string)]
fun into_string(self: TypeName): String { *type_name_name(&self) }

// #[summary(std::type_name::get_address)]
fun get_address(self: &TypeName): String { *type_name_address(self) }

// #[summary(std::type_name::get_module)]
fun get_module(self: &TypeName): String { *type_name_module(self) }