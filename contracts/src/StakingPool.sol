// SPDX-License-Identifier: MIT
pragma solidity 0.8.39;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @notice Holds standard STK deposits and returns principal to its depositor.
contract StakingPool is ReentrancyGuard {
    using SafeERC20 for IERC20;

    error InvalidToken();
    error ZeroAmount();
    error InsufficientDeposit();

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    IERC20 public immutable stakingToken;
    mapping(address user => uint256 amount) public deposits;
    uint256 public totalDeposits;

    constructor(address token) {
        if (token.code.length == 0) revert InvalidToken();
        stakingToken = IERC20(token);
    }

    function stake(uint256 amount) external nonReentrant {
        if (amount == 0) revert ZeroAmount();

        deposits[msg.sender] += amount;
        totalDeposits += amount;
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) external nonReentrant {
        if (amount == 0) revert ZeroAmount();
        uint256 deposited = deposits[msg.sender];
        if (amount > deposited) revert InsufficientDeposit();

        deposits[msg.sender] = deposited - amount;
        totalDeposits -= amount;
        stakingToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }
}
