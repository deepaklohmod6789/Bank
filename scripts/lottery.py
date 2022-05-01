from brownie import Lottery,config,network
from scripts.helpful_scripts import get_account, fund_with_link

def main():
    account= get_account()
    # lottery=Lottery.deploy(
    #     config['networks'][network.show_active()]['eth_usd_price_feed'],
    #     config['networks'][network.show_active()]['vrf_coordinator'],
    #     config['networks'][network.show_active()]['link_token'],
    #     config['networks'][network.show_active()]['fee'],
    #     config['networks'][network.show_active()]['keyhash'],
    #     {'from':account}
    # )
    lottery=Lottery[-1]
    entryFee=lottery.getEntryFee()
    txn1=lottery.startLottery({'from':account})
    txn1.wait(1)
    txn2=lottery.enterLottery({'from':account,'value':entryFee})
    txn2.wait(1)
    txn3 = fund_with_link(lottery.address)
    txn3.wait(1)
    txn4=lottery.endLottery({'from':account})
    txn4.wait(1)
    