# Simple FFI example

## Building the C library

```
cd mathlib
cmake .
make
```

This should produce a shared library `lib/libmath.dylib`.

## Running the example

```
cd <root_of_repo>/math_example
dart run
```

Should print 42.
