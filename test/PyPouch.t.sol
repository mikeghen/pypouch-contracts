// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2} from "forge-std/Test.sol";
import {PyPouch} from "src/PyPouch.sol";
import {MockERC20Token} from "test/mocks/MockERC20Token.sol";
import {MockAavePool} from "test/mocks/MockAavePool.sol";
import {MockAToken} from "test/mocks/MockAToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Test} from "forge-std/Test.sol";

contract PyPouchTest is Test {
    PyPouch pyPouch;
    MockERC20Token pyusdToken;
    MockAToken aPYUSD;
    MockAavePool aavePool;
    address owner;
    address user1;
    address user2;

    function setUp() public virtual {
        owner = makeAddr("Owner");
        user1 = makeAddr("User1");
        user2 = makeAddr("User2");

        pyusdToken = new MockERC20Token();
        aPYUSD = new MockAToken("aPYUSD", "aPYUSD");
        aavePool = new MockAavePool();

        // Set up aToken in MockAavePool
        aavePool.setAToken(address(pyusdToken), address(aPYUSD));

        vm.prank(owner);
        pyPouch = new PyPouch(address(pyusdToken), address(aPYUSD), address(aavePool));

        // Warp to a non-zero timestamp
        vm.warp(1);
    }

    function _assumeSafeAddress(address _address) internal view {
        vm.assume(
            _address != address(0) &&
            _address != address(pyPouch) &&
            _address != address(pyusdToken) &&
            _address != address(aPYUSD) &&
            _address != address(aavePool) &&
            uint160(_address) > 9 // Exclude precompiled contracts (0x1 to 0x9)
        );
    }

    function _assumeNotOwnerAddress(address _address) internal view {
        vm.assume(_address != owner);
    }

    function _boundToReasonableAmount(uint256 _amount) internal view returns (uint256) {
        return bound(_amount, 1, 1e30);
    }
}

contract Constructor is PyPouchTest {
    function test_SetsConfigurationParameters() public view {
        assertEq(pyPouch.owner(), owner);
        assertEq(address(pyPouch.pyusdToken()), address(pyusdToken));
        assertEq(address(pyPouch.aPYUSD()), address(aPYUSD));
        assertEq(address(pyPouch.aavePool()), address(aavePool));
    }

    function testFuzz_SetsConfigurationParametersToArbitraryValues(
        address _pyusdToken,
        address _aPYUSD,
        address _aavePool
    ) public {
        _assumeSafeAddress(_pyusdToken);
        _assumeSafeAddress(_aPYUSD);
        _assumeSafeAddress(_aavePool);

        PyPouch _pyPouch = new PyPouch(_pyusdToken, _aPYUSD, _aavePool);

        assertEq(address(_pyPouch.pyusdToken()), _pyusdToken);
        assertEq(address(_pyPouch.aPYUSD()), _aPYUSD);
        assertEq(address(_pyPouch.aavePool()), _aavePool);
    }
}

contract Deposit is PyPouchTest {
    function testFuzz_DepositsTokensSuccessfully(uint256 _amount) public {
        _amount = _boundToReasonableAmount(_amount);

        pyusdToken.mint(user1, _amount);

        vm.startPrank(user1);
        pyusdToken.approve(address(pyPouch), _amount);
        pyPouch.deposit(_amount);
        vm.stopPrank();

        assertEq(pyPouch.getNetDeposits(user1), _amount);
        assertEq(pyPouch.getAPYUSDBalance(), _amount);
    }

    function testFuzz_EmitsDepositEvent(uint256 _amount) public {
        _amount = _boundToReasonableAmount(_amount);

        pyusdToken.mint(user1, _amount);

        vm.startPrank(user1);
        pyusdToken.approve(address(pyPouch), _amount);

        vm.expectEmit(true, false, false, true);
        emit PyPouch.Deposit(user1, _amount);

        pyPouch.deposit(_amount);
        vm.stopPrank();
    }

    function testFuzz_RevertIf_DepositAmountIsZero() public {
        vm.prank(user1);
        vm.expectRevert("Amount must be greater than 0");
        pyPouch.deposit(0);
    }
}

