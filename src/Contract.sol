// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "lib/IYT.sol";

contract Yieldup {
    struct UserInfo {
        uint256 stakedAmount;
        uint256 rewardDebt;
        uint256 lastUpdate;
    }

    uint8 public constant REWARD_PER_SEC_PER_ETH = 1;

    mapping(address => UserInfo) private userInfo;
    IYieldupToken private yieldupToken;
    uint256 private totalStaked;
    address private implementation;

    constructor(address _implementation, IYieldupToken _yieldupToken) {
        yieldupToken = _yieldupToken;
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
