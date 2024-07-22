use core::array::ArrayTrait;
fn foo(mut arr: Array<u128>) {
    arr.pop_front();
}
fn foo2(p: Point) { // do something with p
}
#[derive(Copy, Drop)]
struct Point {
    x: u128,
    y: u128,
}
fn main() {
    let mut arr: Array<u128> = array![];
    foo(arr);
    // arr.append(1); // Error cause variable was moved already ^
    let p1 = Point { x: 5, y: 10 };
    foo2(p1);
    foo2(p1);
    example();
    snap();
    desnap();
    desnap1();
}


//snapshot
fn snap() {
    let mut arr1: Array<u128> = array![];
    let first_snapshot = @arr1; // Take a snapshot of `arr1` at this point in time
    arr1.append(1); // Mutate `arr1` by appending a value
    let first_length = calculate_length(
        first_snapshot
    ); // Calculate the length of the array when the snapshot was taken
    let second_length = calculate_length(@arr1); // Calculate the current length of the array
    println!("The length of the array when the snapshot was taken is {}", first_length);
    println!("The current length of the array is {}", second_length);
}

fn calculate_length(arr: @Array<u128>) -> usize {
    arr.len()
}


//desnap
#[derive(Drop)]
struct Rectangle {
    height: u64,
    width: u64,
}
fn desnap() {
    let rec = Rectangle { height: 3, width: 10 };
    let area = calculate_area(@rec);
    println!("Area: {}", area);
}

fn calculate_area(rec: @Rectangle) -> u64 {
    // As rec is a snapshot to a Rectangle, its fields are also snapshots of the fields types.
    // We need to transform the snapshots back into values using the desnap operator `*`.
    // This is only possible if the type is copyable, which is the case for u64.
    // Here, `*` is used for both multiplying the height and width and for desnapping the snapshots.
    *rec.height * *rec.width
}

// Mutable References
fn desnap1() {
    let mut rec = Rectangle { height: 3, width: 10 };
    flip(ref rec);
    println!("height: {}, width: {}", rec.height, rec.width);
}

fn flip(ref rec: Rectangle) {
    let temp = rec.height;
    rec.height = rec.width;
    rec.width = temp;
}

#[derive(Drop)]
struct A {}

fn example() {
    let a1 = gives_ownership(); // gives_ownership moves its return
    // value into a1

    let a2 = A {}; // a2 comes into scope

    let a3 = takes_and_gives_back(a2); // a2 is moved into
// takes_and_gives_back, which also
// moves its return value into a3

} // Here, a3 goes out of scope and is dropped. a2 was moved, so nothing
// happens. a1 goes out of scope and is dropped.

fn gives_ownership() -> A { // gives_ownership will move its
    // return value into the function
    // that calls it

    let some_a = A {}; // some_a comes into scope

    some_a // some_a is returned and
// moves ownership to the calling
// function
}

// This function takes an instance some_a of A and returns it
fn takes_and_gives_back(some_a: A) -> A { // some_a comes into scope
    some_a // some_a is returned and 
// moves ownership to the calling
// function
}


//tests

fn sum(arr: @Array<u128>) -> u128 {
    let mut span = arr.span();
    let mut sum = 0;
    println!("{:?}", span.pop_front());
    while let Option::Some(x) = span.pop_front() {
        sum += *x;
    };
    sum
}
fn asd() {
    let mut arr1: Array<u128> = array![1, 2, 3];
    let snap = @arr1;
    let mut snap2 = snap;
    arr1.append(4);
    snap2 = @arr1;
    println!("{}", sum(snap));
}
