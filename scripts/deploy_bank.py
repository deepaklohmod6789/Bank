from brownie import Bank
from web3 import Web3
from scripts.helpful_scripts import get_account

def main():
    account=get_account()
    bank=Bank[-1]
    # bank=Bank.deploy({'from':account})
    txn1=bank.createAccount({'from':account})
    txn1.wait(1)
    amount=Web3.toWei(0.05,'ether')
    txn2=bank.addFunds('13/4/22',{'from':account,'value':amount})
    txn2.wait(1)
    balance=bank.getAccountBalance()
    print(balance)
    txn3=bank.withdrawFunds('13/4/22',amount,{'from':account})
    txn3.wait(1)
    balance=bank.getAccountBalance()
    print(balance)