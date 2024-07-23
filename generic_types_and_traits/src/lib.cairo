pub mod rectangle;
use rectangle::rectangle::Rectangle;
pub mod circle;
use circle::circle::Circle;

fn find_largest() {
    let mut number_list: Array<u8> = array![34, 50, 25, 100, 65];

    let mut largest = number_list.pop_front().unwrap();

    while let Option::Some(number) = number_list
        .pop_front() {
            if number > largest {
                largest = number;
            }
        };

    println!("The largest number is {}", largest);

    let mut number_list: Array<u8> = array![102, 34, 255, 89, 54, 2, 43, 8];

    let mut largest = number_list.pop_front().unwrap();

    while let Option::Some(number) = number_list
        .pop_front() {
            if number > largest {
                largest = number;
            }
        };

    println!("The largest number is {}", largest);
}

// shorter version

fn largest(ref number_list: Array<u8>) -> u8 {
    let mut largest = number_list.pop_front().unwrap();

    while let Option::Some(number) = number_list
        .pop_front() {
            if number > largest {
                largest = number;
            }
        };

    largest
}

fn shorter_find_largest() {
    let mut number_list = array![34, 50, 25, 100, 65];

    let result = largest(ref number_list);
    println!("The largest number is {}", result);

    let mut number_list = array![102, 34, 255, 89, 54, 2, 43, 8];

    let result = largest(ref number_list);
    println!("The largest number is {}", result);
}

// Generic version
fn largest_list<T, impl TDrop: Drop<T>>(l1: Array<T>, l2: Array<T>) -> Array<T> {
    if l1.len() > l2.len() {
        l1
    } else {
        l2
    }
}

fn generic_find_largest() {
    let mut l1 = array![1, 2];
    let mut l2 = array![3, 4, 5];

    // There is no need to specify the concrete type of T because
    // it is inferred by the compiler
    let l3 = largest_list(l1, l2);
    println!("The largest list is {:?}", l3);
}


// Given a list of T get the smallest one
// The PartialOrd trait implements comparison operations for T
// fn smallest_element<T, impl TPartialOrd: PartialOrd<T>, impl TCopy: Copy<T>, impl TDrop: Drop<T>>(
// Anonymous Generic Implementation Parameter (+ Operator)
fn smallest_element<T, +PartialOrd<T>, +Copy<T>, +Drop<T>>(list: @Array<T>) -> T {
    let mut smallest = *list[0];
    let mut index = 1;

    while index < list
        .len() {
            if *list[index] < smallest {
                smallest = *list[index];
            }
            index = index + 1;
        };

    smallest
}
fn smallest_element_test() {
    let list: Array<u8> = array![5, 3, 10];

    // We need to specify that we are passing a snapshot of `list` as an argument
    let s = smallest_element(@list);
    assert!(s == 3);
}

//Generic structs
#[derive(Copy, Drop)]
struct Wallet<T> {
    balance: T
}

/// Generic trait for wallets
trait WalletTrait<T> {
    fn balance(self: @Wallet<T>) -> T;
}

impl WalletImpl<T, +Copy<T>> of WalletTrait<T> {
    fn balance(self: @Wallet<T>) -> T {
        return *self.balance;
    }
}

/// Trait for wallets of type u128
trait WalletReceiveTrait {
    fn receive(ref self: Wallet<u128>, value: u128);
}

impl WalletReceiveImpl of WalletReceiveTrait {
    fn receive(ref self: Wallet<u128>, value: u128) {
        self.balance += value;
    }
}

struct Wallet2<T, U> {
    balance: T,
    address: U,
}

trait WalletMixTrait<T1, U1> {
    fn mixup<T2, +Drop<T2>, U2, +Drop<U2>>(
        self: Wallet2<T1, U1>, other: Wallet2<T2, U2>
    ) -> Wallet2<T1, U2>;
}

impl WalletMixImpl<T1, +Drop<T1>, U1, +Drop<U1>> of WalletMixTrait<T1, U1> {
    fn mixup<T2, +Drop<T2>, U2, +Drop<U2>>(
        self: Wallet2<T1, U1>, other: Wallet2<T2, U2>
    ) -> Wallet2<T1, U2> {
        Wallet2 { balance: self.balance, address: other.address }
    }
}

fn wallet_test() {
    let mut w = Wallet { balance: 50 };
    assert!(w.balance() == 50);

    w.receive(100);
    assert!(w.balance() == 150);

    let w1: Wallet2<bool, u128> = Wallet2 { balance: true, address: 10 };
    let w2: Wallet2<felt252, u8> = Wallet2 { balance: 32, address: 100 };

    let w3 = w1.mixup(w2);

    assert!(w3.balance);
    assert!(w3.address == 100);
}

// Implementing a Trait on a type

#[derive(Drop)]
pub struct NewsArticle {
    pub headline: ByteArray,
    pub location: ByteArray,
    pub author: ByteArray,
    pub content: ByteArray,
}
pub trait Summary<T> {
    fn summarize(self: @T) -> ByteArray;
}
impl NewsArticleSummary of Summary<NewsArticle> {
    fn summarize(self: @NewsArticle) -> ByteArray {
        format!("{} by {} ({})", self.headline, self.author, self.location)
    }
}

#[derive(Drop)]
pub struct Tweet {
    pub username: ByteArray,
    pub content: ByteArray,
    pub reply: bool,
    pub retweet: bool,
}

impl TweetSummary of Summary<Tweet> {
    fn summarize(self: @Tweet) -> ByteArray {
        format!("{}: {}", self.username, self.content)
    }
}

fn summarize() {
    let news = NewsArticle {
        headline: "Cairo has become the most popular language for developers",
        location: "Worldwide",
        author: "Cairo Digger",
        content: "Cairo is a new programming language for zero-knowledge proofs",
    };

    let tweet = Tweet {
        username: "EliBenSasson",
        content: "Crypto is full of short-term maximizing projects. \n @Starknet and @StarkWareLtd are about long-term vision maximization.",
        reply: false,
        retweet: false
    }; // Tweet instantiation

    println!("New article available! {}", news.summarize());
    println!("New tweet! {}", tweet.summarize());
}

// Here T is an alias type which will be provided during implementation
pub trait ShapeGeometry<T> {
    fn boundary(self: T) -> u64;
    fn area(self: T) -> u64;
}


fn shape() {
    let rect = Rectangle { height: 5, width: 7 };
    println!("Rectangle area: {}", ShapeGeometry::area(rect)); //35
    println!("Rectangle boundary: {}", ShapeGeometry::boundary(rect)); //24

    let circ = Circle { radius: 5 };
    println!("Circle area: {}", ShapeGeometry::area(circ)); //78
    println!("Circle boundary: {}", ShapeGeometry::boundary(circ)); //31
}

fn main() {
    find_largest();
    shorter_find_largest();
    generic_find_largest();
    summarize();
    shape();
}
