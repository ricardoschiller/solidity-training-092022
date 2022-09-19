// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./libs/SafeMath.sol";

contract Payments {
    using SafeMath for uint256;

    mapping (address => uint) public accounts;

    //msg.sender is a keyword to get the wallet address of the message sender
    function whoAmI() external view returns (address) {
        return msg.sender;
    }

    //we can use msg.sender to map that address to other data
    //notice the payable keyword, and the msg.value
    //without it we couldn't have transferred the blockchain native currency to this method
    //and without it, we couldn't have accessed that amount through the msg.value keyword
    function deposit() external payable lock {
        require(msg.value > 0, "No ether sent");
        accounts[msg.sender] = accounts[msg.sender].add(msg.value);
    }

    //notice the lock, it is a modifier keyword
    //there is a complex reason this lock is here, it is to prevent reentrancy attacks, which are mainly possible with payable functions
    //how to make the attack:
    //1. consider the message sender is a contract
    //2. the withraw function will send funds to the contract
    //3. there is a special function called receive that can be added to a contract, and executes code when native currency funds are transferred
    //4. inside that receive function, call the withraw function again
    //5. if the transfer of funds is done BEFORE the amount transferred is accounted for internally (through a subtraction), the transfer is executed again
    //6. The contract is drained from all funds
    function withdraw(uint amount) external lock {
        require(accounts[msg.sender] >= amount, "Not enough balance in account");
        require(address(this).balance >= amount, "Not enough balance in contract");

        //when dealing with funds, it is a best practice to account for it BEFORE transferring the amount
        accounts[msg.sender] = accounts[msg.sender].sub(amount);
        //transfer the funds to the destination address
        payable(msg.sender).transfer(amount);
    }

    bool isTransferLocked = false;
    //modifiers wrap the code of the function they are added to, and can have pre and post conditions
    //this simple lock implementation blocks all reentrancy attacks
    //this isn't equal to a mutex lock for multi-threading. All contract code execution is sequential and single-threaded!
    modifier lock() {
        require(!isTransferLocked, "Reentrancy blocked");
        isTransferLocked = true;
        //this underscore states where the body of the function the lock is added to, will actually run
        _;
        isTransferLocked = false;
    }
}