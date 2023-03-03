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

    //voting hash => bool
    mapping (uint256 => bool) public voterVerified;
    
    function voterVerification(bytes32 calldata _biometric, bytes32 calldata _ID, bytes32 merkleRoot) public 
    {
        uint256 voterHAsh = sha256(_biometric + _ID);
        require(!voterVerified[msg.sender], 'Voter is already verified');
        require(governanceToken.checkBal(msg.sender) == 1, 'Already Voted');//can put this in the voting contract instead
        bytes32 leaf = keccak256(abi.encodePacked(voterHAsh));
        require(MerkleProof.verify(voterHash, merkleRoot, leaf), 'Invalid Voter');
        voterVerified[voterHAsh] = true;
        return true;
    }

}