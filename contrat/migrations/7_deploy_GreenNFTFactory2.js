const GreenNFTFactory2 = artifacts.require("./GreenNFTFactory2.sol");
const GreenNFTMarketPlace = artifacts.require("./GreenNFTMarketPlace.sol");
const GreenNFTData = artifacts.require("./GreenNFTData.sol");
const AllGreenCoin = artifacts.require("./AllGreenCoin.sol");

const _greenNFTMarketPlace = GreenNFTMarketPlace.address;
const _greenNFTData = GreenNFTData.address;
const _AllGreenCoin = AllGreenCoin.address;

module.exports = async function(deployer, _network, accounts) {
    await deployer.deploy(GreenNFTFactory2, _greenNFTMarketPlace, _greenNFTData, _AllGreenCoin)

    /// Transfer 1000000 CCT (AllGreenCoin) into the GreenNFTFactory contract
    const deployerAddress = accounts[0]
    console.log('=== deployerAddress ===', deployerAddress)

    const greenNFTFactory2 = await GreenNFTFactory2.deployed()
    const AllGreenCoin = await AllGreenCoin.deployed()

    const amount = web3.utils.toWei("1000000")  /// 1000000 CCT (AllGreenCoin)
    await AllGreenCoin.transfer(greenNFTFactory2.address, amount, { from: deployerAddress })

    let CCTBalance = await AllGreenCoin.balanceOf(greenNFTFactory2.address)
    console.log('=== CCT (AllGreenCoin) balance of the GreenNFTFactory2 contract ===', String(CCTBalance))
}