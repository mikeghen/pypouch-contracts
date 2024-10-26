// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PyPouch} from "src/PyPouch.sol";

// PyPouch deployment script
// 
// forge script script/PyPouch.s.sol:PyPouchScript --rpc-url $RPC_URL --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
//
contract PyPouchScript is Script {
    PyPouch public pyPouch;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Replace these addresses with the actual addresses for your deployment
        address pyusdToken = address(0x6c3ea9036406852006290770BEdFcAbA0e23A0e8);  // PYUSD token address
        address aPYUSD = address(0x0C0d01AbF3e6aDfcA0989eBbA9d6e85dD58EaB1E);  // aPYUSD token address
        address poolAddress = address(0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2);  // Aave Pool Addresses Provider address

        pyPouch = new PyPouch(pyusdToken, aPYUSD, poolAddress);

        console.log("PyPouch deployed at:", address(pyPouch));

        vm.stopBroadcast();
    }
}