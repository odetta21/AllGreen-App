const GreenNFTMarketPlace = artifacts.require("./GreenNFTMarketPlace.sol");
const GreenNFTData = artifacts.require("./GreenNFTData.sol");
const AllGreenCoin = artifacts.require("./AllGreenCoin.sol");
const GreenNFT = artifacts.require("./GreenNFT.sol");

const _greenNFTData = GreenNFTData.address;
const _AllGreenCoin = AllGreenCoin.address;

module.exports = async function(deployer, _network, accounts) {
    await deployer.deploy(GreenNFTMarketPlace, _greenNFTData, _AllGreenCoin);
};