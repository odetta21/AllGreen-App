const GreenNFT = artifacts.require("./GreenNFT.sol");


module.exports = async function (deployer, _network, accounts) {
  const projectOwner = accounts[0]; // Assuming you want to set the projectOwner as the first account from Ganache
  const projectName = "GreenNFT";
  const projectSymbol = "GNFT";
  const tokenURI = "https://pin.ski/3JYNQ7v"; // This should be the URL including the IPFS hash of the metadata

  await deployer.deploy(GreenNFT, projectOwner, projectName, projectSymbol, tokenURI);
};
