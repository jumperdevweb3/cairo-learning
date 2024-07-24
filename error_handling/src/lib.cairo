#[derive(Copy, Clone, Drop)]
enum Result<T, E> {
    Ok: T,
    Err: E,
}

trait ResultTrait<T, E> {
    fn expect<+Drop<E>>(self: Result<T, E>, err: felt252) -> T;

    fn unwrap<+Drop<E>>(self: Result<T, E>) -> T;

    fn expect_err<+Drop<T>>(self: Result<T, E>, err: felt252) -> E;

    fn unwrap_err<+Drop<T>>(self: Result<T, E>) -> E;

    fn is_ok(self: @Result<T, E>) -> bool;

    fn is_err(self: @Result<T, E>) -> bool;
}

#[panic_with('value is 0', wrap_not_zero)]
fn wrap_if_not_zero(value: u128) -> Option<u128> {
    if value == 0 {
        Option::None
    } else {
        Option::Some(value)
    }
}
fn function_never_panic() -> felt252 nopanic {
    42
}

fn parse_u8(s: felt252) -> Result<u8, felt252> {
    match s.try_into() {
        Option::Some(value) => Result::Ok(value),
        Option::None => Result::Err('Invalid integer'),
    }
}
fn do_something_with_parse_u8(input: felt252) -> Result<u8, felt252> {
    let input_to_u8: u8 = parse_u8(input)?;
    // DO SOMETHING
    let res = input_to_u8 - 1;
    Result::Ok(res)
}


#[test]
fn test_function_2() {
    let number: felt252 = 258;
    match do_something_with_parse_u8(number) {
        Result::Ok(value) => println!("Result: {}", value),
        Result::Err(e) => println!("Error: {}", e),
    }
}
fn main() {
    // wrap_if_not_zero(0); // this returns None
    // wrap_not_zero(0); // this panics with 'value is 0'
    parse_u8(-2); // this returns Ok(42
    do_something_with_parse_u8('2'); // this returns Ok(41)
}

