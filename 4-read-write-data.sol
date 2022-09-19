// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ReadWrite {

    //contracts can contain state, which is stored in contract variables
    //notice the private access modifier for counter
    int private counter;

    //notice the view access instead of pure
    function read() external view returns (int) {
        return counter;
    }

    //notice the omission of view or pure - we need to push a transaction to execute this
    function increment(int amount) external {
        counter = counter + amount;
    }

    //same here, we need to push a transaction to the network to execute this
    function decrement(int amount) external {
        counter = counter - amount;
    }
}