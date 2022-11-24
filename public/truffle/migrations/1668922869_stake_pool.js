const StakePool = artifacts.require("StakePool");
const fs = require("fs");
const contract = JSON.parse(
  fs.readFileSync(`${__dirname}/../build/contracts/Bitcoin.json`, "utf8")
);

module.exports = function (_deployer) {
  _deployer.deploy(StakePool, contract.networks[5777].address);
  // Use deployer to state migration tasks.
};
