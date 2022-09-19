// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//an example of the base anatomy of most token contracts out there, which move billions of $
contract ERC20 {
    uint public totalSupply;

    //a mapping for the balances of each address
    mapping(address => uint) public balanceOf;

    //a mapping for the allowances of one address to others
    //this is related to the transferFrom function
    //both exist to make easy the integration with other contracts, like DeFi liquidity pools, for example
    mapping(address => mapping(address => uint)) public allowance;

    //The name, symbol and precision of the token
    string public name = "Solidity by Example";
    string public symbol = "SOLBYEX";

    //notice that, even though the precision is stated, it isn't used anywhere in the code
    //this happens many times
    //in this case, the precision is just an agreement that, when the values stored in this contract
    //are shown in a web application, they should be decided by 10^18
    uint8 public decimals = 18;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    //a simple transfer function to transfer tokens from one account to the other
    //notice that the transfer actually just constitutes decreasing values in one mapping
    //and increasing in another, similarly to an excel sheet
    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    //the approve function allows you to pre-approve an amount that can be taken (through the transferFrom function)
    //by another account or contract
    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    //transferFrom can be successfully executed if the amount has been allowed (is in the allowance mapping) through
    //the approve function
    function transferFrom(address sender, address recipient, uint amount) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    //this is a dumb mint function, because anyone can mint how much they want
    //therefore, this token would have zero value, because anyone can mint how much they want
    //the trick for a successful token is here, how to use this minting function properly
    //first thing is to make this minting function internal, and use it only when specific rules are met
    //those rules are the tokenomics of the project
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    //tokens can be burned too, which translates to removing them from circulation
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}