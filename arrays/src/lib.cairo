fn create_first_arr() {
    // Create a new array
    let mut arr = ArrayTrait::<u128>::new();
    // Append some elements
    arr.append(0);
    arr.append(1);
    arr.append(2);

    // Remove an element 
    // You can only remove elements from the front of an array by using the pop_front() method. This method returns an Option that can be unwrapped, containing the removed element, or Option::None if the array is empty.
    let first_value = arr.pop_front().unwrap();
    println!("The first value is {}", first_value);
}

fn read_array_by_get() {
    // Reading elements fron an array
    // To access array elements, you can use get() or at() array methods that return different types. Using arr.at(index) is equivalent to using the subscripting operator arr[index].

    // get() method
    // The get function returns an Option<Box<@T>>, which means it returns an option to a Box type (Cairo's smart-pointer type) containing a snapshot to the element at the specified index if that element exists in the array. If the element doesn't exist, get returns None. This method is useful when you expect to access indices that may not be within the array's bounds and want to handle such cases gracefully without panics. 
    let mut arr_get = ArrayTrait::<u128>::new();
    arr_get.append(100);
    let index_to_access = 1;
    match arr_get.get(index_to_access) {
        Option::Some(x) => {
            let result = *x
                .unbox(); // It basically means "transform what get(idx) returned into a real value"
            println!("The value at index {} is {}", index_to_access, result);
        },
        Option::None => { panic!("out of bounds") }
    };
}

fn read_array_by_at() {
    // You should only use at when you want the program to panic if the provided index is out of the array's bounds, which can prevent unexpected behavior.
    let mut a = ArrayTrait::new();
    a.append(0);
    a.append(1);

    // using `at()` method
    assert(*a.at(0) == 0, 'item mismatch on index 0');
    // using subscripting operator
    assert(*a[1] == 1, 'item mismatch on index 1');
// In summary, use at when you want to panic on out-of-bounds access attempts, and use get when you prefer to handle such cases gracefully without panicking.
}

// size-related methods

fn size_methods() {
    // The size-related methods are used to get the number of elements in an array. The len() method returns the number of elements in the array, while the is_empty() method returns true if the array is empty and false otherwise.
    let mut arr = ArrayTrait::<u128>::new();
    arr.append(0);
    arr.append(1);
    arr.append(2);

    println!("The array has {} elements", arr.len());
    println!("Is the array empty? {}", arr.is_empty());
}

fn array_macro() {
    // The array! macro is used to create an array with a fixed size. The macro takes a list of elements and returns an array with the same elements. The array! macro is useful when you want to create an array with a fixed size and initialize it with a list of elements.
    let arr = array![1, 2, 3];
    println!("The array is {:?}", arr);
}
#[derive(Copy, Drop)]
enum Data {
    Integer: u128,
    Felt: felt252,
    Tuple: (u32, u32),
}

fn storing_different_types() {
    // If you want to store elements of different types in an array, you can use an Enum to define a custom data type that can hold multiple types.
    let mut messages: Array<Data> = array![];
    messages.append(Data::Integer(100));
    messages.append(Data::Felt('hello world'));
    messages.append(Data::Tuple((10, 30)));

    // Span is a struct that represents a snapshot of an Array. It is designed to provide safe and controlled access to the elements of an array without modifying the original array. Span is particularly useful for ensuring data integrity and avoiding borrowing issues when passing arrays between functions or when performing read-only operations
    messages.span();
}

fn main() {
    create_first_arr();
    read_array_by_get();
    read_array_by_at();
    size_methods();
    array_macro();
    storing_different_types();
}
