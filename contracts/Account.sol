//SPDX-License-Identifier:MIT
pragma solidity ^0.6.0;

contract Account {
    address owner;
    uint256 balance;

    constructor(address accountee) public {
        balance = 0;
        owner = accountee;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }

    function addFund(uint256 value) public {
        balance += value;
    }

    function withdrawFund(uint256 value) public {
        balance -= value;
    }
}
