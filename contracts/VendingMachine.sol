// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

/**
 * @title VendingMachine
 * @dev A simple vending machine contract that allows users to purchase donuts using Ether.
 */
contract VendingMachine {
    address payable public owner;                // Address of the contract owner
    uint256 public donutPrice;                   // Price of one donut in Wei
    mapping (address  => uint256) public donutBalances; // Donut balances of users

    /**
     * @dev Constructor to initialize the contract with the initial donut price and an initial donut balance for the contract.
     * @param _initialDonutPrice The initial price of a single donut in Wei.
     */
    constructor(uint256 _initialDonutPrice) {
        owner = payable(msg.sender);             // Set the contract owner
        donutPrice = _initialDonutPrice;         // Set the initial donut price
        donutBalances[address(this)] = 100;      // Set an initial donut balance for the contract
    }

    /**
     * @dev Allows the owner to update the donut price.
     * @param newPrice The new price of a single donut in Wei.
     */
    function updateDonutPrice(uint256 newPrice) public {
        require(msg.sender == owner, "Only the owner can update the donut price.");
        donutPrice = newPrice;
    }

    /**
     * @dev Retrieves the current donut balance of the vending machine.
     * @return The donut balance of the vending machine contract.
     */
    function getVendingMachineBalance() public view returns (uint256) {
        return donutBalances[address(this)];
    }

    /**
     * @dev Allows the owner to restock the vending machine with more donuts.
     * @param amount The amount of donuts to add to the vending machine's balance.
     */
    function restock(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can restock this machine.");
        donutBalances[address(this)] += amount;
    }

    /**
     * @dev Allows a user to purchase a specified amount of donuts using Ether.
     * @param amount The amount of donuts to purchase.
     */
    function purchase(uint256 amount) public payable {
        require(msg.value >= amount * donutPrice, "Insufficient balance");
        require(donutBalances[address(this)] >= amount, "Not enough donuts in stock");
        donutBalances[address(this)] -= amount;
        donutBalances[msg.sender] += amount;
        payable(address(this)).transfer(msg.value);
    }

    /**
     * @dev Retrieves the donut balance of the caller.
     * @return The donut balance of the caller.
     */
    function myPurchase() public view returns (uint256) {
        return donutBalances[msg.sender];
    }

    /**
     * @dev Retrieves the system ether balance.
     */
    function systemBalance() public view returns (uint256) {
        require(msg.sender == owner, "Only the owner can withdraw Ether.");
        return address(this).balance;
    }

    /**
     * @dev Allows the owner to withdraw Ether from the contract.
     * @param amount The amount of Ether to withdraw.
     */
    function withdrawEther(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can withdraw Ether.");
        require(address(this).balance >= amount, "Not enough Ether balance");
        payable(owner).transfer(amount);
    }

    /**
     * @dev Retrieves the Ether balance of the contract owner.
     * @return The Ether balance of the contract owner.
     */
    function ownerEtherBalance() public view returns (uint256) {
        require(msg.sender == owner, "Only the owner can view this.");
        return owner.balance;
    }

    /**
     * @dev Fallback function to receive Ether. Allows the contract to accept incoming Ether payments.
     */
    receive() external payable {}
}
