#[derive(Drop)]
enum Direction {
    North: u128,
    East: u128,
    South: u128,
    West: u128,
}

#[derive(Drop)]
enum Message {
    Quit,
    Echo: felt252,
    Move: (u128, u128)
}

trait Processing {
    fn process(self: Message);
}

impl ProcessingImpl of Processing {
    fn process(self: Message) {
        match self {
            Message::Quit => println!("Quitting"),
            Message::Echo => println!("Echoing"),
            Message::Move => println!("Moving"),
        }
    }
}
#[derive(Drop, Debug)]
enum Option<T> {
    Some: T,
    None,
}


#[derive(Drop, Debug)]
enum UsState {
    Alabama,
    Alaska,
}

#[derive(Drop)]
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter: UsState,
}

fn value_in_cents(coin: Coin) -> felt252 {
    match coin {
        Coin::Penny => {
            println!("Lucky penny!");
            1
        },
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter(state) => {
            println!("State quarter from {:?}!", state);
            25
        }
    }
}
fn plus_one(x: Option<u8>) -> Option<u8> {
    match x {
        Option::Some(val) => Option::Some(val + 1),
        Option::None => Option::None,
    }
}
fn vending_machine_accept(c: (DayType, Coin)) -> bool {
    match c {
        (DayType::Week, _) => true,
        (_, Coin::Dime) | (_, Coin::Quarter) => true,
        (_, _) => false,
    }
}

#[derive(Drop)]
enum DayType {
    Week,
    Weekend,
    Holiday
}

fn roll(value: u8) {
    match value {
        0 | 1 | 2 => println!("you won!"),
        3 => println!("you can roll again!"),
        _ => println!("you lost...")
    }
}


fn main() {
    let direction = Direction::North(10);
    let message = Message::Move((1, 2));
    message.process();
    value_in_cents(Coin::Quarter(UsState::Alaska));
    let five: Option<u8> = Option::Some(5);
    let six: Option<u8> = plus_one(five);
    let none = plus_one(Option::None);
    let resultOfVendingMachine = vending_machine_accept((DayType::Holiday, Coin::Nickel)); //false
    println!("resultOfVendingMachine - {:?}", resultOfVendingMachine);
    roll(3);

    // Concise Control flow with if let
    let number = Option::Some(5);
    if let Option::Some(max) = number {
        println!("The maximum is configured to be {}", max);
    }

    let coin = Coin::Quarter(UsState::Alabama);
    let mut count = 0;
    if let Coin::Quarter = coin {
        println!("You got a quarter!");
    } else {
        count += 1;
    }
    println!("count - {:?}", count);
}
