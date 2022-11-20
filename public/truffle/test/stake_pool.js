const StakePool = artifacts.require("StakePool");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("StakePool", function (/* accounts */) {
  it("should assert true", async function () {
    await StakePool.deployed();
    return assert.isTrue(true);
  });
});
