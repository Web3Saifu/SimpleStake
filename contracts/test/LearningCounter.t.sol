// SPDX-License-Identifier: MIT
pragma solidity 0.8.39;

import {Test} from "forge-std/Test.sol";
import {LearningCounter} from "./helpers/LearningCounter.sol";

contract LearningCounterTest is Test {
    LearningCounter private counter;
    address private alice;
    address private bob;

    function setUp() public {
        counter = new LearningCounter();
        alice = makeAddr("alice");
        bob = makeAddr("bob");
    }

    function test_NewAddressesStartAtZero() public view {
        assertEq(counter.counts(alice), 0);
        assertEq(counter.counts(bob), 0);
    }

    function test_RepeatedIncrementsPersistForCaller() public {
        vm.prank(alice);
        counter.increment();
        assertEq(counter.counts(alice), 1);

        vm.prank(alice);
        counter.increment();
        assertEq(counter.counts(alice), 2);
    }

    function test_CallerCountsStaySeparate() public {
        vm.prank(alice);
        counter.increment();
        vm.prank(bob);
        counter.increment();
        vm.prank(alice);
        counter.increment();

        assertEq(counter.counts(alice), 2);
        assertEq(counter.counts(bob), 1);
    }
}
