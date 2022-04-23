from brownie import NFT
from scripts.helpful_scripts import get_account, get_file_uri
from web3 import Web3

OPENSEA_URL = "https://testnets.opensea.io/assets/{}/{}"

def main():
    account= get_account()
    # nft=NFT.deploy({'from':account})
    print(get_file_uri('eagle'))