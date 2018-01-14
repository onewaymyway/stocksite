# -*- coding: utf-8 -*-
import os
import tushare as ts
import json


def getGoodPercent(tPrice,prePrice):
    return round((tPrice-prePrice)*100/prePrice,2)
    
def getStockCurTimeInfo(stock):
    return ts.get_realtime_quotes(stock).iloc[0]

def readStockData(datapath):
    f=open(datapath,"r",encoding="utf-8")
    jsStr=f.read()
    f.close()
    jsO=json.loads(jsStr)
    return jsO
 
def getIndexInfo(self):
    df = ts.get_index()
    sp=df[["name","change"]]
    return sp.to_string()

class LastDataReader():
    
    def __init__(self):
        self.configO={}   
        self.myDataO={}
        
    def setDataPath(self,datapath):
        self.datapath=datapath
        self.initDatas()

    def initDatas(self):
        
        stockO=readStockData(self.datapath)
        
        stockList=stockO["stocks"]
        typeList=stockO["types"]
        self.myDataO["stocks"]=stockList
        self.myDataO["types"]=typeList
        stockDic={}
        for tStock in stockList:
            stockDic[tStock["code"]]=tStock
        self.myDataO["stockDic"]=stockDic
                    
    def getStockDataOByCode(self,code):
        stockDic=self.myDataO["stockDic"]
        #print(code,stockDic[code])
        if code in stockDic:
            return stockDic[code]
        return None
    
    def getStockList(self):
        return self.myDataO["stocks"]
    
    def getUpStops(self):
        
        stocks=self.getStockList()
        stops=[]
        #print("getUpStops")
        for code in stocks:
            stockO=code
            if stockO["upstops"]>0:
                dataO={}
                dataO["code"]=stockO["code"]
                dataO["upcount"]=stockO["upstops"]
                stops.append(dataO)
        return stops
    
    def getDaysInfo(self,stock):
        pass
    
