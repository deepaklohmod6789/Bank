//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract User {
    mapping(address => UserData) addressToUser;
    struct UserData {
        string url;
        string name;
        string username;
        bool haveData;
    }

    function createUser(
        string memory url,
        string memory name,
        string memory username
    ) public {
        addressToUser[msg.sender] = UserData(url, name, username, true);
    }

    function checkUser() public view returns (bool) {
        if (addressToUser[msg.sender].haveData == true) {
            return true;
        } else {
            return false;
        }
    }

    function updateName(string memory name) public {
        addressToUser[msg.sender].name = name;
    }

    function updateUserName(string memory username) public {
        addressToUser[msg.sender].username = username;
    }

    function updateUrl(string memory url) public {
        addressToUser[msg.sender].url = url;
    }

    function getUser() public view returns (UserData memory) {
        return addressToUser[msg.sender];
    }
}
