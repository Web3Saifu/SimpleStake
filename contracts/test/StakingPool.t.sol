// SPDX-License-Identifier: MIT
pragma solidity 0.8.39;

import {Test} from "forge-std/Test.sol";
import {MockERC20} from "../src/MockERC20.sol";
import {StakingPool} from "../src/StakingPool.sol";

contract StakingPoolTest is Test {
    MockERC20 internal token;
    StakingPool internal pool;
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");

    function setUp() public {
        token = new MockERC20("SimpleStake Token", "STK", address(this));
        pool = new StakingPool(address(token));
        token.mint(alice, 10 ether);
        token.mint(bob, 10 ether);
    }

    function test_PartialAndFullWithdrawal() public {
        deposit(alice, 5 ether);
        vm.startPrank(alice);
        pool.withdraw(2 ether);
        assertEq(pool.deposits(alice), 3 ether);
        assertEq(pool.totalDeposits(), 3 ether);
        assertEq(token.balanceOf(address(pool)), 3 ether);
        assertEq(token.balanceOf(alice), 7 ether);
        pool.withdraw(3 ether);
        vm.stopPrank();
        assertEq(pool.deposits(alice), 0);
        assertEq(pool.totalDeposits(), 0);
        assertEq(token.balanceOf(address(pool)), 0);
        assertEq(token.balanceOf(alice), 10 ether);
    }

    function test_DepositsAreIsolated() public {
        deposit(alice, 5 ether);
        vm.expectRevert(StakingPool.InsufficientDeposit.selector);
        vm.prank(bob);
        pool.withdraw(1 ether);
        deposit(bob, 2 ether);
        vm.prank(bob);
        pool.withdraw(1 ether);
        assertEq(pool.deposits(alice), 5 ether);
        assertEq(pool.deposits(bob), 1 ether);
        assertEq(pool.totalDeposits(), 6 ether);
        assertEq(token.balanceOf(address(pool)), 6 ether);
    }

    function test_RejectsZeroAmounts() public {
        vm.expectRevert(StakingPool.ZeroAmount.selector);
        pool.stake(0);
        vm.expectRevert(StakingPool.ZeroAmount.selector);
        pool.withdraw(0);
    }

    function test_RejectsWithdrawalAboveDeposit() public {
        deposit(alice, 1 ether);
        vm.expectRevert(StakingPool.InsufficientDeposit.selector);
        vm.prank(alice);
        pool.withdraw(2 ether);
        assertEq(pool.deposits(alice), 1 ether);
        assertEq(pool.totalDeposits(), 1 ether);
    }

    function test_InsufficientAllowanceLeavesAccountingIntact() public {
        deposit(alice, 1 ether);
        vm.expectRevert(
            abi.encodeWithSignature("ERC20InsufficientAllowance(address,uint256,uint256)", address(pool), 0, 2 ether)
        );
        vm.prank(alice);
        pool.stake(2 ether);
        assertEq(pool.deposits(alice), 1 ether);
        assertEq(pool.totalDeposits(), 1 ether);
        assertEq(token.balanceOf(address(pool)), 1 ether);
    }

    function test_DirectTransferDoesNotCreateDeposit() public {
        deposit(alice, 5 ether);
        vm.prank(bob);
        token.transfer(address(pool), 1 ether);
        vm.prank(alice);
        pool.withdraw(5 ether);
        assertEq(pool.deposits(bob), 0);
        assertEq(pool.totalDeposits(), 0);
        assertEq(token.balanceOf(address(pool)), 1 ether);
    }

    function test_RejectsMissingTokenCode() public {
        vm.expectRevert(StakingPool.InvalidToken.selector);
        new StakingPool(address(0));
    }

    function deposit(address user, uint256 amount) internal {
        vm.startPrank(user);
        token.approve(address(pool), amount);
        pool.stake(amount);
        vm.stopPrank();
    }
}
