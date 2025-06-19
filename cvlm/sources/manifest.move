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

/// Marks the function `ghostFunName` as a ghost variable/mapping.  The function must return a reference type, may have
/// parameters, and may have type parameters.  When called, the function will return a reference to a unique location
/// for the given function/arguments/type arguments.
public native fun ghost(ghostFunName: vector<u8>);

/// Marks the function `hashFunName` as a hash function.  The function must return a single u256 value, and must have at 
/// least one parameter and/or type parameter.  When called, the function will hash its arguments and/or type arguments, 
/// and return a u256 value that is unique for the given function/arguments/type arguments.
public native fun hash(hashFunName: vector<u8>);

/// Marks the function `accessFunName` as a field accessor for the field named `fieldName`.  This function must return a 
/// reference type, and must take exactly one parameter of type `&S` where `S` is a struct or generic parameter.  When 
/// called, the function will return a reference to the field named `fieldName` in the struct that is passed as the 
/// parameter.  For generic field accessors, if a non-struct type is passed in a call to the accessor, the Prover will 
/// fail with an error.
/// 
/// (This function is provided to support summarization of platform functions; for normal functions, prefer to use an 
/// ordinary (test-only) accessor function to access fields from rules or summaries.)
public native fun field_access(accessFunName: vector<u8>, fieldName: vector<u8>);