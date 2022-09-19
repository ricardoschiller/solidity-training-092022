// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract HelloWorld {

    event record(
        string indexed text
    );

    constructor() {
        //the best way to understand emit is to think of it like a log
        //debudding in solidity is hard, and there is no way to printf data
        emit record("Hello world");
    }
}