#[allow(unused_function)]
module sui_summaries::vec_map;

use cvl::nondet::nondet;
use cvl::assert::cvl_assume;
use cvl::manifest::{summary};
use sui::vec_map::{VecMap, size, get_entry_by_idx};

fun cvl_manifest() {
    summary(b"get_idx", b"sui::vec_map::get_idx");
    summary(b"get_idx_opt", b"sui::vec_map::get_idx_opt");
}

// #[summary(sui::vec_map::get_idx)]
fun get_idx<K: copy, V>(self: &VecMap<K,V>, key: &K): u64 {
    // NOTE this does not model the abort case when the key is not found.
    let idx = nondet<u64>();
    cvl_assume(idx < self.size());
    let (entry_key, _) = self.get_entry_by_idx(idx);
    cvl_assume(entry_key == key);
    idx
}

// #[summary(sui::vec_map::get_idx_opt)]
fun get_idx_opt<K: copy, V>(_: &VecMap<K,V>, _: &K): Option<u64> { nondet() }
