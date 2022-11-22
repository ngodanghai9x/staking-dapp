## deploy on develop of truffle

```
truffle develop
truffle migrate --compile-all --reset
```

## deploy on ganache

```
truffle migrate --compile-all --reset --network ganache
truffle console --network ganache

accounts[1]
accounts[2]
StakePool.address
await web3.utils.fromWei(web3.utils.toBN(await web3.eth.getBalance(StakePool.address)), "ether")
await web3.utils.fromWei(web3.utils.toBN(await web3.eth.getBalance(accounts[0])), "ether")
await web3.utils.fromWei(web3.utils.toBN(await web3.eth.getBalance(accounts[1])), "ether")
await web3.utils.fromWei(web3.utils.toBN(await web3.eth.getBalance(accounts[2])), "ether")

let app = await StakePool.deployed()

app.deposit(Math.floor(Date.now() / 1000), 30, { from: accounts[1], value: web3.utils.toWei('10', "ether"), gas: 500000 })
app.getStakerInfo(accounts[1], { from: accounts[1] })
app.withdraw(Math.floor(Date.now() / 1000) - 100, { from: accounts[1] })

app.getPoolInfo({ from: accounts[0] }).then((data) => { data._pStatus = web3.utils.toNumber(data._pStatus); return data })
app.setPoolStatus(0, { from: accounts[2] })
app.letScamAndRun({ from: accounts[0] })

var depositEvent = app.Deposit({}, {}).watch(function (error, event) { console.log("🚀 event", event) })
```

https://docs.metamask.io/guide/create-dapp.html#basic-action-part-1
https://github.com/BboyAkers/simple-dapp-tutorial/blob/02ef585314c968cc4b89f83e58ccaa7831ceab4c/finished/src/index.js#L499
