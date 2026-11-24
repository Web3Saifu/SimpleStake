// SPDX-License-Identifier: MIT
pragma solidity 0.8.39;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import {Test} from "forge-std/Test.sol";
import {MockERC20} from "../src/MockERC20.sol";

contract MockERC20Test is Test {
    MockERC20 private stk;
    MockERC20 private rwd;
    address private tokenOwner;
    address private alice;
    address private bob;
    address private spender;

    function setUp() public {
        tokenOwner = makeAddr("tokenOwner");
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        spender = makeAddr("spender");
        stk = new MockERC20("SimpleStake Token", "STK", tokenOwner);
        rwd = new MockERC20("SimpleStake Reward", "RWD", tokenOwner);
    }

    function test_MetadataOwnerAndInitialSupply() public view {
        assertNotEq(address(stk), address(rwd));
        assertEq(stk.name(), "SimpleStake Token");
        assertEq(stk.symbol(), "STK");
        assertEq(rwd.name(), "SimpleStake Reward");
        assertEq(rwd.symbol(), "RWD");
        assertEq(stk.decimals(), 18);
        assertEq(rwd.decimals(), 18);
        assertEq(stk.owner(), tokenOwner);
        assertEq(rwd.owner(), tokenOwner);
        assertEq(stk.totalSupply(), 0);
        assertEq(rwd.totalSupply(), 0);
    }

    function test_OwnerMintIncreasesBalanceAndSupply() public {
        vm.prank(tokenOwner);
        stk.mint(alice, 10 ether);

        assertEq(stk.balanceOf(alice), 10 ether);
        assertEq(stk.totalSupply(), 10 ether);
    }

    function test_NonOwnerCannotMint() public {
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, alice));
        stk.mint(alice, 1 ether);
    }

    function test_TokenInstancesKeepBalancesAllowancesAndSupplySeparate() public {
        vm.prank(tokenOwner);
        stk.mint(alice, 10 ether);
        vm.prank(tokenOwner);
        rwd.mint(alice, 3 ether);
        vm.prank(alice);
        stk.approve(spender, 4 ether);

        assertEq(stk.balanceOf(alice), 10 ether);
        assertEq(rwd.balanceOf(alice), 3 ether);
        assertEq(stk.totalSupply(), 10 ether);
        assertEq(rwd.totalSupply(), 3 ether);
        assertEq(stk.allowance(alice, spender), 4 ether);
        assertEq(rwd.allowance(alice, spender), 0);
    }

    function test_TransferMovesBalanceAndPreservesSupply() public {
        vm.prank(tokenOwner);
        stk.mint(alice, 10 ether);

        vm.prank(alice);
        assertTrue(stk.transfer(bob, 3 ether));

        assertEq(stk.balanceOf(alice), 7 ether);
        assertEq(stk.balanceOf(bob), 3 ether);
        assertEq(stk.totalSupply(), 10 ether);
    }

    function test_TransferFromUsesAllowanceAndMovesBalance() public {
        vm.prank(tokenOwner);
        stk.mint(alice, 10 ether);

        vm.prank(alice);
        assertTrue(stk.approve(spender, 4 ether));
        assertEq(stk.allowance(alice, spender), 4 ether);
        assertEq(stk.balanceOf(alice), 10 ether);
        assertEq(stk.balanceOf(bob), 0);

        vm.prank(spender);
        assertTrue(stk.transferFrom(alice, bob, 3 ether));

        assertEq(stk.allowance(alice, spender), 1 ether);
        assertEq(stk.balanceOf(alice), 7 ether);
        assertEq(stk.balanceOf(bob), 3 ether);
        assertEq(stk.totalSupply(), 10 ether);
    }

    function test_TransferFromRevertsAboveAllowance() public {
        vm.prank(tokenOwner);
        stk.mint(alice, 10 ether);
        vm.prank(alice);
        stk.approve(spender, 4 ether);

        vm.prank(spender);
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Errors.ERC20InsufficientAllowance.selector, spender, 4 ether, 5 ether)
        );
        // The expected revert is checked above, so this call has no success value to assert.
        // forge-lint: disable-next-line(erc20-unchecked-transfer)
        stk.transferFrom(alice, bob, 5 ether);

        assertEq(stk.allowance(alice, spender), 4 ether);
        assertEq(stk.balanceOf(alice), 10 ether);
        assertEq(stk.balanceOf(bob), 0);
    }
}
