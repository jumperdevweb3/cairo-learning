use core::traits::TryInto;

fn main() {
    struct_examples();
    example1();
    example2();
    example3();
    example4();
    example5();
    // Method syntax
    example6();
    example7();
    example8();
    example9();
}

// Define struct
#[derive(Drop)]
struct User {
    active: bool,
    username: ByteArray,
    email: ByteArray,
    sign_in_count: u64,
}

// Struct basics
fn struct_examples() {
    // Create strcut instance
    let mut user1 = User {
        active: true, username: "someusername123", email: "someone@example.com", sign_in_count: 1
    };
    let user2 = User {
        sign_in_count: 1, username: "someusername123", active: true, email: "someone@example.com"
    };

    //To get a specific value from a struct, we use dot notation. 
    //Note that the entire instance must be mutable; Cairo doesn’t allow us to mark only certain fields as mutable.
    user1.email = "somethingelse@gmail.com";

    let user3 = build_user("aegon", "3@gmail.com");

    //Creating Instances from Other Instances
    let user4 = User { email: "something@gmail.com", ..user1, };
}
// Function to create user struct
fn build_user(email: ByteArray, username: ByteArray) -> User {
    User { active: true, username, email, sign_in_count: 1 }
}


// Examples
// Single variables
fn example1() {
    let width = 30;
    let height = 10;
    let area = area(width, height);
    println!("Area is {}", area);
}

fn area(width: u64, height: u64) -> u64 {
    width * height
}

// Example1 with tuples
fn example2() {
    let rectangle = (30, 10);
    let area = area2(rectangle);
    println!("Area2 is {}", area);
}

fn area2(dimension: (u64, u64)) -> u64 {
    let (x, y) = dimension;
    x * y
}

// Example1 with structs
#[derive(Drop, PartialEq)]
struct Rectangle {
    width: u64,
    height: u64,
}

fn example3() {
    let rectangle = Rectangle { width: 30, height: 10, };
    let area = area3(rectangle);
    println!("Area3 is {}", area);
}

fn area3(rectangle: Rectangle) -> u64 {
    rectangle.width * rectangle.height
}

// Conversions of Custom Types

// Into
#[derive(Drop)]
struct Square {
    side_length: u64,
}

impl SquareIntoRectangle of Into<Square, Rectangle> {
    fn into(self: Square) -> Rectangle {
        Rectangle { width: self.side_length, height: self.side_length }
    }
}

fn example4() {
    let square = Square { side_length: 5 };
    // Compiler will complain if you remove the type annotation
    let result: Rectangle = square.into();
    let expected = Rectangle { width: 5, height: 5 };
    assert!(
        result == expected,
        "A square is always convertible to a rectangle with the same width and height!"
    );
    println!("Conversion result is x - {} y - {}", result.width, result.height);
}


#[derive(Drop)]
struct Rectangle2 {
    width: u64,
    height: u64,
}

#[derive(Drop, PartialEq)]
struct Square2 {
    side_length: u64,
}

impl RectangleIntoSquare of TryInto<Rectangle2, Square2> {
    fn try_into(self: Rectangle2) -> Option<Square2> {
        if self.height == self.width {
            Option::Some(Square2 { side_length: self.height })
        } else {
            Option::None
        }
    }
}

fn example5() {
    let rectangle = Rectangle2 { width: 8, height: 8 };
    let result: Square2 = rectangle.try_into().unwrap();
    let expected = Square2 { side_length: 8 };
    assert!(
        result == expected,
        "Rectangle with equal width and height should be convertible to a square."
    );

    let rectangle = Rectangle2 { width: 5, height: 8 };
    let result: Option<Square2> = rectangle.try_into();
    assert!(
        result.is_none(),
        "Rectangle with different width and height should not be convertible to a square."
    );
}


// Method syntax

#[derive(Copy, Drop)]
struct Rectangle3 {
    width: u64,
    height: u64,
}

trait RectangleTrait {
    fn area(self: @Rectangle3) -> u64;
}

impl RectangleImpl of RectangleTrait {
    fn area(self: @Rectangle3) -> u64 {
        (*self.width) * (*self.height)
    }
}

fn example6() {
    let rect1 = Rectangle3 { width: 30, height: 50, };
    println!("Area is {}", rect1.area());
}

// Generate Trait

#[generate_trait]
impl RectangleImpl2 of RectangleTrait2 {
    fn area(self: @Rectangle) -> u64 {
        (*self.width) * (*self.height)
    }
    fn scale(ref self: Rectangle, factor: u64) {
        self.width *= factor;
        self.height *= factor;
    }
}

fn example7() {
    let mut rect2 = Rectangle { width: 10, height: 20 };
    rect2.scale(2);
    println!("The new size is (width: {}, height: {})", rect2.width, rect2.height);
}

// Methods with Several Parameters

#[generate_trait]
impl RectangleImpl3 of RectangleTrait3 {
    fn area(self: @Rectangle2) -> u64 {
        *self.width * *self.height
    }

    fn scale(ref self: Rectangle2, factor: u64) {
        self.width *= factor;
        self.height *= factor;
    }

    fn can_hold(self: @Rectangle2, other: @Rectangle2) -> bool {
        *self.width > *other.width && *self.height > *other.height
    }
}

fn example8() {
    let rect1 = Rectangle2 { width: 30, height: 50, };
    let rect2 = Rectangle2 { width: 10, height: 40, };
    let rect3 = Rectangle2 { width: 60, height: 45, };

    println!("Can rect1 hold rect2? {}", rect1.can_hold(@rect2));
    println!("Can rect1 hold rect3? {}", rect1.can_hold(@rect3));
}

#[derive(Copy, Drop, Debug)]
struct Rectangle4 {
    width: u64,
    height: u64,
}
// Associated Functions
#[generate_trait]
impl RectangleImpl5 of RectangleTrait5 {
    fn area(self: @Rectangle4) -> u64 {
        (*self.width) * (*self.height)
    }

    fn new(width: u64, height: u64) -> Rectangle4 {
        Rectangle4 { width, height }
    }

    fn square(size: u64) -> Rectangle4 {
        Rectangle4 { width: size, height: size }
    }

    fn avg(lhs: @Rectangle4, rhs: @Rectangle4) -> Rectangle4 {
        Rectangle4 {
            width: (((*lhs.width) + (*rhs.width)) / 2),
            height: (((*lhs.height) + (*rhs.height)) / 2)
        }
    }
}

fn example9() {
    let rect1 = RectangleTrait5::new(30, 50);
    let rect2 = RectangleTrait5::square(10);

    println!(
        "The average Rectangle of {:?} and {:?} is {:?}",
        @rect1,
        @rect2,
        RectangleTrait5::avg(@rect1, @rect2)
    );
}


// Multiple Traits and impl blocks
// Each struct is allowed to have multiple trait and impl blocks. For example, the following code is equivalent to the code shown in the Methods with several parameters section, which has each method in its own trait and impl blocks.
#[generate_trait]
impl RectangleCalcImpl of RectangleCalc {
    fn area(self: @Rectangle) -> u64 {
        (*self.width) * (*self.height)
    }
}

#[generate_trait]
impl RectangleCmpImpl of RectangleCmp {
    fn can_hold(self: @Rectangle, other: @Rectangle) -> bool {
        *self.width > *other.width && *self.height > *other.height
    }
}
