# Variables and Mutability

Here is a summary of the chapter on variables and their mutability in the Cairo language, presented in an accessible way:

## Default Immutability

In Cairo, variables are immutable by default, which means that once a value is assigned, it cannot be changed. This is due to Cairo's immutable memory model, where a memory cell can only be read once it has been written.

## Mutable Variables

You can make a variable mutable by using the `mut` keyword before the variable name. Example: `let mut x = 5;` In Cairo, mutating a variable actually creates a new value in a different memory cell, but the compiler handles this automatically.

## Constants

Constants are declared using the `const` keyword. They are always immutable and must have a specified type. They can only be declared in the global scope. Example: `const ONE_HOUR_IN_SECONDS: u32 = 3600;`

## Variable Shadowing

You can declare a new variable with the same name, which shadows the previous one. This allows you to change the variable's type while keeping the same name. Example:

```
let x: u64 = 2;
let x: felt252 = x.into(); // changing the type from u64 to felt252
```

## Differences between `mut` and Shadowing

`mut` allows you to change the value of a variable, but not its type. Shadowing allows you to change both the value and the type of a variable.

## Cairo Compiler

The Cairo compiler helps detect errors related to attempting to change immutable variables. It ensures code safety by enforcing mutability rules.

## Key Takeaways

- Cairo promotes immutability as the default behavior, which helps in creating safer code.
- Mutating and shadowing variables provide flexibility in managing data.
- Understanding the differences between `mut` and shadowing is important for effective Cairo programming.

Remember that these concepts are fundamental to Cairo and may differ from other programming languages. Practice and experimenting with code will help you better understand these mechanisms.
