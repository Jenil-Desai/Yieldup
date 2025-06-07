// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Logicv2.sol";
import "src/YieldupToken.sol";
import "src/Contract.sol";

import "lib/IYT.sol";

contract TestContract is Test {
    YieldupToken yieldupToken;
    Logicv2 logicv2;
    Yieldup proxy;

    address user = address(0x123);

    function setUp() public {
        yieldupToken = new YieldupToken();
        logicv2 = new Logicv2();
        proxy = new Yieldup(address(logicv2), IYieldupToken(address(yieldupToken)));

        vm.deal(user, 100 ether);
    }

    function testStack() public {
        vm.startPrank(user);
        Logicv2 logic = Logicv2(address(proxy));

        logic.stack{value: 10 ether}();
        assertEq(logic.getBalance(), 10 ether, "Balance should be 10 ether after stacking");
    }

    function testUnstack() public {
        vm.startPrank(user);
        Logicv2 logic = Logicv2(address(proxy));

        logic.stack{value: 10 ether}();
        assertEq(logic.getBalance(), 10 ether, "Balance should be 10 ether after stacking");

        logic.unstack(5 ether);
        assertEq(logic.getBalance(), 5 ether, "Balance should be 0 after unstacking");
    }
}
