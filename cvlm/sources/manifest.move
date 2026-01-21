module cvlm::manifest;

/*
    CVL Manifests

    We'd like to be able to annotate functions, structs, and modules with metadata about how the Certora Prover should
    treat them. However, the Move compiler has limited support for custom attributes, and moreover does not embed
    attribute metadata in the bytecode or source info.  In order to support CVL attributes, we'd need to build our own
    custom Move compiler.

    In the interest of getting something working now, we will use a manifest function to describe this metadata instead.
    The idea is that every CVL module can contain a `cvlm_manifest` function that describes the CVL-specific attributes.

    For example:

    ```move

    module project::rules

    use certora::cvlm_manifest::{ rule, summary, ghost };

    fun cvlm_manifest() {
        // Declare that the function `transfer` in this module is a rule.
        rule(b"transfer");

        // Declare that the function `get_idx_summary` in this module summarizes `sui::vec_map::get_idx`.
        summary(b"get_idx_summary", @sui, b"vec_map", b"get_idx");

        // Declare that the function `hashToValue` in this module is a ghost mapping.
        ghost(b"hashToValue");
    }

    fun get_idx_summary(self: &VecMap<K,V>, key: &K): u64 {
        // Implementation of the summary function
    } 

    native fun hash(a: u64, b: u256): u256;

    native fun hashToValue<T>(hash: u256): T;        

    ```
 */

/// Marks the function `function_name` as a rule.
public native fun rule(function_name: vector<u8>);

///
/// Marks the function `function_name` as a rule.  In addition to any assertions in the rule definition, the rule will
/// also assert that no code invoked by the rule can abort.
///
/// Note that the soundness of this abort check depends on the accuracy of the abort behavior in any summaries that
/// are active when the rule is checked, including summaries of platform functions.  I.e., if a platform function 
/// summary does not abort, then the rule may pass even if the actual platform function can abort.
///
public native fun no_abort_rule(function_name: vector<u8>);

/// Names a target function for use in parametric rules.
public native fun target(module_address: address, module_name: vector<u8>, function_name: vector<u8>);

/// Names a function in the current module which can be used to invoke a target function from a parametric rule. The 
/// invoker function must be a `native fun`.  The first parameter must be of type `cvlr::function::Function`.  Any 
/// additional parameters will be forwarded to the invoked function.
public native fun invoker(function_name: vector<u8>);

/// Adds sanity rules for this module's target functions.
public native fun target_sanity();
    
///
/// Marks the function `summary_function_name` as a summary of 
/// `summarized_function_address`::`summarized_function_module`::`summarized_function_name`.  The summary function will 
/// replace the body of the summarized function in the model.
///
public native fun summary(
    summary_function_name: vector<u8>, 
    summarized_function_address: address, 
    summarized_function_module: vector<u8>, 
    summarized_function_name: vector<u8>
);

///
/// Marks the function `function_name` as a ghost variable/mapping.  The function may have parameters, and may have type 
/// parameters.  If the function returns a reference type, then when called, it will return a reference to a unique
/// location for the given arguments and/or type arguments.  If the function has no arguments/type arguments, then it 
/// will always return the same location.  If the function returns a value type, then it will return the value in the
/// slot for the given arguments.
/// 
/// The underlying ghost variable/mapping is initialized nondeterministically for each rule.
/// 
/// A ghost mapping function can also be used as a summary, by applying both `ghost` and `summary` to the same function.
/// This is one way to achieve the effect of the `NONDET` sumamry type in CVL.
/// 
public native fun ghost(function_name: vector<u8>);

///
/// Marks the function `function_name` as a hash function.  The function must return a single u256 value, and must have 
/// at least one parameter and/or type parameter.  When called, the function will hash its arguments and/or type 
/// arguments, and return a u256 value that is unique for the given function/arguments/type arguments.
/// 
/// Example:
/// 
/// ```move
///     fun cvlm_manifest() {
///         cvlm::manifest::hash(b"foo_to_u256");
///     }
///     native fun foo_to_u256<T>(x: &T): u256;
/// ```
/// 
public native fun hash(function_name: vector<u8>);

///
/// Marks the function `function_name` as a shadow mapping.  A shadow mapping replaces a struct with an alternate 
/// type/mapping.
/// 
/// Consider the following example:
/// 
/// ```move
///     use sui::vec_map::VecMap;
///     fun cvlm_manifest() {
///         cvlm::manifest::shadow(b"vec_map_shadow");
///     }
///     native fun vec_map_shadow<K: copy, V>(map: &VecMap<K, V>, key: &K): &mut V;
/// ```
/// 
/// `vec_map_shadow` shadows the `VecMap` struct.  The prover will not allow access to the fields of `VecMap` directly,
/// and will represent `VecMap` in the model as a mapping from keys to values, as specified by the signature of the
/// shadow function.  
/// 
/// When a struct is shadowed, any function that packs, unpacks, or accesses fields of that struct must be summarized.
/// 
/// The shadow mapping must accept a reference to the shadowed struct as its first parameter, and may have zero or
/// more additional parameters.  The shadow function must return a reference type, and may not return a reference to
/// any shadowed struct.
/// 
/// Generic shadow functions must have the same type parameters as the structs that they shadow.
/// 
public native fun shadow(function_name: vector<u8>);

///
/// Marks the function `function_name` as a field accessor for the field named `field_name`.  This function must return 
/// a reference type, and must take exactly one parameter of type `&S` where `S` is a struct or generic parameter.  When 
/// called, the function will return a reference to the field named `field_name` in the struct that is passed as the 
/// parameter.  
/// 
/// If a type is passed to the accessor function that is not a struct, or does not have a field with the given name,
/// or if the field is the wrong type, the Prover will raise an error.
/// 
/// (This function is provided to support summarization of platform functions; for normal functions, prefer to use an 
/// ordinary (test-only) accessor function to access fields from rules or summaries.)
/// 
public native fun field_access(function_name: vector<u8>, field_name: vector<u8>);

/// Marks the function `function_name` as a function accessor for the function named `target_function` in the module 
/// `target_module` at address `target_address`.  This function must have the same signature as the target function.
/// When called, the function will invoke the target function.
///
/// (This function is provided to support summarization of platform functions; for normal functions, prefer to use an 
/// ordinary (test-only) invoker function to call private functions from rules or summaries.)
public native fun function_access(
    function_name: vector<u8>, 
    target_address: address, 
    target_module: vector<u8>, 
    target_function: vector<u8>
);
