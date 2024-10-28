// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { GreenNFT } from "../GreenNFT.sol";


contract GreenNFTFactoryCommons {

    ///---------------------------
    /// Storages
    ///---------------------------


    ///---------------------------
    /// Objects
    ///---------------------------


    ///---------------------------
    /// Events
    ///---------------------------
    event ClaimAudited (
        uint projectId, 
        uint claimId,
        uint co2Reductions, 
        string referenceDocument
    );

    event GreenNFTCreated (
        uint projectId, 
        uint claimId,
        GreenNFT greenNFT,
        uint carbonCredits
    );

}
