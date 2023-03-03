// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./GovernanceToken.sol";

/*
what do we want?
input: merkle Root after the merkle tree is built
    the biometric + ID hash (if possible)

*/
contract VoterVerification {

    GovernanceToken public governanceToken;

    constructor(GovernanceToken _governanceToken){
        governanceToken = _governanceToken; // Governance Token ERC20 contract
    }

    //ID => bool
    mapping (bytes32 => bool) public voterVerified;
    
    function voterVerification(bytes32 _biometric, bytes32 _ID, bytes32 merkleRoot) public returns(bool) 
    {
        bytes32 voterHash = _ID;
        require(!voterVerified[_ID], 'Voter is already verified');
        require(governanceToken.balanceOf(msg.sender) == 1, 'Already Voted');//can put this in the voting contract instead
        bytes32 leaf = keccak256(abi.encodePacked(voterHash));
        require(MerkleProof.verify(voterHash, merkleRoot, leaf), 'Invalid Voter');
        voterVerified[voterHash] = true;
        return true;
    }

}