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

contract GreenNFTFactory2 is Ownable {
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

     event ClaimAudited(uint256 _projectId, uint256 claimId, uint256 _co2Reductions, string _referenceDocument);
    function auditClaim(uint claimId, string memory auditedReport) public onlyAuditor returns (bool) {
        address auditor;
        address[] memory auditors = greenNFTData.getAuditors();
        for (uint i=0; i < auditors.length; i++) {
            if (msg.sender == greenNFTData.getAuditor(i)) {
                auditor = greenNFTData.getAuditor(i);
            }
        }
        require (msg.sender == auditor, "Caller must be an auditor");

        GreenNFTData.Claim memory claim = greenNFTData.getClaim(claimId);
        uint _projectId = claim.projectId;
        uint _co2Reductions = claim.co2Reductions;
        string memory _referenceDocument = claim.referenceDocument;
        emit ClaimAudited(_projectId, claimId, _co2Reductions, _referenceDocument);

        /// Create a new GreenNFT
        _createNewGreenNFT(_projectId, claimId, _co2Reductions, auditedReport);

        return true;
    }

     /**
     * @notice - Create a new GreenNFT
     */

 event GreenNFTCreated(uint256 projectId, uint256 claimId, GreenNFT greenNFT, uint256 carbonCredits);

    function _createNewGreenNFT(
        uint256 projectId, 
        uint256 claimId,
        uint256 co2Reductions,
        string memory auditedReport
    ) internal returns (bool) {
        GreenNFTData.Project memory project = greenNFTData.getProject(projectId);
        address _projectOwner = project.projectOwner;
        string memory _projectName = project.projectName;
        string memory projectSymbol = "GREEN_NFT";            // [Note]: All NFT's symbol are common symbol
        string memory tokenURI = getTokenURI(auditedReport);  // [Note]: IPFS hash + URL

        GreenNFT greenNFT = new GreenNFT(_projectOwner, _projectName, projectSymbol, tokenURI);

        // Calculate carbon credits
        uint256 carbonCredits = co2Reductions;

        emit GreenNFTCreated(projectId, claimId, greenNFT, carbonCredits);

        /// The AllGreenCoins that is equal amount to given-carbonCredits are transferred into the wallet of project owner
        /// [Note]: This contract should has some the AllGreenCoins balance. 
        allGreenCoin.transfer(_projectOwner, carbonCredits); 

        return true;       
    }


     ///-----------------
    /// Getter methods
    ///-----------------
    function baseTokenURI() public pure returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function getTokenURI(string memory _auditedReport) public view returns (string memory) {
        return Strings.strConcat(baseTokenURI(), _auditedReport);  /// IPFS hash of audited-report + base token URI
    }

}