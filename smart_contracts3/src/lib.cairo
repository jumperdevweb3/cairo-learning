use starknet::{ContractAddress};
#[starknet::interface]
trait IERC20<TContractState> {
    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
    fn transferFrom(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;
}

#[starknet::contract]
mod DepositsAndWithdrawals {
    use core::array::ArrayTrait;
    use core::traits::TryInto;
    use starknet::{get_caller_address, ContractAddress, get_contract_address};
    use starknet::syscalls::call_contract_syscall;
    use super::IERC20;

    #[storage]
    struct Storage {
        owner: ContractAddress,
        balance: u256,
        stark_token: ContractAddress,
        tax_recipient: ContractAddress
    }

    #[constructor]
    fn constructor(
        ref self: ContractState, owner: ContractAddress, tax_recipient: ContractAddress
    ) {
        self.owner.write(owner);
        self.balance.write(0);
        self.tax_recipient.write(tax_recipient);
        self
            .stark_token
            .write(
                0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d
                    .try_into()
                    .unwrap()
            );
    }

    #[abi(embed_v0)]
    impl DepositsAndWithdrawals of super::IDepositsAndWithdrawals<ContractState> {
        fn deposit(ref self: ContractState, amount: u256) {
            let scaled_amount = amount * u256 { low: 1000000000000000000, high: 0 };
            let caller = get_caller_address();
            let current_balance_scaled = self.balance.read()
                * u256 { low: 1000000000000000000, high: 0 };
            let erc20_token_address = self.stark_token.read();

            // Check allowance
            let allowance = self.check_allowance(caller, get_contract_address());
            assert(allowance >= scaled_amount, 'Insufficient allowance');

            // Transfer tokens
            let transfer_success = self
                .transfer_from(caller, get_contract_address(), scaled_amount);
            assert(transfer_success, 'Transfer failed');

            let balance = self.balance.read();
            self.balance.write(balance + amount);
        }

        fn withdraw(ref self: ContractState, amount: u256) {
            let scaled_amount = amount * u256 { low: 1000000000000000000, high: 0 };
            let caller = get_caller_address();
            let owner = self.owner.read();
            assert(caller == owner, 'Only owner');

            let current_balance_scaled = self.balance.read()
                * u256 { low: 1000000000000000000, high: 0 };
            assert(current_balance_scaled >= scaled_amount, 'Insufficient balance');

            // Calculate tax
            let tax_amount = (scaled_amount * u256 { low: 5, high: 0 })
                / u256 { low: 100, high: 0 };
            let withdrawal_amount = scaled_amount - tax_amount;

            // Transfer tax and withdrawal amount
            let tax_recipient = self.tax_recipient.read();
            let tax_transfer_success = self.transfer(tax_recipient, tax_amount);
            assert(tax_transfer_success, 'Tax transfer failed');

            // Transfer rest of withdrawal amount
            let transfer_success = self.transfer(caller, withdrawal_amount);
            assert(transfer_success, 'Transfer failed');

            let balance = self.balance.read();
            self.balance.write(balance - amount);
        }

        fn get_owner_address(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }

        fn get_balance(self: @ContractState) -> u256 {
            self.balance.read()
        }
    }

    #[generate_trait]
    impl PrivateFunctions of PrivateFunctionsTrait {
        fn check_allowance(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress
        ) -> u256 {
            let mut calldata = ArrayTrait::new();
            calldata.append(owner.into());
            calldata.append(spender.into());

            let result = call_contract_syscall(
                self.stark_token.read(), selector!("allowance"), calldata.span()
            )
                .unwrap();

            let low: felt252 = *result.at(0);
            let high: felt252 = *result.at(1);
            u256 { low: low.try_into().unwrap(), high: high.try_into().unwrap() }
        }

        fn transfer_from(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) -> bool {
            let mut calldata = ArrayTrait::new();
            calldata.append(sender.into());
            calldata.append(recipient.into());
            calldata.append(amount.low.into());
            calldata.append(amount.high.into());

            let result = call_contract_syscall(
                self.stark_token.read(), selector!("transferFrom"), calldata.span()
            )
                .unwrap();
            true
        }

        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
            let mut calldata = ArrayTrait::new();
            calldata.append(recipient.into());
            calldata.append(amount.low.into());
            calldata.append(amount.high.into());

            let result = call_contract_syscall(
                self.stark_token.read(), selector!("transfer"), calldata.span()
            )
                .unwrap();
            true
        }
    }
}

#[starknet::interface]
trait IDepositsAndWithdrawals<TContractState> {
    fn deposit(ref self: TContractState, amount: u256);
    fn withdraw(ref self: TContractState, amount: u256);
    fn get_owner_address(self: @TContractState) -> ContractAddress;
    fn get_balance(self: @TContractState) -> u256;
}
