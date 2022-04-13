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

    function createAccount() public {
        Account account = new Account(msg.sender);
        addressToAccount[msg.sender] = account;
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

    function withdrawFunds(string memory timeStamp, uint256 amount) public {
        Account acc = addressToAccount[msg.sender];
        uint256 balance = acc.getBalance();
        require(amount <= balance, "Insufficient funds");
        payable(msg.sender).transfer(amount);
        transactions[msg.sender].push(
            txn(
                msg.sender,
                address(addressToAccount[msg.sender]),
                amount,
                timeStamp,
                "Withdrawn fund to the wallet"
            )
        );
    }

    function transferFund(
        uint256 amount,
        bool isAccountTransfer,
        address receiverAddress,
        string memory timeStamp
    ) public {
        Account acc = addressToAccount[msg.sender];
        uint256 balance = acc.getBalance();
        require(amount <= balance, "Insufficient funds");
        acc.withdrawFund(amount);
        if (isAccountTransfer) {
            Account receiver = addressToAccount[receiverAddress];
            receiver.addFund(amount);
            transactions[msg.sender].push(
                txn(
                    msg.sender,
                    address(receiver),
                    amount,
                    timeStamp,
                    "Transferred funds to account"
                )
            );
            transactions[receiverAddress].push(
                txn(
                    msg.sender,
                    address(receiver),
                    amount,
                    timeStamp,
                    "Recieved funds from account"
                )
            );
        } else {
            payable(receiverAddress).transfer(amount);
            transactions[msg.sender].push(
                txn(
                    msg.sender,
                    address(addressToAccount[receiverAddress]),
                    amount,
                    timeStamp,
                    "Transferred funds to the wallet"
                )
            );
        }
    }
}
