#[allow(unused_function)]
module certora::std_type_name_summaries;

use std::type_name::TypeName;
use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    ghost(b"type_name");
    summary(b"get", @std, b"type_name", b"get");
}

// #[ghost]
native fun type_name<T>(): &TypeName;

// #[summary(std::type_name::get)]
fun get<T>(): TypeName {
    *type_name<T>()
}