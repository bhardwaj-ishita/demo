// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract GovernanceToken is Context, ERC20 {
    
    using SafeMath for uint256;
    
    event GovernanceMinted (
        address indexed owner,
        uint256 indexed amount
    );
    
    event GovernanceBurned (
        address indexed owner,
        uint256 indexed amount
    );
    
    constructor(
        string memory name,
        string memory symbol
    ) ERC20(name, symbol) { }
    
    //mint when voter registered
    function mint(address holder) public payable
    {
        require(balanceOf(holder) == 0, 'Already registered');
        _mint(msg.sender, 1);
       emit GovernanceMinted(msg.sender, 1);
    }
    
    //burn when voter voted
    function burn(address holder) public virtual
    {
        require(balanceOf(holder) == 1, 'Already Voted');
        uint256 amount = balanceOf(holder);
        _burn(msg.sender, amount);
        emit GovernanceBurned(msg.sender, amount);
    }
}