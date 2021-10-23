# This is the Python Version fo Duane's Trading Bot.
# V00.1

# This Bot uses Binance API
BINANCEAPI = 'NzV2OH8BcT8OiEPpiqyDF9pGol1xBepR8D5jwMgW86GSOLYPB32k4V5zpfucg2jh'
BINANCEKEY = '95bkSzXwHMf98zomQGYhT27vrdKzQr7wuAxROYsygacaE1ZuqT4E1f5FKmSrfPpT'

import json
import Python.DuTraBot2.binance as Binance

Binance.MARKET


#from binance.client import Client

#Function to print JSON format in Human Readable Format
def printjson(fname):
    print(json.dumps(fname, indent=2))

#Set client with the APi and Secret Key
client = Client(BINANCEAPI, BINANCEKEY)

#Binance Exchane Status (Normal / Maintenance
status = client.get_system_status()
print(status['msg'])

#My Account Balances
myaccount = client.get_account()
printjson(myaccount)
print(myaccount['balances'])

#Get my Account Balance for an Asset
balance = client.get_asset_balance(asset='GBP')
printjson(balance)

#symbolinfo
symbolinfo = client.get_symbol_info('BNBGBP')
printjson(symbolinfo)




