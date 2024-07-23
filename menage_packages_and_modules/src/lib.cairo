pub mod garden;
pub mod restaurant;
use garden::vegetables::Asparagus;
use restaurant::front_of_house::hosting;

pub fn eat_at_restaurant() {
    // Absolute path
    restaurant::front_of_house::hosting::add_to_waitlist();

    // Relative path
    hosting::add_to_waitlist();
}
fn main() {
    let plant = Asparagus {};
    println!("I'm growing {:?}!", plant);
}
