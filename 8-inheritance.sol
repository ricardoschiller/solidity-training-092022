// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//contracts can be abstract, meaning they can't be deployed
abstract contract A {
    uint numberA;
}

//contracts can inherit from other contracts (access modifiers dictate visibility)
abstract contract B is A {
    uint numberB;
}

contract C is B {
    function storeValues(uint a, uint b) external {
        //notice we are accessing state variables without access modifier
        //this means that the default access modifier is internal
        numberA = a;
        numberB = b;
    }
}