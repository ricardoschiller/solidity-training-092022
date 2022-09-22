// SPDX-License-Identifier: MIT
// pragma solidity 0.6.12  - Only compiles with version 0.6.12
// pragma solidity ^0.6.12 - Compiles with version 0.6.12 and above up until 0.7 (not including)
// pragma solidity >=0.4.0 <0.6.0 - Compiles with all versions between 0.4.0 and 0.6.0
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