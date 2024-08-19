#[starknet::interface]
pub trait ISwitchable<TContractState> {
    fn is_on(self: @TContractState) -> bool;
    fn switch(ref self: TContractState);
}

#[starknet::component]
pub mod switchable_component {
    #[storage]
    struct Storage {
        switchable_value: bool,
    }

    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub struct SwitchEvent {}

    #[event]
    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        SwitchEvent: SwitchEvent,
    }

    #[embeddable_as(Switchable)]
    impl SwitchableImpl<
        TContractState, +HasComponent<TContractState>
    > of super::ISwitchable<ComponentState<TContractState>> {
        fn is_on(self: @ComponentState<TContractState>) -> bool {
            self.switchable_value.read()
        }

        fn switch(ref self: ComponentState<TContractState>) {
            self.switchable_value.write(!self.switchable_value.read());
            self.emit(Event::SwitchEvent(SwitchEvent {}));
        }
    }

    #[generate_trait]
    pub impl SwitchableInternalImpl<
        TContractState, +HasComponent<TContractState>
    > of SwitchableInternalTrait<TContractState> {
        fn _off(ref self: ComponentState<TContractState>) {
            self.switchable_value.write(false);
        }
    }
}


#[starknet::contract]
pub mod SwitchContract {
    use super::switchable_component;

    component!(path: switchable_component, storage: switch, event: SwitchableEvent);

    #[abi(embed_v0)]
    impl SwitchableImpl = switchable_component::Switchable<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        switch: switchable_component::Storage,
    }

    #[event]
    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        SwitchableEvent: switchable_component::Event,
    }

    // You can optionally use the internal implementation of the component as well
    impl SwitchableInternalImpl = switchable_component::SwitchableInternalImpl<ContractState>;

    #[constructor]
    fn constructor(ref self: ContractState) {
        // Internal function call
        self.switch._off();
    }
}
