const GreenNFTFactory = artifacts.require("./GreenNFTFactory.sol");
const GreenNFTMarketPlace = artifacts.require("./GreenNFTMarketPlace.sol");
const GreenNFTData = artifacts.require("./GreenNFTData.sol");
const AllGreenCoin = artifacts.require("./AllGreenCoin.sol");

const _greenNFTMarketPlace = GreenNFTMarketPlace.address;
const _greenNFTData = GreenNFTData.address;
const _AllGreenCoin = AllGreenCoin.address;

module.exports = async function(deployer, _network, accounts) {
    await deployer.deploy(GreenNFTFactory, _greenNFTMarketPlace, _greenNFTData, _AllGreenCoin)

    /// Transfer 1000000 CCT (AllGreenCoin) into the GreenNFTFactory contract
    const deployerAddress = accounts[0]
    console.log('=== deployerAddress ===', deployerAddress)

    const greenNFTFactory = await GreenNFTFactory.deployed()
    const AllGreenCoin = await AllGreenCoin.deployed()

    const amount = web3.utils.toWei("1000000")  /// 1000000 CCT (AllGreenCoin)
    await AllGreenCoin.transfer(greenNFTFactory.address, amount, { from: deployerAddress })

    let CCTBalance = await AllGreenCoin.balanceOf(greenNFTFactory.address)
    console.log('=== CCT (AllGreenCoin) balance of the GreenNFTFactory contract ===', String(CCTBalance))
}