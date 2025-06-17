module cvlm::manifest;

/*
    CVL Manifests

    We'd like to be able to annotate functions, structs, and modules with metadata about how the Certora Prover should
    treat them. However, the Move compiler does not support custom attributes, nor does it embed attribute metadata in
    the bytecode or source info.  In order to support CVL attributes, we'd need to build our own custom Move compiler.

    In the interest of getting something working now, we will use a manifest function to describe this metadata instead.
    The idea is that every CVL module can contain a `cvlm_manifest` function that describes the CVL-specific attributes.

    For example:

    ```move

    module project::rules

    use certora::cvlm_manifest::{ rule, summary, ghost };

    fun cvlm_manifest() {
        // Declare that the function `transfer` in this module is a rule.
        rule!(b"transfer");

        // Declare that the function `get_idx_summary` in this module summarizes `sui::vec_map::get_idx`.
        summary!(b"get_idx_summary", b"sui::vec_map::get_idx");

        // Declare that the function `hashToValue` in this module is a ghost mapping.
        ghost!(b"hashToValue");
    }

    fun get_idx_summary(self: &VecMap<K,V>, key: &K): u64 {
        // Implementation of the summary function
    } 

    native fun hash(a: u64, b: u256): u256;

    native fun hashToValue<T>(hash: u256): T;        

    ```
 */

public native fun rule(funName: vector<u8>);
public native fun summary(funName: vector<u8>, summarized: vector<u8>);
public native fun ghost(funName: vector<u8>);
public native fun hash(funName: vector<u8>);
