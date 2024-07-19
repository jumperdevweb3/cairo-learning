If Statements
Basic if statement:

```rust
fn main() {
  let number = 3;
  if number == 5 {
    println!("condition was true and number = {}", number);
  } else {
    println!("condition was false and number = {}", number);
  }
}
```

The `if` statement checks if a condition is true. If so, it executes the code block. The `else` block is optional and is executed if the `if` condition is not met. The condition in `if` must be of type `bool`.

Handling multiple conditions using `else if`:

```rust
fn main() {
  let number = 3;
  if number == 12 {
    println!("number is 12");
  } else if number == 3 {
    println!("number is 3");
  } else if number - 2 == 1 {
    println!("number minus 2 is 1");
  } else {
    println!("number not found");
  }
}
```

`else if` allows checking multiple conditions sequentially. The program executes the code block for the first condition that is met and ignores the rest.

Using `if` in a `let` statement:

```rust
fn main() {
  let condition = true;
  let number = if condition { 5 } else { 6 };
  if number == 5 {
    println!("condition was true and number is {}", number);
  }
}
```

`if` can be used to assign a variable a value based on a condition.

Loops
Loop:

```rust
fn main() {
  loop {
    println!("again!");
  }
}
```

`loop` repeats the code indefinitely until we use `break` to exit the loop. In the context of smart contracts on Starknet, loops are controlled by the gas mechanism to prevent infinite loops.

Example of using `break` and `continue` in a loop:

```rust
fn main() {
  let mut i: usize = 0;
  loop {
    if i > 10 { break; }
    if i == 5 { i += 1; continue; }
    println!("i = {}", i);
    i += 1;
  }
}
```

`break` terminates the loop. `continue` skips the rest of the iteration and moves to the next one.

Returning a value from a loop:

```rust
fn main() {
  let mut counter = 0;
  let result = loop {
    if counter == 10 { break counter * 2; }
    counter += 1;
  };
  println!("The result is {}", result);
}
```

You can return a value from a loop using `break`.

While loop:

```rust
fn main() {
  let mut number = 3;
  while number != 0 {
    println!("{number}!");
    number -= 1;
  }
  println!("LIFTOFF!!!");
}
```

`while` repeats the code as long as the condition is true. It is more readable than using a combination of `loop`, `if`, `else`, and `break`.
