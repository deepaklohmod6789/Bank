from brownie import accounts, network, config
from pathlib import Path
import requests, json

LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["hardhat", "development", "ganache", "mainnet-fork"]
metadata_template = {
    "name": "",
    "description": "",
    "image": "",
    "attributes": [{"trait_type": "cuteness", "value": 100}],
}

def get_account(index=None, id=None):
    if index:
        return accounts[index]
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        return accounts[0]
    if id:
        return accounts.load(id)
    return accounts.add(config["wallets"]["from_key"])

def get_file_uri(fileName):
    metadata_template['name']=fileName
    metadata_template['description']="A cute "+fileName
    filePath=f'./img/{fileName}.jpg'
    image_uri=upload_to_ipfs(filePath)
    metadata_template['image']=image_uri
    metadata_file_name = f"./metadata/{fileName}.json"
    with open(metadata_file_name, "w") as file:
        json.dump(metadata_template, file)
    return upload_to_ipfs(metadata_file_name)

def upload_to_ipfs(filepath):
    with Path(filepath).open("rb") as fp:
        image_binary = fp.read()
        ipfs_url = "http://localhost:5001"
        response = requests.post(ipfs_url + "/api/v0/add",files={"file": image_binary})
        ipfs_hash = response.json()["Hash"]
        filename = filepath.split("/")[-1:][0]
        image_uri = "ipfs://{}?filename={}".format(ipfs_hash, filename)
        print(image_uri)
    return image_uri