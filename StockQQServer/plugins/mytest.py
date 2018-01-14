# -*- coding: utf-8 -*-
import os
import stockdataworker as dataworker
import valueTools as vt
import tushare as ts

codeCounts={}
def checkLoop(codes):
    datas=ts.get_realtime_quotes(codes)
    #print(datas)
    for index in datas.index:
        dataO=datas.loc[index]
        openP=float(dataO["open"])
        if openP <0.1:
            continue
        tprice=float(dataO["price"])
        preprice=float(dataO["pre_close"])
        rate=100*(tprice/preprice-1)
        preCount=codeCounts[dataO["code"]]
        print("code:",dataO["code"],dataO["name"],rate," ",preCount)

def doLoop(codes):
    while(1):
        checkLoop(codes)       
        
myRoot=vt.getMyPath(__file__)
datapath=os.path.normpath(myRoot+"../../StockView/bin/h5/last.json")
dr=dataworker.LastDataReader()
dr.setDataPath(datapath)
stops=dr.getUpStops()
print(stops)
codes=[]
for stocko in stops:
    
    codes.append(stocko["code"])
    codeCounts[stocko["code"]]=stocko["upcount"]

print(codes)
checkLoop(codes)

   
