const VendingMachine = artifacts.require("VendingMachine");
const truffleAssert = require('truffle-assertions');

contract("VendingMachine", (accounts) => {
    let vendingMachine;
    const owner = accounts[0];
    const user1 = accounts[1];
    const user2 = accounts[2];
    const initialDonutPrice = web3.utils.toWei("0.01", "ether");
 
    beforeEach(async () => {
        vendingMachine = await VendingMachine.new(initialDonutPrice, { from: owner });
    });

    it("should initialize the contract with correct initial values", async () => {
        const contractOwner = await vendingMachine.owner();
        assert.equal(contractOwner, owner, "Incorrect owner");
        
        const donutPrice = await vendingMachine.donutPrice();
        assert.equal(donutPrice, initialDonutPrice, "Incorrect initial donut price");
        
        const contractBalance = await vendingMachine.getVendingMachineBalance();
        assert.equal(contractBalance, 100, "Incorrect initial contract donut balance");
    });

    it("should allow the owner to update donut price", async () => {
        const newDonutPrice = web3.utils.toWei("0.015", "ether");
        await vendingMachine.updateDonutPrice(newDonutPrice, { from: owner });

        const updatedDonutPrice = await vendingMachine.donutPrice();
        assert.equal(updatedDonutPrice, newDonutPrice, "Donut price not updated");
    });

    it("should allow the owner to restock donuts", async () => {
        const restockAmount = 50;
        await vendingMachine.restock(restockAmount, { from: owner });

        const contractBalance = await vendingMachine.getVendingMachineBalance();
        assert.equal(contractBalance, 150, "Donut balance not updated after restock");
    });

    it("should allow users to purchase donuts", async () => {
        const purchaseAmount = 5;
        const totalPrice = initialDonutPrice * purchaseAmount;
        
        await vendingMachine.purchase(purchaseAmount, { from: user1, value: totalPrice });

        const user1Balance = await vendingMachine.myPurchase({ from: user1 });
        assert.equal(user1Balance, purchaseAmount, "User balance not updated after purchase");

        const contractBalance = await vendingMachine.getVendingMachineBalance();
        assert.equal(contractBalance, 95, "Donut balance not updated after purchase");
    });
    

    it("should prevent non-owners from updating donut price", async () => {
        const newDonutPrice = web3.utils.toWei("0.015", "ether");
        await truffleAssert.reverts(
            vendingMachine.updateDonutPrice(newDonutPrice, { from: user1 }),
            "Only the owner can update the donut price."
        );
    });

    it("should prevent non-owners from restocking donuts", async () => {
        const restockAmount = 50;
        await truffleAssert.reverts(
            vendingMachine.restock(restockAmount, { from: user1 }),
            "Only the owner can restock this machine."
        );
    });

    it("should prevent purchasing more donuts than available", async () => {
        const purchaseAmount = 200;
        const totalPrice = initialDonutPrice * purchaseAmount;
        await truffleAssert.reverts(
            vendingMachine.purchase(purchaseAmount, { from: user1, value: totalPrice }),
            "Not enough donuts in stock"
        );
    });

    it("should allow the contract to receive Ether", async () => {
        const depositAmount = web3.utils.toWei("0.02", "ether");
        await web3.eth.sendTransaction({
            from: user1,
            to: vendingMachine.address,
            value: depositAmount
        });

        const contractBalance = await web3.eth.getBalance(vendingMachine.address);
        assert.equal(contractBalance.toString(), depositAmount, "Contract balance not updated after deposit");
    });
});
