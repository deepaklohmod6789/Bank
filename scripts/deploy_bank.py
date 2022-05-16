from brownie import Bank
from web3 import Web3
from scripts.helpful_scripts import get_account

def main():
    account=get_account()
    bank=Bank[-1]
    print(account)
    # bank=Bank.deploy({'from':account})
    print(bank)
    # txn=bank.getAccountDetails()
    # print(txn)
    txn1=bank.createAccount('1652676908477',{'from':account})
    txn1.wait(1)
    txn=bank.getAccountDetails({'from':account})
    print(txn)
    # amount=Web3.toWei(0.05,'ether')
    # txn2=bank.addFunds({'from':account,'value':amount})
    # txn2.wait(1)
    # balance=bank.getAccountDetails({'from':account})
    # print(balance)
    # txn3=bank.withdrawFunds(amount,{'from':account})
    # txn3.wait(1)
    # balance=bank.getAccountBalance({'from':account})
    # print(balance)