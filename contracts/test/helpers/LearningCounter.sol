// SPDX-License-Identifier: MIT
pragma solidity 0.8.39;

contract LearningCounter {
    mapping(address => uint256) public counts;

    function increment() external {
        counts[msg.sender] += 1;
    }
}
