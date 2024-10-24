// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./MockAToken.sol";

contract MockAavePool {
    mapping(address => address) public aTokens;

    function setAToken(address asset, address aToken) external {
        aTokens[asset] = aToken;
    }

    function supply(address asset, uint256 amount, address onBehalfOf, uint16) external {
        require(aTokens[asset] != address(0), "AToken not set for asset");
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        MockAToken(aTokens[asset]).mint(onBehalfOf, amount);
    }

    function withdraw(address asset, uint256 amount, address to) external returns (uint256) {
        require(aTokens[asset] != address(0), "AToken not set for asset");
        MockAToken(aTokens[asset]).burn(msg.sender, amount);
        IERC20(asset).transfer(to, amount);
        return amount;
    }
}