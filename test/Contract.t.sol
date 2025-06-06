// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Logicv1.sol";
import "src/Contract.sol";

contract TestContract is Test {
    Logicv1 logicv1;
    Yieldup proxy;

    address user = address(0x123);

    function setUp() public {
        logicv1 = new Logicv1();
        proxy = new Yieldup(address(logicv1));

        vm.deal(user, 100 ether);
    }

    function testStack() public {
        vm.startPrank(user);
        Logicv1 logic = Logicv1(address(proxy));

        logic.stack{value: 10 ether}();
        assertEq(logic.getBalance(), 10 ether, "Balance should be 10 ether after stacking");
    }

    function testUnstack() public {
        vm.startPrank(user);
        Logicv1 logic = Logicv1(address(proxy));

        logic.stack{value: 10 ether}();
        assertEq(logic.getBalance(), 10 ether, "Balance should be 10 ether after stacking");

        logic.unstack(5 ether);
        assertEq(logic.getBalance(), 5 ether, "Balance should be 0 after unstacking");
    }
}
