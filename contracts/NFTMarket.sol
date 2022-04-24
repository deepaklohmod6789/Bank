//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NFTMarket is ReentrancyGuard, IERC721Receiver {
    uint256 public itemCount;
    uint256 public itemsSold;
    address payable owner;
    struct MarketItem {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address owner;
        uint256 price;
        bool onSale;
    }
    mapping(uint256 => MarketItem) private idMarketItem;
    event MarketItemCreated(
        uint256 indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address owner,
        uint256 price,
        bool onSale
    );
    uint128 listingPrice = 0.025 ether;

    constructor() public {
        itemCount = 0;
        itemsSold = 0;
        owner = payable(msg.sender);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function getListingPrice() public view returns (uint128) {
        return listingPrice;
    }

    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) public nonReentrant {
        require(price >= listingPrice, "Price must be more than listing price");
        uint256 itemId = itemCount;
        itemCount++;

        idMarketItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            price,
            true
        );

        // IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        emit MarketItemCreated(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            price,
            true
        );
    }

    function buyNFT(address nftContract, uint256 itemId)
        public
        payable
        nonReentrant
    {
        uint256 price = idMarketItem[itemId].price;
        uint256 tokenId = idMarketItem[itemId].tokenId;

        require(
            msg.value == price,
            "Please submit the asking price in order to complete purchase"
        );

        payable(idMarketItem[itemId].owner).transfer(msg.value - listingPrice);

        IERC721(nftContract).transferFrom(
            idMarketItem[itemId].owner,
            msg.sender,
            tokenId
        );

        idMarketItem[itemId].owner = msg.sender;
        idMarketItem[itemId].onSale = false;
        itemsSold++;
        payable(owner).transfer(listingPrice);
    }

    function getAllNFTsOnSale() public view returns (MarketItem[] memory) {
        uint256 unsoldItemCount = itemCount - itemsSold;
        uint256 currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);

        for (uint256 i = 0; i < itemCount; i++) {
            if (idMarketItem[i].onSale == true) {
                uint256 currentId = idMarketItem[i].itemId;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    function getAllMyNFTs() public view returns (MarketItem[] memory) {
        uint256 totalItemCount = itemCount;
        uint256 itemsCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idMarketItem[i].owner == msg.sender) {
                itemsCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemsCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idMarketItem[i].owner == msg.sender) {
                uint256 currentId = idMarketItem[i].itemId;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
}
