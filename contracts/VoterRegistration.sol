// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./GovernanceToken.sol";


/*
Contract: Voter Registration
Counters.Counter: voterIds
GovernanceToken: governanceToken
modifier: ensureNewVoter(input: voterId)
event: VoterRegistered(voterId, voter)
struct: Voter

*/

contract VoterRegistration {
    
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private voterIds;
    GovernanceToken public governanceToken;
    
    event VoterRegistered (
        address indexed voter,
        uint256 indexed balance
    );

    struct Voter {
        address voter;
        uint256 ID;
        uint256 biometric;
        bool registered;
    }
    
    // ID => Voters 
    mapping(uint256 => Voter) public voters;
    
    // Registered Voter address => bool
    mapping(address => uint256) public voterHashRegisteredByAddress;
    
    constructor(GovernanceToken _governanceToken){
        governanceToken = _governanceToken; // Governance Token ERC20 contract
    }

    //to count total registered voters
    function getRegisteredVoters() external view returns(uint256) {
        return voterIds.current();
    }
    
    /*
    any user who comes to the registration page will first be checked if the ID + biomentric SHA256 is already registered or not
    if no then the GT will be checked if they already own one
    if not then then their SHA256 ID + biometric, GT balance, and registered bool is stored against their voterID
    after successful voting, the event is emited and the new voterId is returned
    */
    function voterRegistration(
        address _voter,
        uint256 _ID,
        uint256 _biometric
        ) external returns(uint256 id)
    {
        require(voterHashRegisteredByAddress[msg.sender] != _ID , 'Already Registered');
        require(voters[_ID].biometric != _biometric, 'Already Registered');
        require(governanceToken.balanceOf(msg.sender) == 0, 'Already have a token, hence an eligible voter');//governance token function not written
        voterIds.increment();
        address holder = msg.sender;
        governanceToken.mint(holder);
        voters[_ID].voter = holder;
        voters[_ID].ID = _ID;
        voters[_ID].biometric = _biometric;
        voters[_ID].registered = true;
        voterHashRegisteredByAddress[holder] = _ID;
        id = _ID;
        emit VoterRegistered(_voter, governanceToken.balanceOf(holder));
        return id;
    }

    receive() external payable
    {
    }

}