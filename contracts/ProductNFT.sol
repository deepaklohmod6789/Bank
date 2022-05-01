//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract ProductNFT is ERC721, IERC721Receiver {
    uint256 public tokenCounter;

    constructor(string memory name, string memory symbol)
        public
        ERC721(name, symbol)
    {
        tokenCounter = 0;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function createCollectible(
        address owner,
        address marketAddress,
        string memory tokenURI
    ) public {
        uint256 newTokenId = tokenCounter;
        _safeMint(owner, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        // approve(marketAddress, newTokenId);
        tokenCounter += 1;
    }
}
