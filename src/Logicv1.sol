// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract Logicv1 {
    mapping(address => uint256) private balances;
    uint256 private totalStaked;

    function stack() public payable {
        require(msg.value > 0, "Deposit must be greater than 0");

        balances[msg.sender] += msg.value;
        totalStaked += msg.value;
    }

    function unstack(uint256 _amount) public {
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[msg.sender] >= _amount, "Insufficient balance to withdraw");

        balances[msg.sender] -= _amount;
        totalStaked -= _amount;

        (bool sent,) = payable(msg.sender).call{value: _amount}("");
        require(sent, "Transfer failed");
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
