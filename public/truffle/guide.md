## deploy on develop of truffle

```
truffle develop
migrate --compile-all --reset
```

## deploy on ganache

```
truffle migrate --compile-all --reset --network ganache
truffle console --network ganache

accounts[1]
accounts[2]
StakePool.address
await web3.utils.fromWei(web3.utils.toBN(await web3.eth.getBalance(StakePool.address)), "ether");
await web3.utils.fromWei(web3.utils.toBN(await web3.eth.getBalance(accounts[0])), "ether");
await web3.utils.fromWei(web3.utils.toBN(await web3.eth.getBalance(accounts[1])), "ether");
await web3.utils.fromWei(web3.utils.toBN(await web3.eth.getBalance(accounts[2])), "ether");

let app = await StakePool.deployed();
let token = await Bitcoin.deployed();
token.transfer(StakePool.address, 500_000_000, { from: accounts[0], gas: 500000 });
token.transfer(accounts[1], 500_000, { from: accounts[0], gas: 500000 });
token.transfer(accounts[2], 500_000, { from: accounts[0], gas: 500000 });

token.balanceOf(accounts[0]);
token.balanceOf(accounts[2]);
token.balanceOf(StakePool.address);
token.balanceOf(Bitcoin.address);


token.approve(StakePool.address, 100_000, { from: accounts[1], gas: 500000 });
app.deposit(100_000, Math.floor(Date.now() / 1000), 30, { from: accounts[1], gas: 500000 });

token.approve(StakePool.address, 10_000, { from: accounts[2], gas: 500000 });
app.deposit(10_000, Math.floor(Date.now() / 1000), 30, { from: accounts[2], gas: 500000 });
app.withdraw(Math.floor(Date.now() / 1000) - 100, { from: accounts[2] });
app.getStakerInfo(accounts[2], { from: accounts[2] });

app.adminWithdraw(1_000, { from: accounts[0] });

web3.utils.isBigNumber(token.balanceOf(accounts[0]));
web3.utils.fromWei(token.balanceOf(accounts[0]), "ether");

app.deposit(Math.floor(Date.now() / 1000), 30, { from: accounts[1], value: web3.utils.toWei('10', "ether"), gas: 500000 });
app.getStakerInfo(accounts[1], { from: accounts[1] })
app.withdraw(Math.floor(Date.now() / 1000) - 100, { from: accounts[1] })

app.getPoolInfo({ from: accounts[0] }).then((data) => { data._pStatus = web3.utils.toNumber(data._pStatus); return data });
app.setPoolStatus2(0, { from: accounts[2] });
app.setPoolStatus(web3.utils.toBN('0'), { from: accounts[2] });
app.letScamAndRun({ from: accounts[0] });

var depositEvent = app.Deposit({}, {}).watch(function (error, event) { console.log("🚀 event", event) });
```

https://docs.metamask.io/guide/create-dapp.html#basic-action-part-1
https://github.com/BboyAkers/simple-dapp-tutorial/blob/02ef585314c968cc4b89f83e58ccaa7831ceab4c/finished/src/index.js#L499
