// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

pragma experimental ABIEncoderV2;

import { GreenNFT } from "./GreenNFT.sol";
import { GreenNFTData } from "./GreenNFTData.sol";
import { AllGreenCoin } from "./AllGreenCoin.sol";

/// [Note]: For calling enum
import { GreenNFTDataCommons } from "./commons/GreenNFTDataCommons.sol";


/**
 * @title - GreenNFTTradable contract
 * @notice - This contract has role that switch open/cancel to put on sale of carbon credits
 */
contract GreenNFTTradable {
    AllGreenCoin private allGreenCoin;  /// [Note]: The reason why I use "private" is to avoid an error of "Overriding public state variable"

    constructor(AllGreenCoin _allGreenCoin) {
        allGreenCoin = _allGreenCoin;        
    }

    /**
     * @notice - Open to put on sale of carbon credits.
     * @notice - Caller is a projectOwner (Seller)
     */
    function openToPutOnSale(GreenNFTData _greenNFTData, GreenNFT greenNFT) public {
        GreenNFTData greenNFTData = _greenNFTData;
        
        /// Update status
        greenNFTData.updateStatus(greenNFT, GreenNFTDataCommons.GreenNFTStatus.Sale);

        /// Get amount of carbon credits
        GreenNFTDataCommons.GreenNFTEmissonData memory greenNFTEmissonData = greenNFTData.getGreenNFTEmissonDataByNFTAddress(greenNFT);
        uint _carbonCredits = greenNFTEmissonData.carbonCredits;

        /// AllGreenCoins are locked on this smart contract
        address projectOwner = msg.sender;
        allGreenCoin.transferFrom(projectOwner, address(this), _carbonCredits);
    }

    /**
     * @notice - Cancel to put on sale of carbon credits.
     * @notice - Caller is a seller
     */
    function cancelToPutOnSale(GreenNFTData _greenNFTData, GreenNFT greenNFT) public {
        GreenNFTData greenNFTData = _greenNFTData;

        /// Update status
        greenNFTData.updateStatus(greenNFT, GreenNFTDataCommons.GreenNFTStatus.NotSale);

        /// Get amount of carbon credits
        GreenNFTDataCommons.GreenNFTEmissonData memory greenNFTEmissonData = greenNFTData.getGreenNFTEmissonDataByNFTAddress(greenNFT);
        uint _carbonCredits = greenNFTEmissonData.carbonCredits;

        /// AllGreenCoins locked are relesed from this smart contract and transferred into a projectOwner (seller) 
        address projectOwner = msg.sender;
        allGreenCoin.transfer(projectOwner, _carbonCredits);
    }

}
