// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Yieldup.sol";

contract TestYieldupToken is Test {
    YieldupToken yieldupToken;

    function setUp() public {
        yieldupToken = new YieldupToken();
    }

    function testInitialSupply() public {
        assertEq(yieldupToken.totalSupply(), 0, "Initial supply should be zero");
    }

    function testMint() public {
        address recipient = address(0x123);
        uint256 mintAmount = 18;

        yieldupToken.mint(recipient, mintAmount);

        assertEq(yieldupToken.balanceOf(recipient), mintAmount, "Recipient should have the minted amount");
        assertEq(yieldupToken.totalSupply(), mintAmount, "Total supply should equal the minted amount");
    }
}
