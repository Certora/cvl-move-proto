module builtin_summaries_sui::vec_map;

use cvl_sui::nondet::nondet;
use cvl_sui::assert::cvl_assume;
use cvl_sui::summary::summary;
use sui::vec_map::{VecMap, size, get_entry_by_idx};

#[allow(unused_function)]
fun get_idx<K: copy, V>(self: &VecMap<K,V>, key: &K): u64 {

    summary!(b"sui::vec_map::get_idx");

    let idx = nondet!<u64>();
    cvl_assume!(idx < self.size());
    let (entry_key, _) = self.get_entry_by_idx(idx);
    cvl_assume!(entry_key == key);
    idx
}

#[allow(unused_function)]
fun get_idx_opt<K: copy, V>(self: &VecMap<K,V>, _: &K): Option<u64> {

    summary!(b"sui::vec_map::get_idx_opt");

    if (nondet!<bool>()) { 
        let idx = nondet!<u64>();
        cvl_assume!(idx < self.size());
        option::some(idx) 
    } else { 
        option::none() 
    }
}