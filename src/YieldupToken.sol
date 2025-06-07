// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YieldupToken is ERC20, Ownable {
    constructor() ERC20("Yieldup", "YLD") Ownable(msg.sender) {}

    function mint(address _to, uint256 _amount) public onlyOwner {
        require(_to != address(0), "Cannot mint to the zero address");
        require(_amount > 0, "Mint amount must be greater than 0");
        _mint(_to, _amount);
    }
}
