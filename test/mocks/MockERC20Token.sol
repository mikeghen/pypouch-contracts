// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20Token is ERC20 {
    constructor() ERC20("Mock Token", "MOCK") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }

    // Additional functions to track the last transfer parameters
    address public lastParam__transfer_to;
    uint256 public lastParam__transfer_amount;

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        lastParam__transfer_to = to;
        lastParam__transfer_amount = amount;
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        lastParam__transfer_to = to;
        lastParam__transfer_amount = amount;
        return super.transferFrom(from, to, amount);
    }
}