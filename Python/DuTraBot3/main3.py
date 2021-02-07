'''
    This is DuTraBot : Binance Mode
    Author  : D
    Version : 0.1


# Import Modules #



# Variables #
x = "fantastic"


# Functions #



# Main Logic #


import urllib.request
import json
import datetime
import math
import tkinter


vIP   = "87.237.20.224"
vURL  = "https://geolocation-db.com/json/" + vIP
vTIME = datetime.datetime.now()
vMATH = math.pi
with urllib.request.urlopen(vURL) as url:
    data = json.loads(url.read().decode())

print("Date :",vTIME.strftime("%Y%m%d"))
print("IP: ",vIP,"\t",end='')
print("Country",data["country_name"])
# print(json.dumps(data, indent=3, sort_keys=True))
print("PI : ",end='')
print("{:.5f}".format(vMATH))
'''

import tkinter as tk

class App(tk.Frame):
    def __init__(self, master=None):
        super().__init__(master)
        self.pack()

# create the application
myapp = App()

#
# here are method calls to the window manager class
#
myapp.master.title("My Do-Nothing Application")
myapp.master.maxsize(1000, 400)

# start the program
myapp.mainloop()