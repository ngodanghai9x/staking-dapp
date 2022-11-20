## deploy on ganache

```
truffle migrate --compile-all --reset --network ganache
truffle console --network ganache

accounts[1]
accounts[2]
StakePool.address
await web3.utils.fromWei(web3.utils.toBN(await web3.eth.getBalance(accounts[1])), "ether")
await web3.utils.fromWei(web3.utils.toBN(await web3.eth.getBalance(accounts[2])), "ether")

let app = await StakePool.deployed()
app.getArticle()

app.sellArticle("ip 11", "dt cu", 6, {from: accounts[1]})
app.buyArticle({ from: accounts[1], value: 6, gas: 500000 })

app.sellArticle("ip 11", "dt cu", web3.utils.toWei('6', "ether"), {from: accounts[2]})
app.buyArticle({ from: accounts[1], value: web3.utils.toWei('6', "ether"), gas: 500000 })
app.sellArticle("ip 11", "dt cu", 6, {from: accounts[1]})
var logEvent = app.LogSellArticle({}, {}).watch(function (error, event) { console.log("🚀 event", event) })
```
https://docs.metamask.io/guide/create-dapp.html#basic-action-part-1
https://github.com/BboyAkers/simple-dapp-tutorial/blob/02ef585314c968cc4b89f83e58ccaa7831ceab4c/finished/src/index.js#L499