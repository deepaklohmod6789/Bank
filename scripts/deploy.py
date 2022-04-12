from brownie import accounts, network, config
from scripts.helpful_scripts import get_account
from web3 import Web3

OPENSEA_URL = "https://testnets.opensea.io/assets/{}/{}"

def main():
    account= get_account()
    print(account)