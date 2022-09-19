// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract HelloWorld {

    //we can pass parameters to functions
    function echoMessage(string memory message) external pure returns (string memory) {
        return message;
    }
}