import React, { useContext, useEffect } from "react";
import { useState } from "react";
import AppContext from "../contexts/AppContext";

const HomePage = () => {
  const {
    account,
    poolContract,
    tokenContract,
    web3,
    tokenName,
    tokenSymbol,
  } = useContext(AppContext);
  const [balance, setBalance] = useState(0);

  useEffect(() => {
    if (!poolContract || !tokenContract) return;
    tokenContract.methods
      .balanceOf(account)
      .call()
      .then(setBalance);
  }, [poolContract, tokenContract]);

  return (
    <React.Fragment>
      <p>account {account}</p>
      <p>token {tokenName}</p>
      <p>
        balance {balance} {tokenSymbol}
      </p>
      <button
        onClick={() => {
          if (!poolContract || !tokenContract) return;
          const amount = 10000;

          tokenContract.methods
            .approve(poolContract.options.address, amount)
            .send()
            .then((data: unknown) => {
              console.log("🚀 ~ file: Home.tsx ~ line 30 ~ .then ~ data", data);
              poolContract.methods
                .deposit(amount, Math.floor(Date.now() / 1000), 30)
                .send()
                .then(console.log);
            });
        }}
      >
        Deposit
      </button>
    </React.Fragment>
  );
};

export default HomePage;
