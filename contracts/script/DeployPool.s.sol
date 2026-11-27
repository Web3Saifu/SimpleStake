// SPDX-License-Identifier: MIT
pragma solidity 0.8.39;

import {Script} from "forge-std/Script.sol";
import {MockERC20} from "../src/MockERC20.sol";
import {StakingPool} from "../src/StakingPool.sol";

contract DeployPool is Script {
    error LocalChainRequired(uint256 chainId);
    error InvalidStakingToken();

    function run(address token) external {
        if (block.chainid != 31337) revert LocalChainRequired(block.chainid);
        if (
            token.code.length == 0 || keccak256(bytes(MockERC20(token).name())) != keccak256("SimpleStake Token")
                || keccak256(bytes(MockERC20(token).symbol())) != keccak256("STK") || MockERC20(token).decimals() != 18
        ) revert InvalidStakingToken();

        vm.startBroadcast(msg.sender);
        new StakingPool(token);
        vm.stopBroadcast();
    }
}
