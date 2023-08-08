// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract VendingMachine {
    address payable public owner;
    uint256 public donutPrice;
    mapping (address  => uint256) public donutBalances;

    constructor(uint256 _initialDonutPrice) {
        // set owner equal sender
        owner = payable(msg.sender);
        // Set the initial donut price
        donutPrice = _initialDonutPrice;  
        // address(this) means address of the contract
        donutBalances[address(this)] = 100;
    }

    // Update the donut price by the owner
    function updateDonutPrice(uint256 newPrice) public {
        require(msg.sender == owner, "Only the owner can update the donut price.");
        donutPrice = newPrice;
    }

    function getVendingMachineBalance() public view  returns (uint256) {
        // return the donut amount of smart contract address
        return donutBalances[address(this)];
    }

    function restock(uint256 amount) public {
        // check the sender is owner
        require(msg.sender == owner, "Only the owner can restock this machine.");
        // increment the donut amount of contract address
        donutBalances[address(this)] += amount;
    }

    // payable is used to send any ether to the account
    function purchase(uint256 amount) public payable {
        require(msg.value >= amount * donutPrice, "Insufficient balance");
        require(donutBalances[address(this)] >= amount, "No enough donut in stock");
         // decrement the donut amount of contract address
        donutBalances[address(this)] -= amount;
        // increment the donut amount of sender
        donutBalances[msg.sender] += amount;
        // Send ether to the owner
        owner.transfer(msg.value); 
    }

    function myPurchase() public view returns(uint256) {
        return donutBalances[msg.sender];
    }

    function withdrawEther(uint256 amount) public {
        require(msg.sender == owner, "Only owner can withdraw this.");
        require(address(this).balance >= amount, "Not enough ether balance");
        payable(owner).transfer(amount);
    }

    function ownerEtherBalance() public view returns (uint256) {
        require(msg.sender == owner, "Only owner can view this.");
        return owner.balance;
    }

    // Fallback function to receive ether
    receive() external payable {}
}