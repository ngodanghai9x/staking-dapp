import React from "react";
import Web3 from "web3";
import { Contract } from "web3-eth-contract";

const AppContext = React.createContext<{
  web3: Web3 | null;
  poolContract: Contract | null;
  tokenContract: Contract | null;
  account: string;
  tokenName: string;
  tokenSymbol: string;
}>({
  web3: null,
  poolContract: null,
  tokenContract: null,
  account: "0x0",
  tokenName: "",
  tokenSymbol: "",
});

export const AppProvider = (props: { children: React.ReactNode }) => {
  const [web3, setWeb3] = React.useState<Web3 | null>(null);
  const [poolContract, setPoolContract] = React.useState<Contract | null>(null);
  const [tokenContract, setTokenContract] = React.useState<Contract | null>(
    null
  );
  const [account, setAccount] = React.useState<string>("");
  const [tokenName, setTokenName] = React.useState<string>("");
  const [tokenSymbol, setTokenSymbol] = React.useState<string>("");

  const initWeb3State = React.useCallback(async () => {
    const getFileJson = (path: string) => {
      return fetch(path, {
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
        },
      }).then(function(response) {
        return response.json();
      });
    };
    const isMetaMaskInstalled = () => {
      //Have to check the ethereum binding on the window object to see if it's installed
      const { ethereum } = window as any;
      return Boolean(ethereum && ethereum.isMetaMask);
    };
    let { ethereum, web3 } = window as any;

    const StakePoolJson = await getFileJson(
      "truffle/build/contracts/StakePool.json"
    );
    const BitcoinJson = await getFileJson(
      "truffle/build/contracts/Bitcoin.json"
    );

    const needLocalContract = true;
    const web3Provider =
      web3 && !needLocalContract
        ? web3.currentProvider
        : new Web3.providers.HttpProvider("http://localhost:7545");
    web3 = new Web3(web3Provider);

    if (!isMetaMaskInstalled()) return;
    const accounts = await ethereum.request({
      method: "eth_requestAccounts",
    });
    const account = accounts[0];
    setAccount(account);
    ethereum.autoRefreshOnNetworkChange = false;
    // getNetworkAndChainId();

    // ethereum.on("chainChanged", handleNewChain);
    // ethereum.on("networkChanged", handleNewNetwork);
    // ethereum.on("accountsChanged", (accounts) =>
    //   App.displayAccountInfo(accounts[0])
    // );
    const poolContract: Contract = new web3.eth.Contract(
      StakePoolJson.abi as any,
      StakePoolJson.networks[5777].address as string,
      { from: account, gas: 500000 }
    );
    const tokenContract: Contract = new web3.eth.Contract(
      BitcoinJson.abi as any,
      BitcoinJson.networks[5777].address as string,
      { from: account, gas: 500000 }
    );

    tokenContract.methods
      .name()
      .call()
      .then(setTokenName);
    tokenContract.methods
      .symbol()
      .call()
      .then(setTokenSymbol);

    setWeb3(web3);
    setPoolContract(poolContract);
    setTokenContract(tokenContract);

    // return web3;
    // TODO: separate func which need updated by account
  }, [account]);

  React.useEffect(() => {
    initWeb3State();
  }, [initWeb3State]);

  const { children } = props;

  return (
    <AppContext.Provider
      value={{
        web3,
        account,
        tokenContract,
        poolContract,
        tokenName,
        tokenSymbol,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export default AppContext;
