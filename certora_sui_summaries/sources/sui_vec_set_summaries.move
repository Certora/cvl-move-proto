#[allow(unused_function, unused_mut_parameter)]
module certora::sui_vec_set_summaries;

use cvlm::manifest::{ shadow, summary };
use cvlm::nondet::nondet;
use sui::vec_set::VecSet;

fun cvlm_manifest() {
    shadow(b"shadow_vec_set");
    shadow(b"present");
    summary(b"empty", @sui, b"vec_set", b"empty");
    summary(b"size", @sui, b"vec_set", b"size");
    summary(b"insert", @sui, b"vec_set", b"insert");
    summary(b"remove", @sui, b"vec_set", b"remove");
    summary(b"contains", @sui, b"vec_set", b"contains");
}

public struct ShadowVecSet<K: copy + drop> has copy, drop, store {
    size: u64,
    contents: ShadowContents<K>,
}
public native struct ShadowContents<K: copy + drop> has copy, drop, store;

// #[shadow]
native fun shadow_vec_set<K: copy + drop>(map: &VecSet<K>): &mut ShadowVecSet<K>;

// #[shadow]
native fun present<K: copy + drop>(contents: &ShadowContents<K>, key: K): &mut bool;

// #[summary(sui::vec_set::empty)]
fun empty<K: copy + drop>(): VecSet<K> {
    let set = nondet<VecSet<K>>();
    let shadow = shadow_vec_set(&set);
    shadow.size = 0;
    set
}

// #[summary(sui::vec_set::size)]
fun size<K: copy + drop>(self: &VecSet<K>): u64 {
    shadow_vec_set(self).size
}

// #[summary(sui::vec_set::insert)]
fun insert<K: copy + drop>(self: &mut VecSet<K>, key: K) {
    let set = shadow_vec_set(self);
    let present = present(&set.contents, key);
    assert!(!*present);
    *present = true;
    set.size = set.size + 1;
}

// #[summary(sui::vec_set::remove)]
fun remove<K: copy + drop>(self: &mut VecSet<K>, key: &K) {
    let set = shadow_vec_set(self);
    let present = present(&set.contents, *key);
    assert!(*present);
    *present = false;
    set.size = set.size - 1;
}

// #[summary(sui::vec_set::contains)]
fun contains<K: copy + drop>(self: &VecSet<K>, key: &K): bool {
    let set = shadow_vec_set(self);
    *present(&set.contents, *key)
}
