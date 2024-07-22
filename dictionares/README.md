# Basic Use of Dictionaries

Definition and Initialization: `Felt252Dict<T>` is a dictionary where keys are of type `felt252` and values are of type `T`.

## Core Operations

- `insert(felt252, T) -> ()`: Inserts a key-value pair.
- `get(felt252) -> T`: Retrieves the value associated with a key.

### Code Example: Basic Operations

```rust
fn main() {
  let mut balances: Felt252Dict<u64> = Default::default();
  balances.insert('Alex', 100);
  balances.insert('Maria', 200);

  let alex_balance = balances.get('Alex');
  assert!(alex_balance == 100, "Balance is not 100");

  let maria_balance = balances.get('Maria');
  assert!(maria_balance == 200, "Balance is not 200");
}
```

## Dictionaries Underneath

Cairo's memory is immutable, so `Felt252Dict<T>` simulates mutability by maintaining a list of entries, each representing a dictionary access.

### Entry Structure

- `key`: The dictionary key.
- `previous_value`: The previous value associated with the key.
- `new_value`: The new value associated with the key.

### Code Example: Entry List

```rust
struct Entry<T> {
  key: felt252,
  previous_value: T,
  new_value: T,
}

fn main() {
  let mut balances: Felt252Dict<u64> = Default::default();
  balances.insert('Alex', 100_u64);
  balances.insert('Maria', 50_u64);
  balances.insert('Alex', 200_u64);
  balances.get('Maria');
}
```

## Squashing Dictionaries

To ensure computational integrity, Cairo uses a method called `squash_dict` to verify that dictionary operations are coherent.

### Squashing Process

Verifies that the `new_value` of the ith entry matches the `previous_value` of the (i+1)th entry.

## Custom Dictionary Methods

Cairo provides methods like `entry` and `finalize` to manually manage dictionary entries.

### Code Example: Custom `get` Method

```rust
use core::dict::Felt252DictEntryTrait;

fn custom_get<T, +Felt252DictValue<T>, +Drop<T>, +Copy<T>>(
  ref dict: Felt252Dict<T>, key: felt252
) -> T {
  let (entry, prev_value) = dict.entry(key);
  let return_value = prev_value;
  dict = entry.finalize(prev_value);
  return_value
}
```

### Code Example: Custom `insert` Method

```rust
use core::dict::Felt252DictEntryTrait;

fn custom_insert<T, +Felt252DictValue<T>, +Destruct<T>, +Drop<T>>(
  ref dict: Felt252Dict<T>, key: felt252, value: T
) {
  let (entry, _prev_value) = dict.entry(key);
  dict = entry.finalize(value);
}
```

## Dictionaries of Non-Native Types

For types not natively supported, use `Nullable<T>` and `Box<T>` to store complex types like arrays or structs.

### Code Example: Storing Complex Types

```rust
use core::nullable::{NullableTrait, match_nullable, FromNullableResult};

fn main() {
  let mut d: Felt252Dict<Nullable<Span<felt252>>> = Default::default();
  let a = array![8, 9, 10];
  d.insert(0, NullableTrait::new(a.span()));

  let val = d.get(0);
  let span = match match_nullable(val) {
    FromNullableResult::Null => panic!("No value found"),
    FromNullableResult::NotNull(val) => val.unbox(),
  };
  assert!(*span.at(0) == 8, "Expecting 8");
  assert!(*span.at(1) == 9, "Expecting 9");
  assert!(*span.at(2) == 10, "Expecting 10");
}
```

## Using Arrays Inside Dictionaries

Special handling is required for arrays due to their complexity.

### Code Example: Inserting and Modifying Arrays

```rust
use core::nullable::NullableTrait;
use core::dict::Felt252DictEntryTrait;

fn append_value(ref dict: Felt252Dict<Nullable<Array<u8>>>, index: felt252, value: u8) {
  let (entry, arr) = dict.entry(index);
  let mut unboxed_val = arr.deref_or(array![]);
  unboxed_val.append(value);
  dict = entry.finalize(NullableTrait::new(unboxed_val));
}

fn get_array_entry(ref dict: Felt252Dict<Nullable<Array<u8>>>, index: felt252) -> Span<u8> {
  let (entry, _arr) = dict.entry(index);
  let mut arr = _arr.deref_or(array![]);
  let span = arr.span();
  dict = entry.finalize(NullableTrait::new(arr));
  span
}

fn main() {
  let arr = array![20, 19, 26];
  let mut dict: Felt252Dict<Nullable<Array<u8>>> = Default::default();
  dict.insert(0, NullableTrait::new(arr));

  println!("Before insertion: {:?}", get_array_entry(ref dict, 0));
  append_value(ref dict, 0, 30);
  println!("After insertion: {:?}", get_array_entry(ref dict, 0));
}
```
