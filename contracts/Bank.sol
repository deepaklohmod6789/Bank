//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
import "./Account.sol";

contract Bank {
    address private owner;
    mapping(address => Account) private addressToAccount;
    mapping(address => bool) private accountExistence;

    constructor() public {
        owner = msg.sender;
    }

    function getAccountDetails() public view returns (uint256, string memory) {
        if (accountExistence[msg.sender]) {
            return (
                addressToAccount[msg.sender].getBalance(),
                addressToAccount[msg.sender].createdAt()
            );
        } else {
            return (0, "");
        }
    }

    function createAccount(string memory date) public {
        require(
            accountExistence[msg.sender] == false,
            "Account already exists"
        );
        Account account = new Account(msg.sender, date);
        addressToAccount[msg.sender] = account;
        accountExistence[msg.sender] = true;
    }

    function getAccountBalance() public view returns (uint256) {
        require(accountExistence[msg.sender], "Account doesn't exist");
        return addressToAccount[msg.sender].getBalance();
    }

    function addFunds() public payable {
        require(accountExistence[msg.sender], "Account doesn't exist");
        require(msg.value > 0, "Amount should be greater than 0");
        addressToAccount[msg.sender].addFund(msg.value);
    }

    function withdrawFunds(uint256 amount) public {
        require(accountExistence[msg.sender], "Account doesn't exist");
        Account acc = addressToAccount[msg.sender];
        uint256 balance = acc.getBalance();
        require(amount <= balance, "Insufficient funds");
        acc.withdrawFund(amount);
        payable(msg.sender).transfer(amount);
    }

    function transferToAccount(uint256 amount, address receiverAddress) public {
        require(accountExistence[msg.sender], "Account doesn't exist");
        require(
            accountExistence[receiverAddress],
            "Receiver Account doesn't exist"
        );
        Account acc = addressToAccount[msg.sender];
        uint256 balance = acc.getBalance();
        require(amount <= balance, "Insufficient funds");
        acc.withdrawFund(amount);
        Account receiver = addressToAccount[receiverAddress];
        receiver.addFund(amount);
    }

    function transferToWallet(uint256 amount, address receiverAddress) public {
        require(accountExistence[msg.sender], "Account doesn't exist");
        Account acc = addressToAccount[msg.sender];
        uint256 balance = acc.getBalance();
        require(amount <= balance, "Insufficient funds");
        acc.withdrawFund(amount);
        payable(receiverAddress).transfer(amount);
    }
}
