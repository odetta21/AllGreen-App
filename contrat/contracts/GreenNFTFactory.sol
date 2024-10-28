// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts/access/Ownable.sol";

//import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";

import { Strings } from "./libraries/Strings.sol";

import { GreenNFT } from "./GreenNFT.sol";
import { GreenNFTMarketPlace } from "./GreenNFTMarketPlace.sol";
import { GreenNFTData } from "./GreenNFTData.sol";
import { AllGreenCoin } from "./AllGreenCoin.sol";


/**
 * @notice - This is the factory contract for a NFT of green
 */
contract GreenNFTFactory is Ownable {
    using SafeMath for uint256;
    using Strings for string;

    address GREEN_NFT_MARKETPLACE;

    mapping(address => bool) public isAuditor;

    GreenNFTMarketPlace public greenNFTMarketPlace;
    GreenNFTData public greenNFTData;
    AllGreenCoin public allGreenCoin;

    constructor(
        GreenNFTMarketPlace _greenNFTMarketPlace, 
        GreenNFTData _greenNFTData, 
        AllGreenCoin _allGreenCoin
    ) public {
        greenNFTMarketPlace = _greenNFTMarketPlace;
        greenNFTData = _greenNFTData;
        allGreenCoin = _allGreenCoin;

        GREEN_NFT_MARKETPLACE = address(greenNFTMarketPlace);
    }

    /**
     * @notice - Throws if called by account without auditors
     */
    modifier onlyAuditor() {
        address auditor;
        
        address[] memory auditors = greenNFTData.getAuditors();
        for (uint i=0; i < auditors.length; i++) {
            auditor = auditors[i];
        }

        require(isAuditor[msg.sender], "Caller should be an auditor");
        //require(msg.sender == auditor, "Caller should be the auditor");
        _;
    }

    /**
     * @notice - Register a auditor 
     
    function registerAuditor(address auditor) public returns (bool) {
    //function registerAuditor(address auditor) public onlyOwner returns (bool) {
        /// [Note]: Caller should be onlyOwner. But it is commentouted temporary.
        greenNFTData.addAuditor(auditor);
    }

    */
    
    function registerAuditor(address auditor) public onlyOwner returns (bool) {
        isAuditor[auditor] = true;
        greenNFTData.addAuditor(auditor);

        return true;
    }


    /**
     * @notice - Register a project
     */
    function registerProject(string memory projectName, uint co2Emissions) public returns (bool) {
        address projectOwner = msg.sender;
        greenNFTData.saveProject(projectOwner, projectName, co2Emissions);

        return true;
    }

    /**
     * @notice - A project owner claim CO2 reductions
     */
    function claimCO2Reductions(uint projectId, uint co2Reductions, uint startOfPeriod, uint endOfPeriod, string memory referenceDocument) public returns (bool) {
        /// Check whether a caller is a project owner or not
        GreenNFTData.Project memory project = greenNFTData.getProject(projectId);
        address _projectOwner = project.projectOwner;
        require (msg.sender == _projectOwner, "Caller must be a project owner");
        
        greenNFTData.saveClaim(projectId, co2Reductions, startOfPeriod, endOfPeriod, referenceDocument);

        return true;
    }

    /**
     * @notice - An auditor audit a CO2 reduction claim
     * @notice - Only auditor can audit
     */

     

   

    
    /** 
     * @notice - Save a GreenNFT data
     */
    function saveGreenNFTData(
        uint claimId,
        GreenNFT greenNFT,
        address auditor,
        uint carbonCredits,
        string memory auditedReport
    ) public returns (bool) {
        GreenNFTData.Claim memory claim = greenNFTData.getClaim(claimId);
        uint _projectId = claim.projectId;
        uint _startOfPeriod = claim.startOfPeriod;
        uint _endOfPeriod = claim.endOfPeriod;
        uint _co2Reductions = claim.co2Reductions;

        GreenNFTData.Project memory project = greenNFTData.getProject(_projectId);

        /// [Note]: Use a project instance as it is. (Do not assign another variable in order to avoid "stack too deep")
        _saveGreenNFTMetadata(_projectId, claimId, greenNFT, project.projectOwner, auditor, _startOfPeriod, _endOfPeriod, auditedReport);
        _saveGreenNFTEmissonData(project.co2Emissions, _co2Reductions, carbonCredits);

        return true;
    }

    function _saveGreenNFTMetadata(
        uint projectId,
        uint claimId,
        GreenNFT greenNFT,
        address _projectOwner,
        address auditor,
        uint startOfPeriod, 
        uint endOfPeriod,
        string memory auditedReport
    ) public returns (bool) {
        /// Save metadata of a GreenNFT created
        greenNFTData.saveGreenNFTMetadata(projectId, claimId, greenNFT, _projectOwner, auditor, startOfPeriod, endOfPeriod, auditedReport);

        return true;
    }

    function _saveGreenNFTEmissonData(
        // uint startOfPeriod, 
        // uint endOfPeriod,
        uint co2Emissions, 
        uint co2Reductions, 
        uint carbonCredits
    ) public returns (bool) {
        /// Save emission data of a GreenNFT created
        greenNFTData.saveGreenNFTEmissonData(co2Emissions, co2Reductions, carbonCredits);

        return true;
    }


   

}
