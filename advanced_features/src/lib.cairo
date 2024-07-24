use core::nullable::NullableTrait;
use core::pedersen::PedersenTrait;
use core::poseidon::PoseidonTrait;
use core::poseidon::poseidon_hash_span;
use core::hash::{HashStateTrait, HashStateExTrait};
use core::serde::Serde;
use core::fmt::Formatter;
struct UserDatabase<T> {
    users_updates: u64,
    balances: Felt252Dict<T>
}

trait UserDatabaseTrait<T> {
    fn new() -> UserDatabase<T>;
    fn update_user<+Drop<T>>(ref self: UserDatabase<T>, name: felt252, balance: T);
    fn get_balance<+Copy<T>>(ref self: UserDatabase<T>, name: felt252) -> T;
}
impl UserDatabaseImpl<T, +Felt252DictValue<T>> of UserDatabaseTrait<T> {
    // Creates a database
    fn new() -> UserDatabase<T> {
        UserDatabase { users_updates: 0, balances: Default::default() }
    }

    // Get the user's balance
    fn get_balance<+Copy<T>>(ref self: UserDatabase<T>, name: felt252) -> T {
        self.balances.get(name)
    }

    // Add a user
    fn update_user<+Drop<T>>(ref self: UserDatabase<T>, name: felt252, balance: T) {
        self.balances.insert(name, balance);
        self.users_updates += 1;
    }
}


impl UserDatabaseDestruct<T, +Drop<T>, +Felt252DictValue<T>> of Destruct<UserDatabase<T>> {
    fn destruct(self: UserDatabase<T>) nopanic {
        self.balances.squash();
    }
}

fn user_db() {
    let mut db = UserDatabaseTrait::<u64>::new();

    db.update_user('Alex', 100);
    db.update_user('Maria', 80);

    db.update_user('Alex', 40);
    db.update_user('Maria', 0);

    let alex_latest_balance = db.get_balance('Alex');
    let maria_latest_balance = db.get_balance('Maria');

    println!("Alex's latest balance: {}", alex_latest_balance);
    println!("Maria's latest balance: {}", maria_latest_balance);
}


// Simulating a Dynamic Array with Dicts
trait VecTrait<V, T> {
    fn new() -> V;
    fn get(ref self: V, index: usize) -> Option<T>;
    fn at(ref self: V, index: usize) -> T;
    fn push(ref self: V, value: T) -> ();
    fn set(ref self: V, index: usize, value: T);
    fn len(self: @V) -> usize;
}
// Implementing a Dynamic Array 
struct NullableVec<T> {
    data: Felt252Dict<Nullable<T>>,
    len: usize
}

impl DestructeNullableVec<T, +Drop<T>> of Destruct<NullableVec<T>> {
    fn destruct(self: NullableVec<T>) nopanic {
        self.data.squash();
    }
}
impl NullableVecImpl<T, +Drop<T>, +Copy<T>> of VecTrait<NullableVec<T>, T> {
    fn new() -> NullableVec<T> {
        NullableVec { data: Default::default(), len: 0 }
    }

    fn get(ref self: NullableVec<T>, index: usize) -> Option<T> {
        if index < self.len() {
            Option::Some(self.data.get(index.into()).deref())
        } else {
            Option::None
        }
    }

    fn at(ref self: NullableVec<T>, index: usize) -> T {
        assert!(index < self.len(), "Index out of bounds");
        self.data.get(index.into()).deref()
    }

    fn push(ref self: NullableVec<T>, value: T) -> () {
        self.data.insert(self.len.into(), NullableTrait::new(value));
        self.len = core::integer::u32_wrapping_add(self.len, 1_usize);
    }
    fn set(ref self: NullableVec<T>, index: usize, value: T) {
        assert!(index < self.len(), "Index out of bounds");
        self.data.insert(index.into(), NullableTrait::new(value));
    }
    fn len(self: @NullableVec<T>) -> usize {
        *self.len
    }
}

// Smart Pointers
#[derive(Drop)]
struct Cart {
    paid: bool,
    items: u256,
    buyer: ByteArray
}
// When passing data to a function, the entire data is copied into the last available memory cells right before the function call. 
// Calling pass_data will copy all 3 fields of Cart to memory, while pass_pointer only requires the copy of the new_box pointer which is of size 1.

