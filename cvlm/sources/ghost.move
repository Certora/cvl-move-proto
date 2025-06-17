module cvlm::ghost;

/// Force a value into a mutable reference, even though T does not have the `drop` capability.
public native fun ghost_write<T>(ref: &mut T, value: T);

/// Read a value from a reference, even though T does not have the `copy` capability.
public native fun ghost_read<T>(ref: &T): T;

/// Consumes a value, even though T does not have the `drop` capability.
public native fun destroy<T>(value: T);