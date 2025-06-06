// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract Yieldup {
    mapping(address => uint256) private balances;
    uint256 private totalStaked;
    address private implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    fallback() external payable {
        address impl = implementation;
        require(impl != address(0), "No implementation set");
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
}
