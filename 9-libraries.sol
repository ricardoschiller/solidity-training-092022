// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./libs/SafeMath.sol";

contract Math {
    using SafeMath for uint256;
    function add(uint num1, uint num2) external pure returns (uint) {
        return num1.add(num2);
    }

    function sub(uint num1, uint num2) external pure returns (uint) {
        return num1.sub(num2);
    }

    function mul(uint num1, uint num2) external pure returns (uint) {
        return num1.mul(num2);
    }

    function div(uint num1, uint num2) external pure returns (uint) {
        return num1.div(num2);
    }
}