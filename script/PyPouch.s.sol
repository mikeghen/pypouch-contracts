// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PyPouch} from "../src/PyPouch.sol";

contract PyPouchScript is Script {
    PyPouch public pyPouch;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Replace these addresses with the actual addresses for your deployment
        address pyusdToken = address(0x466a756E9A7401B5e2444a3fCB3c2C12FBEa0a54);  // PYUSD token address
        address aPYUSD = address(0x9daF8c91AEFAE50b9c0E69629D3F6Ca40cA3B3FE);  // aPYUSD token address
        address poolAddressesProvider = address(0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e);  // Aave Pool Addresses Provider address

        pyPouch = new PyPouch(pyusdToken, aPYUSD, poolAddressesProvider);

        console.log("PyPouch deployed at:", address(pyPouch));

        vm.stopBroadcast();
    }
}
