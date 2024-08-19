use starknet::{ContractAddress};

// Components
#[starknet::component]
pub mod TransfersComponent {
    use starknet::{ContractAddress};

    #[storage]
    struct Storage {
        erc20_token: ContractAddress,
        tax_recipient: ContractAddress,
    }

    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub struct TransfersEvent {}

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        TransfersEvent: TransfersEvent,
    }

    #[embeddable_as(TransfersImpl)]
    pub impl Transfers<
        TContractState, +HasComponent<TContractState>
    > of super::ITransfersComponent<ComponentState<TContractState>> {
        fn transfer(
            ref self: ComponentState<TContractState>, recipient: ContractAddress, amount: u256
        ) {
            true
        }
    }

    #[generate_trait]
    pub impl TransfersInternalImpl<
        TContractState, +HasComponent<TContractState>
    > of TransfersInternalTrait<TContractState> {
        fn initializer(
            ref self: ComponentState<TContractState>,
            erc20_token: ContractAddress,
            tax_recipient: ContractAddress
        ) {
            self.erc20_token.write(erc20_token);
            self.tax_recipient.write(tax_recipient);
        }
    }
}

#[starknet::interface]
trait ITransfersComponent<TContractState> {
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
}
