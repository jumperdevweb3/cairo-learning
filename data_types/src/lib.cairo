use core::traits::TryInto;
fn sub_u8s(x: u8, y: u8) -> u8 {
    x - y
}
fn sub_i8s(x: i8, y: i8) -> i8 {
    x - y
}
fn main() {
    // Cairo is a statically typed language, which means that it must know the types of all variables at compile time. 
    // Scalar types: A scalar type represents a single value. Cairo has three primary scalar types: felts, integers, and booleans.
    // Default type is always `felt252` represents an integer in the range `0 ≤ x < P`, where `P` is a large prime number
    let default_type_felt252 = 6;

    // Conver felt252 to u32
    // try_into() is a trait method that converts a value to another type.
    // The try_into() method returns a Result type, which is an enum that can be either Ok or Err.
    // The unwrap() method is a convenience method that returns the value inside an Ok variant or panics if the value is an Err variant.
    let felt252_variable: felt252 = 3;
    let u32_variable: u32 = felt252_variable.try_into().unwrap();

    // Safer than 'felt252' is to use integer types like `u32`, `u64`, `u128`, `i32`, `i64`, `i128` due to additional overflow protections.

    // uXX: Unsigned integers - can't be negative
    // sub_u8s(2, 3); - Program panic because result is negative

    // iXX: Signed integers - can be negative and positive in range of -2^(n-1) to 2^(n-1) - 1
    let result: i8 = sub_i8s(2, 3); // -1

    //Boolean type
    let is_true: bool = true;

    //String type limited 31 characters
    let my_first_char = 'C';
    let my_first_char_in_hex = 0x43;

    let my_first_string = 'Hello world';
    let my_first_string_in_hex = 0x48656C6C6F20776F726C64;

    // Byte Array 
    // With the ByteArray struct added in Cairo 2.4.0, you are not limited to 31 characters anymore. These ByteArray strings are written in double quotes like in the following example:
    let long_string: ByteArray = "this is a string which has more than 31 characters";

    // The Tuple Type

    // Declaring a tuple
    let tup: (u32, u64, bool) = (1, 2, true);

    // Accessing tuple elements
    let (x, y, z) = tup;

    // Both at once
    let (m, d): (bool, u32) = (false, 2);

    // Unit Type
    // A unit type is a type which has only one value (). It is represented by a tuple with no elements. Its size is always zero, and it is guaranteed to not exist in the compiled code.

    // Type Conversion

    // Into
    // Safety conversion used when conversion is always possible f.e. from u32 to u64
    let my_u8_1: u8 = 1;
    let my_u16: u16 = my_u8_1.into();
    // TryInto
    // Used when conversion can fail f.e. from u8 to u16
    let my_u8_2: u8 = my_u16.try_into().unwrap();

    // Numeric operations
    let sum = 5_u128 + 10_u128;
}

