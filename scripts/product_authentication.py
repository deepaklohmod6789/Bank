from brownie import ProductAuthentication
from web3 import Web3
from scripts.helpful_scripts import get_account,get_file_uri
from scripts.deploy_nfts import OPENSEA_URL

def main():
    account=get_account()
    prodAuth=ProductAuthentication.deploy({'from':account})
    prodAuth=ProductAuthentication[-1]
    txn=prodAuth.addProduct(
        'University Blue',
        'Shoes',
        'sfasjfbvajscb!zdvQRCODE',
        get_file_uri('shoes'),
        0,
        Web3.toWei(0.5,'ether'),
        {'from':account}
    )
    txn.wait(1)
    print(prodAuth.getAll())
    print(prodAuth.getMyProducts())
    # print(OPENSEA_URL.format(address,0))