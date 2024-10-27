// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2} from "forge-std/Test.sol";
import {PyPouchFactory} from "src/PyPouchFactory.sol";
import {PyPouch} from "src/PyPouch.sol";
import {MockERC20Token} from "test/mocks/MockERC20Token.sol";
import {MockAavePool} from "test/mocks/MockAavePool.sol";
import {MockAToken} from "test/mocks/MockAToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Test} from "forge-std/Test.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

contract PyPouchFactoryTest is Test {
    PyPouchFactory factory;
    MockERC20Token pyusdToken;
    MockAToken aPYUSD;
    MockAavePool aavePool;
    address owner;
    address user1;

    function setUp() public virtual {
        owner = makeAddr("Owner");
        user1 = makeAddr("User1");

        pyusdToken = new MockERC20Token();
        aPYUSD = new MockAToken("aPYUSD", "aPYUSD");
        aavePool = new MockAavePool();

        // Set up aToken in MockAavePool
        aavePool.setAToken(address(pyusdToken), address(aPYUSD));

        // Deploy the factory with the implementation address
        factory = new PyPouchFactory();
    }

    function test_CreatePyPouch() public {
        vm.startPrank(user1);

        // Predict the address of the new PyPouch
        address predictedAddress = factory.getPyPouchAddress(user1);

        // Create a new PyPouch
        address pyPouchAddress = factory.createPyPouch(address(pyusdToken), address(aPYUSD), address(aavePool));

        // Check that the predicted address matches the actual address
        assertEq(predictedAddress, pyPouchAddress);

        // Check that the PyPouch is initialized correctly
        PyPouch pyPouch = PyPouch(pyPouchAddress);
        assertEq(address(pyPouch.pyusdToken()), address(pyusdToken));
        assertEq(address(pyPouch.aPYUSD()), address(aPYUSD));
        assertEq(address(pyPouch.aavePool()), address(aavePool));
        assertEq(pyPouch.owner(), user1);

        vm.stopPrank();
    }
}
