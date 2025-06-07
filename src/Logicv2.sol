// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "lib/IYT.sol";

contract Logicv2 {
    struct UserInfo {
        uint256 stakedAmount;
        uint256 rewardDebt;
        uint256 lastUpdate;
    }

    uint8 public constant REWARD_PER_SEC_PER_ETH = 1;

    mapping(address => UserInfo) private userInfo;
    IYieldupToken private yieldupToken;
    uint256 private totalStaked;

    function _updateRewards(address _user) internal {
        UserInfo storage user = userInfo[_user];

        if (user.lastUpdate == 0) {
            user.lastUpdate = block.timestamp;
            return;
        }

        uint256 timeDiff = block.timestamp - user.lastUpdate;
        if (timeDiff == 0) {
            return;
        }

        uint256 additionalReward = (user.stakedAmount * timeDiff * REWARD_PER_SEC_PER_ETH);

        user.rewardDebt += additionalReward;
        user.lastUpdate = block.timestamp;
    }

    function stack() public payable {
        require(msg.value > 0, "Deposit must be greater than 0");

        _updateRewards(msg.sender);

        userInfo[msg.sender].stakedAmount += msg.value;
        totalStaked += msg.value;
    }

    function unstack(uint256 _amount) public {
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(userInfo[msg.sender].stakedAmount >= _amount, "Insufficient balance to withdraw");

        _updateRewards(msg.sender);
        userInfo[msg.sender].stakedAmount -= _amount;
        totalStaked -= _amount;

        (bool sent,) = payable(msg.sender).call{value: _amount}("");
        require(sent, "Transfer failed");
    }

    function claimRewards() public {
        _updateRewards(msg.sender);
        UserInfo storage user = userInfo[msg.sender];
        yieldupToken.mint(msg.sender, user.rewardDebt);
        user.rewardDebt = 0;
    }

    function getRewards() public view returns (uint256) {
        uint256 timeDiff = block.timestamp - userInfo[msg.sender].lastUpdate;
        if (timeDiff == 0) {
            return userInfo[msg.sender].rewardDebt;
        }

        return (userInfo[msg.sender].stakedAmount * timeDiff * REWARD_PER_SEC_PER_ETH) + userInfo[msg.sender].rewardDebt;
    }

    function getBalance() public view returns (uint256) {
        return userInfo[msg.sender].stakedAmount;
    }

    function getTotalStaked() public view returns (uint256) {
        return totalStaked;
    }
}
