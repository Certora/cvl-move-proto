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
        summary!(b"get_idx_summary", @sui, b"vec_map", b"get_idx");

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

/// Marks the function `ruleFunName` as a rule.
public native fun rule(ruleFunName: vector<u8>);

/// Marks the function `summaryFunName` as a summary of the function `summarizedFunAddr`::`summarizedFunModule`::`summarizedFunName`.
public native fun summary(
    summaryFunName: vector<u8>, 
    summarizedFunAddr: address, 
    summarizedFunModule: vector<u8>, 
    summarizedFunName: vector<u8>
);

/// Marks the function `ghostFunName` as a ghost state function.
public native fun ghost(ghostFunName: vector<u8>);

/// Marks the function `hashFunName` as a hash function.
public native fun hash(hashFunName: vector<u8>);

/// Marks the function `accessFunName(self: &T): &mut T` as an accessor for the field `T.fieldName`.
public native fun field_access(accessFunName: vector<u8>, fieldName: vector<u8>);