# Arrays

An array is a collection of elements of the same type. In Cairo, arrays have limited modification options. Once a memory slot is written to, it cannot be overwritten, but only read from. You can only append items to the end of an array and remove items from the front.

## Creating an Array

To create an array, use the `ArrayTrait::new()` call. Here's an example:

```rust
let mut a = ArrayTrait::new();
a.append(0);
a.append(1);
a.append(2);
```

## Updating an Array

### Adding Elements

To add an element to the end of an array, use the `append()` method:

```rust
a.append(2);
```

### Removing Elements

To remove an element from the front of an array, use the `pop_front()` method:

```rust
let first_value = a.pop_front().unwrap();
```

## Reading Elements from an Array

To access array elements, you can use the `get()` or `at()` methods.

### `get()` Method

The `get()` function returns an option to a box type containing a snapshot of the element at the specified index. If the element doesn't exist, it returns `None`. Here's an example:

```rust
match arr.get(index_to_access) {
  Some(x) => *x.unbox(),
  None => panic!("out of bounds")
}
```

### `at()` Method

The `at()` function directly returns a snapshot of the element at the specified index. If the index is out of bounds, a panic error occurs. Here's an example:

```rust
assert!(*a.at(0) == 0, "item mismatch on index 0");
```

## Size-related Methods

To determine the number of elements in an array, use the `len()` method. To check if an array is empty, use the `is_empty()` method.

## `array!` Macro

The `array!` macro allows you to create arrays with values known at compile time. Here's an example:

```rust
let arr = array![1, 2, 3, 4, 5];
```

## Storing Multiple Types with Enums

If you want to store elements of different types in an array, you can use an enum. Here's an example:

```rust
enum Data {
  Integer(u128),
  Felt(felt252),
  Tuple(u32, u32),
}

let mut messages: Array<Data> = array![];
messages.append(Data::Integer(100));
messages.append(Data::Felt('hello world'));
messages.append(Data::Tuple((10, 30)));
```

## Span

A span is a snapshot of an array that provides safe and controlled access to its elements without modifying the original array. To create a span of an array, use the `span()` method:

```rust
array.span();
```
