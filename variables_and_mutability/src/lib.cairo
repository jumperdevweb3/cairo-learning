// Constants
// Always unmutable and required defined type and can be declared only in global scope
const ONE_HOUR_IN_SECONDS: u32 = 3600;
// is possible to use the consteval_int! macro to create a const variable that is the result of some computation
const ONE_DAY_IN_SECONDS: u32 = consteval_int!(24 * 3600);

fn main() {
    // Mutability
    let unmutable_variable = 10;
    // unmutable_variable= 20; WRONG!
    println!("The value of unmutable_variable is: {}", unmutable_variable);

    let mut mutable_variable = 10;
    mutable_variable = 20; // Correct

    println!("The value of mutable_variable is: {}", mutable_variable);

    //Shadowing
    let x: u64 = 10;
    let x: felt252 = x.into(); // change from u64 to felt252

    {
        let x = x * 2;
        println!("Inner scope x value is: {}", x);
    }
    println!("Outer scope x value is: {}", x);
// Difference betweeb mut and shadowing
// "mut" allows for change the value, while shadowing allows for change the type and value
}

