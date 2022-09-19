// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract HelloWorld {

    //the solidity sintax is a little different from other languages, but easy to understand
    //notice the external, pure, and memory keywords
    function sayHello() external pure returns (string memory) {
        return "Hello World";
    }

    //access modifiers: 
        //public - accessible from inside and outside the contract
        //external - accessible only from outside the contract
        //internal - accessible only from inside the contract and subcontracts (yes, inheritance)
        //private - accessible only from inside the contract

    //state access declaration: 
        //pure - doesn't read or change state (example: a calculator)
        //view - reads from the contract state

    //memory storage: (used for strings, arrays, and structures)
        //memory - reads/stores the data in memory only (will not be persistant)
        //storage - reads/stores the data in storage only (will be persistant)
}