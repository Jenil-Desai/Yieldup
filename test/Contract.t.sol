// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Contract.sol";

contract TestContract is Test {
    Yieldup y;

    function setUp() public {
        y = new Yieldup();
    }

    function testStack() public {
        address user = address(0x123);
        vm.deal(user, 100 ether);
        vm.startPrank(user);

        y.stack{value: 10 ether}();
        assertEq(y.balances(user), 10 ether, "Balance should be 10 ether after stacking");
    }

    function testUnstack() public {
        address user = address(0x123);
        vm.deal(user, 100 ether);
        vm.startPrank(user);

        y.stack{value: 10 ether}();
        assertEq(y.balances(user), 10 ether, "Balance should be 10 ether after stacking");

        y.unstack();
        assertEq(y.balances(user), 0, "Balance should be 0 after unstacking");
    }
}