fn pass_data(cart: Cart) {
    println!("{} is shopping today and bought {} items", cart.buyer, cart.items);
}

fn pass_pointer(cart: Box<Cart>) {
    let cart = cart.unbox();
    println!("{} is shopping today and bought {} items", cart.buyer, cart.items);
}

fn smart_pointers() {
    let new_struct = Cart { paid: true, items: 1, buyer: "Eli" };
    pass_data(new_struct);

    let new_box = BoxTrait::new(Cart { paid: false, items: 2, buyer: "Uri" });
    pass_pointer(new_box);
}

// Operator Overloading
struct Potion {
    health: felt252,
    mana: felt252
}

impl PotionAdd of Add<Potion> {
    fn add(lhs: Potion, rhs: Potion) -> Potion {
        Potion { health: lhs.health + rhs.health, mana: lhs.mana + rhs.mana, }
    }
}

fn overloading() {
    let health_potion: Potion = Potion { health: 100, mana: 0 };
    let mana_potion: Potion = Potion { health: 0, mana: 100 };
    let super_potion: Potion = health_potion + mana_potion;
    // Both potions were combined with the `+` operator.
    assert(super_potion.health == 100, '');
    assert(super_potion.mana == 100, '');
}

// Hashes

/// A trait for values that can be hashed.
// trait Hash<T, S, +HashStateTrait<S>> {
//     /// Updates the hash state with the given value.
//     fn update_state(state: S, value: T) -> S;
// }

// #[derive(Drop, Hash)]
// struct StructForHash {
//     first: felt252,
//     second: felt252,
//     third: (u32, u32),
//     last: bool,
// }
// fn hashfn() -> (felt252, felt252) {
//     let struct_to_hash = StructForHash { first: 0, second: 1, third: (1, 2), last: false };

//     // hash1 is the result of hashing a struct with a base state of 0
//     let hash1 = PedersenTrait::new(0).update_with(struct_to_hash).finalize();

//     let mut serialized_struct: Array<felt252> = ArrayTrait::new();
//     Serde::serialize(@struct_to_hash, ref serialized_struct);
//     let first_element = serialized_struct.pop_front().unwrap();
//     let mut state = PedersenTrait::new(first_element);

//     while let Option::Some(value) = serialized_struct.pop_front() {
//         state = state.update(value);
//     };

//     // hash2 is the result of hashing only the fields of the struct
//     let hash2 = state.finalize();

//     (hash1, hash2)
// }
#[derive(Drop)]
struct StructForHashArray {
    first: felt252,
    second: felt252,
    third: Array<felt252>,
}
fn hashfn() {
    let struct_to_hash = StructForHashArray { first: 0, second: 1, third: array![1, 2, 3, 4, 5] };

    let mut hash = PoseidonTrait::new().update(struct_to_hash.first).update(struct_to_hash.second);
    let hash_felt252 = hash.update(poseidon_hash_span(struct_to_hash.third.span())).finalize();
}

// Macro

fn macros() {
    // consteval_int! Macro
    let x = consteval_int!(
        2 + 2
    ); //This will be interpreted as const a: felt252 = 8; by the compiler.
    // print! and println! Macros
    print!("Hello, world!");
    println!("Hello, world!");
    // array! Macro
    let my_array = array![1, 2, 3, 4, 5];
    // panic! Macro
    // panic!("This is a panic message");
    //assert! Macro
    assert!(true, "This is a message");
    //format! Macro
    let s1 = 'hello';
    let s2 = 'world';
    let s = format!("{s1}-{s2}"); // s1, s2 are not consumed by format!
    println!("{}", s);
    // write! and writeln! Macros
    let mut formatter: Formatter = Default::default();
    let a = 10;
    let b = 20;
    write!(formatter, "hello");
    write!(formatter, "world");
    write!(formatter, " {a} {b}");
    println!("{}", formatter.buffer); // helloworld 10 20
}


// Inlining
fn inlining_fn() {
    inlined() + not_inlined();
}
#[inline(always)]
fn inlined() -> felt252 {
    1
}

#[inline(never)]
fn not_inlined() -> felt252 {
    2
}

fn main() {
    user_db();
    smart_pointers();
    hashfn();
    macros();
    inlining_fn();
}

