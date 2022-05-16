from brownie import NFT, NFTMarket
from scripts.helpful_scripts import get_account, get_file_uri
from web3 import Web3

OPENSEA_URL = "https://testnets.opensea.io/assets/{}/{}"

def main():
    account= get_account()
    nft=NFT.deploy({'from':account})
    # nftMarket=NFTMarket.deploy({'from':account})
    # nft=NFT[-1]
    print(nft)
    nftMarket=NFTMarket[-1]
    # lp=nftMarket.getListingPrice()
    # print(lp)
    # txn1=nft.createCollectible(nftMarket.address,get_file_uri('eagle'),{'from':account})
    # txn1.wait(1)
    # tokenId=nft.tokenCounter()-1
    # print(OPENSEA_URL.format(nft.address,tokenId))
    # print(nftMarket.itemCount())
    # txn2=nftMarket.createMarketItem(nft.address,tokenId,0.1*10**18,{'from':account})
    # txn2.wait(1)
    # print(nftMarket.itemsSold())
    # print(nftMarket.getAllNFTsOnSale())
    # txn3=nftMarket.buyNFT(nft.address,0,{'from':account,'value':100000000000000000})
    # txn3.wait(1)
    # print(nftMarket.itemsSold())
    nftMetaData=nft.tokenURI(0)
    print(nftMetaData)
    