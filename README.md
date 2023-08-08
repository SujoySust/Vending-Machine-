# Vending Machine Contract

This is a Solidity smart contract representing a simple vending machine. Users can purchase donuts using Ether, and the contract keeps track of donut balances and Ether transactions.

## Prerequisites

Before deploying and testing the contract, ensure you have the following:

- Truffle: A development framework for Ethereum.
- Ganache: A personal Ethereum blockchain for local development and testing.

## Contract Details

- Contract Name: VendingMachine
- Solidity Version: ^0.8.11

### Deployment

1. Clone this repository.
2. Navigate to the project directory.
3. Install dependencies: `npm install`
4. Configure Ganache to run on port 7545.
5. Deploy the contract: `truffle migrate`

### Usage

1. Deploy the contract to a development network using Truffle.
2. Interact with the contract through the Truffle console or write tests using Truffle's testing framework.

### Contract Functions

- `updateDonutPrice(uint256 newPrice)`: Update the donut price by the owner.
- `getVendingMachineBalance()`: Get the current donut balance of the vending machine.
- `restock(uint256 amount)`: Allow the owner to restock the vending machine with donuts.
- `purchase(uint256 amount)`: Allow users to purchase donuts using Ether.
- `myPurchase()`: Get the donut balance of the caller.
- `withdrawEther(uint256 amount)`: Allow the owner to withdraw Ether from the contract.
- `ownerEtherBalance()`: Get the Ether balance of the contract owner.

### Testing

1. Configure Ganache to run on port 7545.
2. Run tests: `truffle test`

## Test Cases

Test cases are provided to ensure the contract's functionality.

- `should allow users to purchase donuts`: Test user donut purchases and balance updates.
- `should prevent non-owners from updating donut price`: Test ownership restrictions.
- ... (Add more test cases as needed)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
