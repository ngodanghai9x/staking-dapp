import React from "react";
import Web3 from "web3";

const AppContext = React.createContext<{
  web3: Web3 | null;
  account: string;
  poolContract: any;
  tokenContract: any;
}>({
  web3: null,
  account: "0x0",
  poolContract: null,
  tokenContract: null,
});

export const AppProvider = (props: { children: React.ReactNode }) => {
  const [web3, setWeb3] = React.useState<Web3 | null>(null);
  const [poolContract, setPoolContract] = React.useState<any | null>(null);
  const [tokenContract, setTokenContract] = React.useState<any | null>(null);
  const [account, setAccount] = React.useState<string>("");

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

    const StakePoolJson = await getFileJson(
      "truffle/build/contracts/StakePool.json"
    );
    const BitcoinJson = await getFileJson(
      "truffle/build/contracts/Bitcoin.json"
    );

    let { ethereum, web3 } = window as any;
    const web3Provider = web3
      ? web3.currentProvider
      : new Web3.providers.HttpProvider("http://localhost:7545");
    web3 = new Web3(web3Provider);

    if (isMetaMaskInstalled()) {
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
    }
    const poolContract = new web3.eth.Contract(
      StakePoolJson.abi as any,
      StakePoolJson.networks[5777].address as string
    );
    const tokenContract = new web3.eth.Contract(
      BitcoinJson.abi as any,
      BitcoinJson.networks[5777].address as string
    );

    setWeb3(web3);
    setPoolContract(poolContract);
    setTokenContract(tokenContract);
    // return web3;
  }, []);

  React.useEffect(() => {
    initWeb3State();
  }, []);

  const { children } = props;

  return (
    <AppContext.Provider
      value={{
        web3,
        account,
        tokenContract,
        poolContract,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export default AppContext;
