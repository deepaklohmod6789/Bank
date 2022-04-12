//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "./Account.sol";

contract Bank {
    address private owner;
    mapping(address => Account) private addressToAccount;
    mapping(address => txn[]) private transactions;
    struct txn {
        address from;
        address to;
        uint256 amount;
        string timeStamp;
        string message;
    }

    constructor() public {
        owner = msg.sender;
    }

    function addFunds(string memory timeStamp) public payable {
        require(msg.value > 0, "Amount should be greater than 0");
        addressToAccount[msg.sender].addFund(msg.value);
        transactions[msg.sender].push(
            txn(
                msg.sender,
                address(addressToAccount[msg.sender]),
                msg.value,
                timeStamp,
                "Added fund to the wallet"
            )
        );
    }

    function transferFund(uint256 amount) public {
        Account acc = addressToAccount[msg.sender];
        uint256 balance = acc.getBalance();
        require(amount <= balance, "Insufficient funds");
        acc.withdrawFund(amount);
    }
}
