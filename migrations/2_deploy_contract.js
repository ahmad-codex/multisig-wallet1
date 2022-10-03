const { web3 } = require("@openzeppelin/test-helpers/src/setup");

const Wallet = artifacts.require("Wallet");

//truffle uses Ganash behind the scene that will provide 10 testing accounts/addresses & network we deployed to
module.exports = async function (deployer, _network, accounts) {
  //deploy the smart contract
  await deployer.deploy(Wallet, [accounts[0], accounts[1], accounts[2]], 2);
  
  //need to send some ether to the smart contract and to do so we need a pointer 
  //pointer to the deployed smart contract
  const wallet = await Wallet.deployed();

  //use web3 js library to send some ether to the smart contract
  await web3.eth.sendTransaction({from: accounts[0], to: wallet.address, value: 1000});
};
