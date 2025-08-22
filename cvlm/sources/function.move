module cvlm::function;

/// Represents a function that can be called by a parametric rule.  To call a `Function`, declare an "invoker" via
/// `cvlm::manifest::invoker`.
public native struct Function has drop, copy;

public native fun name(function: Function): vector<u8>;
public native fun module_name(function: Function): vector<u8>;
public native fun module_address(function: Function): address;
