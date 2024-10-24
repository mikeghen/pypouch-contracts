// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockAavePoolAddressesProvider {
    address private mockPool;

    constructor(address _mockPool) {
        mockPool = _mockPool;
    }

    function getPool() external view returns (address) {
        return mockPool;
    }
}