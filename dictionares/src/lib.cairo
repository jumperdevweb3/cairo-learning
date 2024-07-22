use core::dict::Felt252DictEntryTrait;
use core::nullable::{NullableTrait, match_nullable, FromNullableResult};
fn custom_get<T, +Felt252DictValue<T>, +Drop<T>, +Copy<T>>(
    ref dict: Felt252Dict<T>, key: felt252
) -> T {
    // Get the new entry and the previous value held at `key`
    let (entry, prev_value) = dict.entry(key);

    // Store the value to return
    let return_value = prev_value;

    // Update the entry with `prev_value` and get back ownership of the dictionary
    dict = entry.finalize(prev_value);

    // Return the read value
    return_value
}

fn custom_insert<T, +Felt252DictValue<T>, +Destruct<T>, +Drop<T>>(
    ref dict: Felt252Dict<T>, key: felt252, value: T
) {
    // Get the last entry associated with `key`
    // Notice that if `key` does not exist, `_prev_value` will
    // be the default value of T.
    let (entry, _prev_value) = dict.entry(key);

    // Insert `entry` back in the dictionary with the updated value,
    // and receive ownership of the dictionary
    dict = entry.finalize(value);
}
fn get_array_entry(ref dict: Felt252Dict<Nullable<Array<u8>>>, index: felt252) -> Span<u8> {
    let (entry, _arr) = dict.entry(index);
    let mut arr = _arr.deref_or(array![]);
    // Note: We must convert the array to a Span before finalizing the entry, because calling NullableTrait::new(arr) moves the array, thus making it impossible to return it from the function.
    let span = arr.span();
    dict = entry.finalize(NullableTrait::new(arr));
    span
}

fn append_value(ref dict: Felt252Dict<Nullable<Array<u8>>>, index: felt252, value: u8) {
    let (entry, arr) = dict.entry(index);
    let mut unboxed_val = arr.deref_or(array![]);
    unboxed_val.append(value);
    dict = entry.finalize(NullableTrait::new(unboxed_val));
}

fn main() {
    // Declare a dictionary with a key of type char and value of type u64
    let mut balances: Felt252Dict<u64> = Default::default();
    balances.insert('ALEX', 1000);
    balances.insert('Maria', 100);

    // Get the value of a key
    let alex_balance = balances.get('ALEX');
    println!("Alex balance: {}", alex_balance);

    let maria_balance = balances.get('Maria');
    println!("Maria blance: {}", maria_balance);

    // Update the value of a key
    balances.insert('ALEX', 2000);
    println!("Alex balance2: {}", balances.get('ALEX'));
    // Each operation register new entry in the dictionary
    // Entry struct
    // struct Entry<T> {
    //     key: felt252,
    //     previous_value: T,
    //     new_value: T,
    // }

    // Squashing Dictionaries
    // The process of squashing is as follows: given all entries with certain key k, taken in the same order as they were inserted, verify that the ith entry new_value is equal to the ith + 1 entry previous_value.
    // balances.squash();

    // Entry and finalize
    // The entry method comes as part of Felt252DictTrait<T> with the purpose of creating a new entry given a certain key. Once called, this method takes ownership of the dictionary and returns the entry to update. The method signature is as follows:
    // fn entry(self: Felt252Dict<T>, key: felt252) -> (Felt252DictEntry<T>, T) nopanic
    // The first input parameter takes ownership of the dictionary while the second one is used to create the appropriate entry. 
    // It returns a tuple containing a Felt252DictEntry<T>, which is the type used by Cairo to represent dictionary entries, and a T representing the value held previously. The nopanic notation simply indicates that the function is guaranteed to never panic.

    // Custom get
    // The ref keyword means that the ownership of the variable will be given back at the end of the function. This concept will be explained in more detail in the "References and Snapshots" section.
    let result = custom_get(ref balances, 'ALEX');
    println!("Result from custom_get for 'ALEX': {}", result);
    // Custom instert
    custom_insert(ref balances, 'ALEX', 3000);

    let mut dict: Felt252Dict<u64> = Default::default();

    custom_insert(ref dict, '0', 100);

    let val = custom_get(ref dict, '0');

    assert!(val == 100, "Expecting 100");

    // Dictionaries of Types not Supported Natively

    // Create the dictionary
    let mut d: Felt252Dict<Nullable<Span<felt252>>> = Default::default();

    // Create the array to insert
    let a = array![8, 9, 10];

    // Insert it as a `Span`
    d.insert(0, NullableTrait::new(a.span()));

    // Get value back
    let val = d.get(0);

    println!("Value: {:?}", val);

    // Search the value and assert it is not null
    let span = match match_nullable(val) {
        FromNullableResult::Null => panic!("No value found"),
        FromNullableResult::NotNull(val) => val.unbox(),
    };
    println!("Span: {:?}", span);

    // Verify we are having the right values
    assert!(*span.at(0) == 8, "Expecting 8");
    assert!(*span.at(1) == 9, "Expecting 9");
    assert!(*span.at(2) == 10, "Expecting 10");

    //Using arrays inside dictionaries
    // let arr = array![20, 19, 26];
    // let mut dict1: Felt252Dict<Nullable<Array<u8>>> = Default::default();
    // dict1.insert(0, NullableTrait::new(arr));
    // println!("Array inserted successfully.");
    // let res = get_array_entry(ref dict1, 0);
    // println!("Array get {:?}", res);

    let arr = array![20, 19, 26];
    let mut dict: Felt252Dict<Nullable<Array<u8>>> = Default::default();
    dict.insert(0, NullableTrait::new(arr));
    println!("Before insertion: {:?}", get_array_entry(ref dict, 0));

    append_value(ref dict, 0, 30);

    println!("After insertion: {:?}", get_array_entry(ref dict, 0));
}

