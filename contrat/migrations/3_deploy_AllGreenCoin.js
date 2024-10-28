const AllGreenCoin = artifacts.require("./AllGreenCoin.sol");

module.exports = async function(deployer, _network, accounts) {
    await deployer.deploy(AllGreenCoin);
};