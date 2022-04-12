//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint256 public tokenCounter;

    constructor() public ERC721("Test", "T") {
        tokenCounter = 0;
    }

    function createCollectible(address marketAddress, string memory tokenURI)
        public
    {
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        approve(marketAddress, newTokenId);
        tokenCounter += 1;
    }
}
