const Bitcoin = artifacts.require("Bitcoin");

module.exports = function (_deployer) {
  _deployer.deploy(Bitcoin);
  // Use deployer to state migration tasks.
};
