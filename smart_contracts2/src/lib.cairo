#[starknet::contract]
mod IncrementContract {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        owner: ContractAddress,
        target_number: u128,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.owner.write(owner);
        self.target_number.write(0);
    }

    #[abi(embed_v0)]
    impl IncrementContract of super::IIncrementContract<ContractState> {
        fn increment(ref self: ContractState) {
            let caller = get_caller_address();
            let owner = self.owner.read();
            assert(caller == owner, 'Owner Only');

            let current_value = self.target_number.read();
            self.target_number.write(current_value + 1);
        }

        fn get_target_number(self: @ContractState) -> u128 {
            self.target_number.read()
        }
        fn get_owner_address(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }
}
use starknet::{ContractAddress};
#[starknet::interface]
trait IIncrementContract<TContractState> {
    fn increment(ref self: TContractState);
    fn get_target_number(self: @TContractState) -> u128;
    fn get_owner_address(self: @TContractState) -> ContractAddress;
}
