// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract Yieldup {
    mapping(address => uint256) public balances;

    constructor() {}

    function stack() public payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    function unstack() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No balance to withdraw");
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(balance);
    }
}
