fn main() {
    // Basic if statement
    let number = 5;
    if number == 5 {
        println!("Number is {}", number);
    } else {
        println!("Number is not 5");
    }

    // else if

    if number == 5 {
        println!("Number is {}", number);
    } else if number - 2 == 3 {
        println!("Number is 3");
    }

    // if statement used in a let statement
    let condition = true;
    let number2 = if condition {
        5
    } else {
        6
    };

    // Loops
    loop {
        println!("Loop forever!");
        break;
    };

    let mut i: usize = 0;

    loop {
        if i > 10 {
            break;
        }
        if i == 5 {
            i += 1;
            continue;
        }
        println!("i is {}", i);
        i += 1;
    };

    // Returning values from loops
    let mut counter = 0;
    let result = loop {
        if counter == 10 {
            break counter * 2;
        }
        counter += 1;
    };
    println!("The result is {}", result);

    // While loop
    let mut number3 = 3;
    while number3 != 0 {
        println!("{number3}!");
        number3 -= 1;
    };
    println!("LIFTOFF!!!");
}

