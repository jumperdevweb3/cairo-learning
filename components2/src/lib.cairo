pub mod components;

use starknet::{ContractAddress};

// Contract
#[starknet::contract]
mod DepositsAndWithdrawals {
    use openzeppelin::access::ownable::ownable::OwnableComponent::InternalTrait;
    use starknet::{ContractAddress};
    use openzeppelin::access::ownable::interface::IOwnable;
    use openzeppelin::access::ownable::OwnableComponent;
    use super::components::transfers::{TransfersComponent};
    use TransfersComponent::Transfers;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: TransfersComponent, storage: transfers, event: TransfersEvent);

    #[abi(embed_v0)]
    impl TransfersMixinImpl = TransfersComponent::TransfersImpl<ContractState>;

    #[storage]
    struct Storage {
        balance: u256,
        deposits: LegacyMap::<ContractAddress, u256>,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        transfers: TransfersComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        TransfersEvent: TransfersComponent::Event,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        owner: ContractAddress,
        erc20_token: ContractAddress,
        tax_recipient: ContractAddress
    ) {
        self.ownable.initializer(owner);
        self.transfers.initializer(erc20_token, tax_recipient);
    }


    #[abi(embed_v0)]
    impl DepositsAndWithdrawals of super::IDepositsAndWithdrawals<ContractState> {
        fn deposit(ref self: ContractState, amount: u256) {}
    }

    #[generate_trait]
    impl PrivateFunctions of PrivateFunctionsTrait {}
}
#[starknet::interface]
trait IDepositsAndWithdrawals<TContractState> {
    fn deposit(ref self: TContractState, amount: u256);
}
