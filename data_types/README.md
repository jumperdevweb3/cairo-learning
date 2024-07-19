# Data Types in Cairo

In the Cairo language, each data type specifies the kind of data being stored, allowing the compiler to perform appropriate operations on that data. Cairo is a statically typed language, which means that all variable types must be known at compile time. The compiler can usually infer the type based on the value and its usage, but in some cases, explicit type declaration is necessary.

## Scalar Types

### felt252 Type

Default Type: If you don't specify the variable type, it defaults to `felt252`.
Range: `felt252` represents an integer in the range `0 ≤ x < P`, where `P` is a large prime number.
Operations: Mathematical operations are performed modulo `P`.
Division: The result of division in `felt252` always satisfies the equation `x/y ⋅ y = x`.

## Integer Types

Safer than `felt252`: It is recommended to use integer types (`u8`, `u16`, `u32`, `u64`, `u128`, `u256`) instead of `felt252` due to additional overflow protections.
Sizes: Integer types have a specified size (e.g., `u8` is an 8-bit unsigned integer).
Negative Numbers: Integer types are unsigned, but there are also signed versions available (`i8`, `i16`, `i32`, `i64`, `i128`).

## Boolean Type

Values: `bool` can take the values `true` or `false`.
Size: It occupies one `felt252` in size.

## Complex Types

### Tuples

Structure: Tuples group values of different types into a single structure.
Fixed Length: Once declared, the length of a tuple cannot be changed.
Destructuring: Tuples can be deconstructed into individual values.

### Unit Type

Representation: The unit type `()` represents a value with no elements.
Size: It always has a size of zero and does not exist in compiled code.

## Type Conversion

### Into

Safe Conversion: Used when the conversion is guaranteed, e.g., from a smaller type to a larger one.
Example: `let my_u16: u16 = my_u8.into();`

### TryInto

Conversion with Potential Error: Used when the conversion may fail, e.g., from a larger type to a smaller one.
Example: `let my_u8: u8 = my_u16.try_into().unwrap();`

## Numeric Operations

Basic Operations: Cairo supports addition, subtraction, multiplication, division, and remainder for all integer types.
Example: `let sum = 5_u128 + 10_u128;`

## String Types

### Short Strings

ASCII Encoding: Each character is encoded in one byte.
Character Limit: Short strings are limited to 31 characters.

### Byte Arrays

No Limits: Byte arrays have no length restrictions and are enclosed in double quotes.

## Summary

Cairo is a statically typed language with a rich set of data types.
Scalar types include `felt252`, integer types, and the boolean type.
Complex types include tuples and the unit type.
Type conversions are performed using `Into` and `TryInto`.
Numeric operations and string types are well-supported, with various representation options.
