import React from 'react';
import logo from './logo.svg';
import './App.css';
import Web3 from 'web3';
// import StakePoolJson from `truffle/build/contracts/StakePool.json`
// import StakePoolJson from `${process.env.PUBLIC_URL}truffle/build/contracts/StakePool.json`

function App() {
  const getStakePoolJson= () => {
    return fetch('truffle/build/contracts/StakePool.json', {
      headers : { 
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
      .then(function(response){
        return response.json();
      })
  }
  async function main() {
    // const StakePoolJson = await import(`${process.env.PUBLIC_URL}/truffle/build/contracts/StakePool.json`);
    const StakePoolJson = await getStakePoolJson();
    const web3Provider = new Web3.providers.HttpProvider("http://localhost:7545");
    const web3 = new Web3(web3Provider);
    const contact = new web3.eth.Contract(StakePoolJson.abi as any, StakePoolJson.networks[5777].address as string);
    console.log("🚀 ~ file: App.tsx ~ line 26 ~ main ~ contact", contact)
    const myAddress = "0xE004C4343d085298ec5D0E8aBc443445c25b1D23";
  
    // const res = await contact.methods
    //   .sellArticle("ip 11", "dt cu", 6)
    //   .send({ from: myAddress, gas: 470000 });
    // console.log("🚀 ~ file: App.tsx ~ line 43 ~ main ~ res", res)
    // const article = await contact.methods.getArticle().call();
    // console.log("🚀 ~ file: App.tsx ~ line 44 ~ main ~ article", article)
  
  }
  
  React.useEffect(() => {
    main()
  }, [])

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.tsx</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
