const GreenNFTTradable = artifacts.require("./GreenNFTTradable.sol");

module.exports = async function(deployer, _network, accounts) {

const AllGreenCoin= accounts[0];

    await deployer.deploy(GreenNFTTradable, AllGreenCoin);
};