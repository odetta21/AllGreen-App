// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/**
 * @notice - This is the NFT contract for a green
 */
contract GreenNFT is ERC721URIStorage {
    using SafeMath for uint256;

    uint256 public currentTokenId;
    
    constructor(
        address _projectOwner,  /// Initial owner (Seller)
        string memory _projectName, 
        string memory _projectSymbol,
        string memory _tokenURI    /// [Note]: TokenURI is URL include ipfs hash
        //uint greenNFTPrice
    ) 
        
        ERC721(_projectName, _projectSymbol) 
    {
        mint(_projectOwner, _tokenURI);
    }

    /** 
     * @dev mint a GreenNFT
     * @dev tokenURI - URL include ipfs hash
     */
    function mint(address to, string memory tokenURI) public returns (bool) {
        /// Mint a new GreenNFT
        uint newTokenId = getNextTokenId();
        currentTokenId++;
        _mint(to, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        return true;
    }


    ///--------------------------------------
    /// Getter methods
    ///--------------------------------------


    ///--------------------------------------
    /// Private methods
    ///--------------------------------------
    function getNextTokenId() private view returns (uint _nextTokenId) {
        return currentTokenId.add(1);
    }

    
    

}



