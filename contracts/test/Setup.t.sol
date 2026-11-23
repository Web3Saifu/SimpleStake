// SPDX-License-Identifier: MIT
pragma solidity 0.8.39;

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {Test} from "forge-std/Test.sol";

contract SetupTest is Test {
    function test_FoundryCanUseBothPinnedLibraries() public pure {
        assertEq(Math.max(2, 5), 5);
    }
}
