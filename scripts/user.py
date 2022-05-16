from brownie import User
from scripts.helpful_scripts import get_account, upload_to_ipfs

def main():
    account=get_account()
    # user=User.deploy({'from':account})
    user=User[-1]
    print(user)
    # print(user.checkUser())
    # filePath='./img/parrot.jpg'
    # txn1=user.createUser(upload_to_ipfs(filePath),'John','john_0101',{'from':account})
    # txn1.wait(1)
    # print(user.getUser())
    