#[allow(unused_function)]
module certora::sui_vec_map_summaries;

use cvlm::nondet::{ nondet, nondet_with };
use cvlm::asserts::cvlm_assume;
use cvlm::manifest::summary;
use sui::vec_map::{VecMap, size, get_entry_by_idx};

fun cvlm_manifest() {
    summary(b"get_idx", @sui, b"vec_map", b"get_idx");
    summary(b"get_idx_opt", @sui, b"vec_map", b"get_idx_opt");
}

// #[summary(sui::vec_map::get_idx)]
fun get_idx<K: copy, V>(self: &VecMap<K,V>, key: &K): u64 {
    // NOTE this does not model the abort case when the key is not found.
    let idx = nondet_with!(|i| i < self.size());
    let (entry_key, _) = self.get_entry_by_idx(idx);
    cvlm_assume!(entry_key == key);
    idx
}

// #[summary(sui::vec_map::get_idx_opt)]
fun get_idx_opt<K: copy, V>(_: &VecMap<K,V>, _: &K): Option<u64> { nondet() }
