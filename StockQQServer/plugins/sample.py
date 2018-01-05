# -*- coding: utf-8 -*-

# 插件加载方法：
# 1. 启动 qqbot 
# 2. 将本文件保存至 ~/.qqbot-tmp/plugins 目录 （或 c:\user\xxx\.qqbot-tmp\plugins ）
# 3. 在命令行窗口输入： qq plug sample
import tushare as ts
import os
import shutil
import sys
import json
import valueTools as vt

myRoot=os.getcwd().replace("\\","/")+"/"

configO={}
myDataO={}
def initDatas():
    global configO
    configO["stockDataPath"]=os.path.normpath(myRoot+"../../StockView/bin/h5/last.json")
    stockO=readStockData()
    
    stockList=stockO["stocks"]
    typeList=stockO["types"]
    myDataO["stocks"]=stockList
    myDataO["types"]=typeList
    stockDic={}
    for tStock in stockList:
        stockDic[tStock["code"]]=tStock
    myDataO["stockDic"]=stockDic
def getStockDataOByCode(code):
    stockDic=myDataO["stockDic"]
    if code in stockDic:
        return stockDic[code]
    return None
    
def readStockData():
    f=open(configO["stockDataPath"],"r",encoding="utf-8")
    jsStr=f.read()
    f.close()
    jsO=json.loads(jsStr)
    return jsO

def getGoodPercent(tPrice,prePrice):
    return round((tPrice-prePrice)*100/prePrice,2)
def getStockInfo(stock):
    realData=ts.get_realtime_quotes(stock).iloc[0]
    print(realData)
    rstStr=""
    rstStr=realData["name"]+" "+stock+" price:"+realData.price+" rate:"+str(getGoodPercent(float(realData.price),float(realData.pre_close)))+"%"
    #rstStr=realData.name+" "+stock+" price:"
    return rstStr

def getDaysInfo(stock):
    pass

def getIndexInfo():
    df = ts.get_index()
    sp=df[["name","change"]]
    return sp.to_string()

def onQQMessage(bot, contact, member, content):
    if content.find("stock:")>=0:
        arr=content.split(":")
        tStock=arr[1]
        print(arr)
        bot.SendTo(contact, getStockInfo(tStock))
        return
    if content.find("获取指数")>=0:
        bot.SendTo(contact,getIndexInfo())
        return
 
def getRank(rankID,count):
    stockO=readStockData()
    stockList=stockO["stocks"]
    typeList=stockO["types"]
    #print(stockList)
    #print(typeList)
    t=typeList[rankID]
    print(t)
    sortParams=t["sortParams"]
    s=vt.sortListByKey(stockList,sortParams[0],sortParams[1],sortParams[2])
    rstList=[t["tip"]]
    for i in range(0,count):
        rstList.append(vt.getTplStr(t["tpl"],s[i][t["dataKey"]]))
    rst="\n\n".join(rstList)
    print(rst)
    return rst

def mTest():
    getRank(25,10)
    print(getStockDataOByCode("601918"))
initDatas()
mTest()