module cvl::ref;

/// Force a value into a mutable reference, even though T does not have the `drop` capability.
public native fun force_write<T>(ref: &mut T, value: T);

/// Read a value from a reference, even though T does not have the `copy` capability.
public native fun force_read<T>(ref: &T): T;