pragma solidity ^0.5.0;

import "./DaiToken.sol";
import "./DappToken.sol";

contract TokenFarm {

    string public name = 'Dapp Token Farm';
    address public owner;
    DaiToken public daiToken;
    DappToken public dappToken;
    
    address[] stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked; 
    mapping(address => bool) public isStaking;
    

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }
    
    function stakeTokens(uint _amount) public {
        
        require(_amount > 0, "amount must be greater than 0");
        
        // transfer MOCK Dai to this contract
        daiToken.transferFrom(msg.sender, address(this), _amount);
        
        // update stakingBalance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;
        
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }
    
    function unStakeTokens() public {
        uint balance = stakingBalance[msg.sender];
        
        require(balance > 0, 'staking balance cannot be 0');
        
        daiToken.transfer(msg.sender, balance);
        
        stakingBalance[msg.sender] = 0;
        
        isStaking[msg.sender] = false;
    }
    
    // Issue tokens
    function issueTokens() public {
        
        require(msg.sender == owner, 'caller must be the owner');
    
        for (uint i = 0; i < stakers.length; i++) {
            address staker = stakers[i];
            if(stakingBalance[staker] > 0) {
                dappToken.transfer(staker, stakingBalance[staker]);
            }
        }
    }
}

