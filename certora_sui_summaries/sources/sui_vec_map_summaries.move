#[allow(unused_function, unused_mut_parameter)]
module certora::sui_vec_map_summaries;

use cvlm::ghost::{ ghost_read, ghost_write };
use cvlm::manifest::{ shadow, summary };
use sui::vec_map::VecMap;

fun cvlm_manifest() {    
    shadow(b"shadow_vec_map");
    summary(b"insert", @sui, b"vec_map", b"insert");
    summary(b"remove", @sui, b"vec_map", b"remove");
    summary(b"get_mut", @sui, b"vec_map", b"get_mut");
    summary(b"get", @sui, b"vec_map", b"get");
    summary(b"try_get", @sui, b"vec_map", b"try_get");
    summary(b"contains", @sui, b"vec_map", b"contains");
}

public struct ShadowEntry<V> has copy, drop {
    value: V,
    present: bool
}
// #[shadow]
native fun shadow_vec_map<K: copy, V>(map: &VecMap<K, V>, k: K): &mut ShadowEntry<V>;

// #[summary(sui::vec_map::insert)]
fun insert<K: copy, V>(self: &mut VecMap<K, V>, key: K, value: V) {
    let entry = shadow_vec_map(self, key);
    assert!(!entry.present);
    ghost_write(&mut entry.value, value);
}

// #[summary(sui::vec_map::remove)]
fun remove<K: copy, V>(self: &mut VecMap<K, V>, key: &K): (K, V) {
    let entry = shadow_vec_map(self, *key);
    assert!(entry.present);
    entry.present = false;
    (*key, ghost_read(&entry.value))
}

// #[summary(sui::vec_map::get_mut)]
fun get_mut<K: copy, V>(self: &mut VecMap<K, V>, key: &K): &mut V {
    let entry = shadow_vec_map(self, *key);
    assert!(entry.present);
    &mut entry.value
}

// #[summary(sui::vec_map::get)]
public fun get<K: copy, V>(self: &VecMap<K, V>, key: &K): &V {
    let entry = shadow_vec_map(self, *key);
    assert!(entry.present);
    &entry.value
}

// #[summary(sui::vec_map::try_get)]
fun try_get<K: copy, V: copy>(self: &VecMap<K, V>, key: &K): Option<V> {
    let entry = shadow_vec_map(self, *key);
    if (entry.present) {
        option::some(ghost_read(&entry.value))
    } else {
        option::none()
    }
}

// #[summary(sui::vec_map::contains)]
fun contains<K: copy, V>(self: &VecMap<K, V>, key: &K): bool {
    let entry = shadow_vec_map(self, *key);
    entry.present
}
