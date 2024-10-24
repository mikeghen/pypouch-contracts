// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/PyPouch.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Usage:
// 1. Deposit:
// DEPOSIT_AMOUNT=1000000000000000000 forge script script/PyPouchActions.sol:Deposit --rpc-url <your_rpc_url> --broadcast
// 
// 2. Withdraw:
// WITHDRAW_AMOUNT=500000000000000000 RECEIVER_ADDRESS=0x1234567890123456789012345678901234567890 forge script script/PyPouchActions.sol:Withdraw --rpc-url <your_rpc_url> --broadcast
//
// 3. Get Net Deposits:
// USER_ADDRESS=0x1234567890123456789012345678901234567890 forge script script/PyPouchActions.sol:GetNetDeposits --rpc-url <your_rpc_url>
//
// 4. Get aPYUSD Balance:
// forge script script/PyPouchActions.sol:GetAPYUSDBalance --rpc-url <your_rpc_url>

abstract contract BaseAction is Script {
    PyPouch public pyPouch;
    IERC20 public pyusdToken;
    uint256 private userKey;

    function setUp() public virtual {
        userKey = vm.envUint("OWNER_PRIVATE_KEY");
        pyPouch = PyPouch(vm.envAddress("PY_POUCH_ADDRESS"));
        pyusdToken = IERC20(vm.envAddress("PYUSD_TOKEN_ADDRESS"));
    }

    function run() public virtual;
}

contract Deposit is BaseAction {
    function run() public override {
        vm.startBroadcast(userKey);
        uint256 amount = vm.envUint("DEPOSIT_AMOUNT");
        pyusdToken.approve(address(pyPouch), amount);
        pyPouch.deposit(amount);
        console.log("Deposited", amount, "PYUSD");
        vm.stopBroadcast();
    }
}

contract Withdraw is BaseAction {
    function run() public override {
        vm.startBroadcast(userKey);
        uint256 amount = vm.envUint("WITHDRAW_AMOUNT");
        address receiver = vm.envAddress("RECEIVER_ADDRESS");
        pyPouch.withdraw(amount, receiver);
        console.log("Withdrawn", amount, "PYUSD to", receiver);
        vm.stopBroadcast();
    }
}

contract GetNetDeposits is BaseAction {
    function run() public override view {
        address user = vm.envAddress("USER_ADDRESS");
        uint256 netDeposits = pyPouch.getNetDeposits(user);
        console.log("Net deposits for", user, ":", netDeposits);
    }
}

contract GetAPYUSDBalance is BaseAction {
    function run() public override view {
        uint256 balance = pyPouch.getAPYUSDBalance();
        console.log("aPYUSD balance in PyPouch:", balance);
    }
}
