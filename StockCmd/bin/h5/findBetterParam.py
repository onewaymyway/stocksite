import os
import shutil
import sys
import json
import random

bestFilePath="bestParam.json"
curBestO=None   
def runCMD(cmd):
    os.system(cmd)

def readFile(file):
    f=open(file,"r",encoding="utf8");
    ct=f.read();
    f.close();
    return ct

def saveFile(file,txt):
    f=open(file,"w",encoding="utf8");
    f.write(txt);
    f.close()
    
def loadJson(file):
    return json.loads(readFile(file))

def saveJson(file,obj):
    saveFile(file,json.dumps(obj))

def initBestO():
    global curBestO
    if os.path.exists(bestFilePath):
        curBestO=loadJson(bestFilePath)

def doWork(paramTpl,outFile):
    global curBestO
    saveJson("myParam.json",paramTpl);
    cmdStr="node StockCmd.max.js D:/stockdata.git/trunk/stockdatas/ paramFile=myParam.json outFile="+outFile+" type=BackTestWorker";
    runCMD(cmdStr)
    curRst=loadJson(outFile)
    print("rst:",curRst)
    winRate=curRst["winRate"]
    sellWin=curRst["swin"]
    yearRate=curRst["yearRate"]
    sellWinrate=curRst["swinRate"]
    buyTime=curRst["buyTime"]
    print("------------")
    print("winRate",winRate)
    print("yearRate",yearRate)
    print("sellWin",sellWin)
    print("buyTime",buyTime)
    curRst["param"]=paramTpl
    if curBestO==None:
        curBestO=curRst;
    else:
        if curRst["yearRate"]>curBestO["yearRate"]:
            curBestO=curRst

    if curBestO==curRst:
        print("saveBetter")
        saveJson(bestFilePath,curBestO)


def tryNewParam():
    
    initBestO();
    paramTpl=loadJson("paramTpl.json")
    print(paramTpl)
    traderO=paramTpl["trader"];
    traderParam=traderO["config"]
    sellerParam=traderO["values"][0][1]["config"]
    while(1):
        print("tryNewParam")
        posDayCount=random.randint(20,150)
        maxDay=random.randint(5,posDayCount)
        minBuyLose=random.uniform(-0.5,-0.1)
        maxBuyLose=random.uniform(-1,minBuyLose)
        minBuyExp=random.uniform(0.2,0.7)
        traderParam["posDayCount"]=posDayCount
        traderParam["maxDay"]=maxDay
        traderParam["minBuyLose"]=minBuyLose
        traderParam["maxBuyLose"]=maxBuyLose
        traderParam["minBuyExp"]=minBuyExp
        sellerParam["maxDay"]=maxDay
        doWork(paramTpl,"myRst.json")
    

tryNewParam()