contract Withdraw is PyPouchTest {
    function setUp() public override {
        super.setUp();
        uint256 depositAmount = 1000e18;
        pyusdToken.mint(user1, depositAmount);

        vm.startPrank(user1);
        pyusdToken.approve(address(pyPouch), depositAmount);
        pyPouch.deposit(depositAmount);
        vm.stopPrank();
    }

    function testFuzz_WithdrawsTokensSuccessfully(uint256 _amount) public {
        _amount = bound(_amount, 1, 1000e18);

        vm.prank(user1);
        pyPouch.withdraw(_amount, user2);

        assertEq(pyPouch.getNetDeposits(user1), 1000e18 - _amount);
        assertEq(pyusdToken.balanceOf(user2), _amount);
    }

    function testFuzz_EmitsWithdrawEvent(uint256 _amount) public {
        _amount = bound(_amount, 1, 1000e18);

        vm.prank(user1);

        vm.expectEmit(true, true, false, true);
        emit PyPouch.Withdraw(user1, user2, _amount);

        pyPouch.withdraw(_amount, user2);
    }

    function testFuzz_RevertIf_WithdrawAmountIsZero() public {
        vm.prank(user1);
        vm.expectRevert("Invalid withdraw amount");
        pyPouch.withdraw(0, user2);
    }

    function testFuzz_RevertIf_WithdrawAmountExceedsDeposit(uint256 _amount) public {
        _amount = bound(_amount, 1000e18 + 1, type(uint256).max);

        vm.prank(user1);
        vm.expectRevert("Invalid withdraw amount");
        pyPouch.withdraw(_amount, user2);
    }

    function testFuzz_RevertIf_ReceiverAddressIsZero(uint256 _amount) public {
        _amount = bound(_amount, 1, 1000e18);

        vm.prank(user1);
        vm.expectRevert("Invalid receiver address");
        pyPouch.withdraw(_amount, address(0));
    }
}

contract YieldEarning is PyPouchTest {
    function setUp() public override {
        super.setUp();
        uint256 depositAmount = 1000e18;
        pyusdToken.mint(user1, depositAmount);

        vm.startPrank(user1);
        pyusdToken.approve(address(pyPouch), depositAmount);
        pyPouch.deposit(depositAmount);
        vm.stopPrank();
    }

    function testFuzz_EarnsYieldCorrectly(uint256 _yieldAmount) public {
        _yieldAmount = _boundToReasonableAmount(_yieldAmount);

        // Simulate yield earning by minting additional aPYUSD tokens
        aPYUSD.mint(address(pyPouch), _yieldAmount);

        vm.prank(user1);
        vm.expectEmit();
        emit PyPouch.YieldEarned(user1, _yieldAmount); // Expect yield amount minus 1

        pyPouch.withdraw(1, user1); // Trigger yield checkpoint with a small withdrawal

        assertEq(pyPouch.getAPYUSDBalance(), 1000e18 - 1 + _yieldAmount);
    }
}

contract GetNetDeposits is PyPouchTest {
    function testFuzz_ReturnsCorrectNetDeposits(uint256 _depositAmount, uint256 _withdrawAmount) public {
        _depositAmount = _boundToReasonableAmount(_depositAmount);
        _withdrawAmount = bound(_withdrawAmount, 0, _depositAmount);

        pyusdToken.mint(user1, _depositAmount);

        vm.startPrank(user1);
        pyusdToken.approve(address(pyPouch), _depositAmount);
        pyPouch.deposit(_depositAmount);

        if (_withdrawAmount > 0) {
            pyPouch.withdraw(_withdrawAmount, user1);
        }

        vm.stopPrank();

        assertEq(pyPouch.getNetDeposits(user1), _depositAmount - _withdrawAmount);
    }
}
