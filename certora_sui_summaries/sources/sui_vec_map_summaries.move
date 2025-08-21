#[allow(unused_function, unused_mut_parameter)]
module certora::sui_vec_map_summaries;

use cvlm::ghost::{ ghost_read, ghost_write, ghost_destroy };
use cvlm::manifest::{ shadow, summary };
use cvlm::nondet::nondet;
use sui::vec_map::VecMap;

fun cvlm_manifest() {    
    shadow(b"shadow_vec_map");
    shadow(b"shadow_entry");
    summary(b"size", @sui, b"vec_map", b"size");
    summary(b"insert", @sui, b"vec_map", b"insert");
    summary(b"remove", @sui, b"vec_map", b"remove");
    summary(b"get_mut", @sui, b"vec_map", b"get_mut");
    summary(b"get", @sui, b"vec_map", b"get");
    summary(b"try_get", @sui, b"vec_map", b"try_get");
    summary(b"get_entry_by_idx", @sui, b"vec_map", b"get_entry_by_idx");
    summary(b"get_entry_by_idx_mut", @sui, b"vec_map", b"get_entry_by_idx_mut");
    summary(b"contains", @sui, b"vec_map", b"contains");
}

public struct ShadowVecMap<K: copy, V> has copy, drop, store {
    size: u64,
    contents: ShadowContents<K, V>,
    indexed: vector<K>,
}
public native struct ShadowContents<K: copy, V> has copy, drop, store;
public struct ShadowEntry<V> has copy, drop, store {
    value: V,
    present: bool,
    index: u64
}

// #[shadow]
native fun shadow_vec_map<K: copy, V>(map: &VecMap<K, V>): &mut ShadowVecMap<K, V>;

// #[shadow]
native fun shadow_entry<K: copy, V>(contents: &ShadowContents<K, V>, key: K): &mut ShadowEntry<V>;

// #[summary(sui::vec_map::size)]
fun size<K: copy, V>(self: &VecMap<K, V>): u64 {
    shadow_vec_map(self).size
}


// #[summary(sui::vec_map::insert)]
fun insert<K: copy, V>(self: &mut VecMap<K, V>, key: K, value: V) {
    let map = shadow_vec_map(self);
    let entry = shadow_entry(&map.contents, key);
    assert!(!entry.present);
    ghost_write(&mut entry.value, value);
    entry.present = true;
    entry.index = map.size;
    map.size = map.size + 1;
    map.indexed.push_back(key);
}

// #[summary(sui::vec_map::remove)]
fun remove<K: copy, V>(self: &mut VecMap<K, V>, key: &K): (K, V) {
    let map = shadow_vec_map(self);
    let entry = shadow_entry(&map.contents, *key);
    assert!(entry.present);
    entry.present = false;    
    map.size = map.size - 1;
    if (entry.index == map.size) {
        ghost_destroy(map.indexed.pop_back());
    } else {
        ghost_write(&mut map.indexed, nondet());
    };
    (*key, ghost_read(&entry.value))
}

// #[summary(sui::vec_map::get_mut)]
fun get_mut<K: copy, V>(self: &mut VecMap<K, V>, key: &K): &mut V {
    let map = shadow_vec_map(self);
    let entry = shadow_entry(&map.contents, *key);
    assert!(entry.present);
    &mut entry.value
}

// #[summary(sui::vec_map::get)]
public fun get<K: copy, V>(self: &VecMap<K, V>, key: &K): &V {
    let map = shadow_vec_map(self);
    let entry = shadow_entry(&map.contents, *key);
    assert!(entry.present);
    &entry.value
}

// #[summary(sui::vec_map::try_get)]
fun try_get<K: copy, V: copy>(self: &VecMap<K, V>, key: &K): Option<V> {
    let map = shadow_vec_map(self);
    let entry = shadow_entry(&map.contents, *key);
    certora::std_option_summaries::maybe_some(entry.present, ghost_read(&entry.value))
}

// #[summary(sui::vec_map::get_entry_by_idx)]
fun get_entry_by_idx<K: copy, V>(self: &VecMap<K, V>, idx: u64): (&K, &V) {
    let map = shadow_vec_map(self);
    assert!(idx < map.size);
    let key = &map.indexed[idx];
    let entry = shadow_entry(&map.contents, *key);
    (key, &entry.value)
}

// #[summary(sui::vec_map::get_entry_by_idx_mut)]
fun get_entry_by_idx_mut<K: copy, V>(self: &mut VecMap<K, V>, idx: u64): (&K, &mut V) {
    let map = shadow_vec_map(self);
    assert!(idx < map.size);
    let key = &map.indexed[idx];
    let entry = shadow_entry(&map.contents, *key);
    (key, &mut entry.value)
}

// #[summary(sui::vec_map::contains)]
fun contains<K: copy, V>(self: &VecMap<K, V>, key: &K): bool {
    let map = shadow_vec_map(self);
    let entry = shadow_entry(&map.contents, *key);
    entry.present
}
