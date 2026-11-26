// SPDX-License-Identifier: MIT
pragma solidity 0.8.39;

import {Script} from "forge-std/Script.sol";
import {MockERC20} from "../src/MockERC20.sol";

contract DeployTokens is Script {
    error LocalChainRequired(uint256 chainId);

    function run() external {
        if (block.chainid != 31337) revert LocalChainRequired(block.chainid);

        address owner = msg.sender;
        vm.startBroadcast(owner);
        new MockERC20("SimpleStake Token", "STK", owner);
        new MockERC20("SimpleStake Reward", "RWD", owner);
        vm.stopBroadcast();
    }
}
