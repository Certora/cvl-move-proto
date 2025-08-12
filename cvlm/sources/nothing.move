module cvlm::nothing;

/// The `Nothing` type is a placeholder type used internally by the Prover when instantiating generic functions,
/// e.g. for sanity checks.  
/// 
/// The Prover treats this type as having all possible abilities, even though it is not defined that way here. (In Sui, 
/// it is not possible for a struct to have all abilities simultaneously.)
public struct Nothing has key {
    id: sui::object::UID
}