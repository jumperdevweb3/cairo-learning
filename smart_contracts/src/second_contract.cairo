// The most common way for interacting with a contract’s storage is through storage variables. As stated previously, storage variables allow you to store data that will be stored in the contract's storage that is itself stored on the blockchain.
#[storage]
struct Storage {
    names: Map::<ContractAddress, felt252>,
    owner: Person,
    registration_type: Map<ContractAddress, RegistrationType>,
    total_names: u128,
}

// Storing Custom Types
// we want to store a Person struct in storage, which is only possible by implementing the Store trait for the Person type. This can be simply achieved by adding a #[derive(starknet::Store)] attribute on top of our struct definition. Note that all the members of the struct need to implement the Store trait.
#[derive(Drop, Serde, starknet::Store)]
pub struct Person {
    address: ContractAddress,
    name: felt252,
}

// Similarly, Enums can only be written to storage if they implement the Store trait, which can be trivially derived as long as all associated types implement the Store trait.
#[derive(Drop, Serde, starknet::Store)]
pub enum RegistrationType {
    finite: u64,
    infinite
}

//Constructors are a special type of function that only runs once when deploying a contract, and can be used to initialize the state of a contract.

// A contract can't have more than one constructor.
// The constructor function must be named constructor, and must be annotated with the #[constructor] attribute.

#[constructor]
fn constructor(ref self: ContractState, owner: Person) {
    self.names.entry(owner.address).write(owner.name);
    self.total_names.write(1);
    self.owner.write(owner);
}

// Public Functions
// They are usually defined inside an implementation block annotated with the #[abi(embed_v0)] attribute, but might also be defined independently under the #[external(v0)] attribute.
// The #[abi(embed_v0)] attribute means that all functions embedded inside it are implementations of the Starknet interface of the contract, and therefore potential entry points.
// Public functions inside an impl block
#[abi(embed_v0)]
impl NameRegistry of super::INameRegistry<ContractState> {
    fn store_name(ref self: ContractState, name: felt252, registration_type: RegistrationType) {
        let caller = get_caller_address();
        self._store_name(caller, name, registration_type);
    }

    fn get_name(self: @ContractState, address: ContractAddress) -> felt252 {
        self.names.entry(address).read()
    }

    fn get_owner(self: @ContractState) -> Person {
        self.owner.read()
    }
}

// External Functions
// External functions are public functions where the self: ContractState argument is passed by reference with the ref keyword, which exposes both the read and write access to storage variables. This allows modifying the state of the contract via self directly.

fn store_name(ref self: ContractState, name: felt252, registration_type: RegistrationType) {
    let caller = get_caller_address();
    self._store_name(caller, name, registration_type);
}

// View functions
// View functions are public functions where the self: ContractState argument is passed as snapshot, which only allows the read access to storage variables, and restricts writes to storage made via self by causing compilation errors. The compiler will mark their state_mutability to view, preventing any state modification through self directly.

fn get_name(self: @ContractState, address: ContractAddress) -> felt252 {
    self.names.entry(address).read()
}

// Defining Events
// All the different events in a contract are defined under the Event enum, which must implement the starknet::Event trait. This trait is defined in the core library as follows:

trait Event<T> {
    fn append_keys_and_data(self: T, ref keys: Array<felt252>, ref data: Array<felt252>);
    fn deserialize(ref keys: Span<felt252>, ref data: Span<felt252>) -> Option<T>;
}
#[derive(Drop, starknet::Event)]
struct StoredName {
    #[key]
    user: ContractAddress,
    name: felt252,
}
// The #[derive(starknet::Event)] attribute causes the compiler to generate an implementation for the above trait, instantiated with the Event type, which in our example is the following enum:
#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    StoredName: StoredName,
}
// !! Each variant of the Event enum has to be a struct or an enum, and each variant needs to implement the starknet::Event trait itself. Moreover, the members of these variants must implement the Serde trait (c.f. Appendix C: Serializing with Serde), as keys/data are added to the event using a serialization process.

// Emitting Events
// After defining events, we can emit them using self.emit, with the following syntax:

// self.emit(StoredName { user: user, name: name });

