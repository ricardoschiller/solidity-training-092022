// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ReadWrite {

    int counter;

    function read() external view returns (int) {
        return counter;
    }

    //if the amount is too large, we will surpass the gas limit and the transaction will fail
    function increment(int amount) external {
        for(int i = 0; i < amount; i++) {
            counter += 1;
        }
    }

    function decrement(int amount) external {
        counter = counter - amount;
    }
}