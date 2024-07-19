# Function Definition:

Functions in Cairo are defined using the keyword `fn`, followed by the function name and parentheses `()`.
The body of the function is enclosed in curly braces `{}`.
The naming convention for functions is `snake_case` (lowercase letters and underscores).

# Function Parameters:

Parameters are declared within parentheses `()`, specifying the name and type (e.g., `x: u32`).
Parameter types must always be declared.
Multiple parameters can be used, separated by commas.

# Named Parameters:

When calling a function, named parameters can be used (e.g., `foo(x: 3, y: 4)`).
If the variable name is the same as the parameter name, a shorthand notation can be used (e.g., `:x`).

# Statements and Expressions:

Statements perform actions and do not return values (e.g., `let y = 6;`).
Expressions return a value (e.g., `5 + 6`).
A code block enclosed in curly braces is an expression.

# Returning Values:

The return type is declared after the arrow `->` (e.g., `-> u32`).
The value of the last expression in a function is automatically returned.
The keyword `return` can be used to return a value earlier.

# Examples:

Simple function:

```cairo
fn five() -> u32 {
  5
}
```

Function with parameter:

```cairo
fn plus_one(x: u32) -> u32 {
  x + 1
}
```

# Notes:

Adding a semicolon at the end of an expression turns it into a statement, which can lead to errors when returning values.
Cairo is an expression-based language, which affects the way functions are written.
