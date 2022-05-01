//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./ProductNFT.sol";

contract ProductAuthentication is ReentrancyGuard, IERC721Receiver {
    uint256 itemCount = 0;
    struct Transaction {
        string timeStamp;
        address to;
        uint256 price;
    }
    struct Item {
        uint256 itemId;
        string productName;
        string qrCode;
        address nftContract;
        uint256 tokenId;
        address owner;
        uint256 price;
    }
    mapping(uint256 => Item) private items;

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function addProduct(
        string memory productName,
        string memory symbol,
        string memory qrCode,
        string memory uri,
        uint256 tokenId,
        uint256 price
    ) public nonReentrant {
        ProductNFT nft = new ProductNFT(productName, symbol);
        nft.createCollectible(msg.sender, address(this), uri);

        items[itemCount] = Item(
            itemCount,
            productName,
            qrCode,
            address(nft),
            0,
            msg.sender,
            price
        );
        itemCount++;
    }

    function sellProduct(
        address productNft,
        uint256 itemId,
        uint256 tokenId,
        address newOwner,
        string memory timeStamp,
        uint256 newPrice
    ) public nonReentrant {
        IERC721(productNft).transferFrom(msg.sender, newOwner, tokenId);
        // items[itemId].txn.push(Transaction(timeStamp, newOwner, newPrice));
    }

    function scanProduct(string memory qrCode) public returns (Item memory) {
        for (uint256 i = 0; i < itemCount; i++) {
            if (
                keccak256(abi.encodePacked(items[i].qrCode)) ==
                keccak256(abi.encodePacked(qrCode))
            ) {
                return items[i];
            } else {
                revert("Not found");
            }
        }
    }

    function getAll() public view returns (Item[] memory) {
        uint256 totalItemCount = itemCount;
        uint256 currentIndex = 0;

        Item[] memory myItems = new Item[](totalItemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (items[i].owner == msg.sender) {
                uint256 currentId = items[i].itemId;
                Item storage currentItem = items[currentId];
                myItems[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return myItems;
    }

    function getMyProducts() public view returns (Item[] memory) {
        uint256 itemsCount = 0;
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < itemCount; i++) {
            if (items[i].owner == msg.sender) {
                itemsCount += 1;
            }
        }

        Item[] memory myItems = new Item[](itemsCount);
        for (uint256 i = 0; i < itemsCount; i++) {
            if (items[i].owner == msg.sender) {
                Item storage currentItem = items[i];
                myItems[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return myItems;
    }
}
