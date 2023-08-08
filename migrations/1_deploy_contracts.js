const VendingMachine = artifacts.require("VendingMachine");

module.exports = function(deployer) {
  const initialDonuts = 100;
  deployer.deploy(VendingMachine, initialDonuts);
};
