const StakePool = artifacts.require("StakePool");

module.exports = function (_deployer) {
  _deployer.deploy(StakePool);
  // Use deployer to state migration tasks.
};
