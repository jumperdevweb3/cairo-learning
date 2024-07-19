fn another_function() {
    println!("Another function.");
}
fn function_with_parameter(x: felt252) {
    println!("The value of x is: {}", x);
}

fn print_labeled_measurement(value: u128, unit_label: ByteArray) {
    println!("The measurement is: {value}{unit_label}");
}
fn foo(x: u8, y: u8) {}

fn five() -> u32 {
    5
}
fn plus_one(x: u32) -> u32 {
    x + 1
}
fn main() {
    another_function();
    function_with_parameter(5);
    print_labeled_measurement(42, "h");

    let first_arg = 3;
    let second_arg = 4;
    foo(x: first_arg, y: second_arg);
    let x = 1;
    let y = 2;
    //If you pass a variable that has the same name as the parameter, you can simply write :parameter_name
    foo(:x, :y);

    // Statements
    // Statements are instructions that perform some action and do not return a value.
    let d = 6;
    // Expressions
    // Expressions evaluate to a resultant value. Let’s look at some examples.

    let y = {
        let x = 3;
        // Expressions do not include ending semicolons
        // If you add a semicolon to the end of an expression, you turn it into a statement
        x + 1
    };

    println!("The value of y is: {}", y);

    // Functions with Return Values

    let x = five();
    println!("The value of x is: {}", x);
    let plus = plus_one(5);
    println!("The value of x is: {}", plus);
}

