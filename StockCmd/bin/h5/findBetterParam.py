import os
import shutil
import sys
import json
import random

bestFilePath="bestParam.json"
stockDataPath="D:/lovekxy/codes/python/stockdata.git/trunk/stockdatas"
curBestO=None
isFromNode=False 
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
    saveFile(file,json.dumps(obj,indent=4, sort_keys=True, ensure_ascii=False))

def initBestO():
    global curBestO
    if os.path.exists(bestFilePath):
        curBestO=loadJson(bestFilePath)

def doWork(paramTpl,outFile):
    global curBestO
    saveJson("myParam.json",paramTpl);
    cmdStr="node StockCmd.max.js "+stockDataPath+" paramFile=myParam.json outFile="+outFile+" type=BackTestWorker";
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
        if curRst["yearRate"]>curBestO["yearRate"] and buyTime>1000:
            curBestO=curRst

    if curBestO==curRst:
        print("saveBetter")
        saveJson(bestFilePath,curBestO)
        
def updateBest(paramPath,rstPath):
    print("updateBest",paramPath,rstPath)
    global curBestO
    initBestO()
    curRst=loadJson(rstPath)
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
    
    paramTpl=loadJson(paramPath)
    curRst["param"]=paramTpl
    if buyTime<1000:
        return
    updateBestsByRst(curRst)
    return;
    if curBestO==None :
        curBestO=curRst;
    else:
        if curRst["yearRate"]>curBestO["yearRate"]:
            curBestO=curRst

    if curBestO==curRst:
        print("saveBetter")
        saveJson(bestFilePath,curBestO)

def updateBestsByRst(rstO):
    typeList=["yearRate","winRate","swinRate"]
    sellData=rstO["sSellDay"]
    dayKey=str(round(sellData/3))
    for tkey in typeList:
        curPath="best"+"day"+dayKey+tkey+".json"
        updateBestDataByPath(rstO,curPath,tkey)
        updateBestDataByPath(rstO,"bestData"+tkey+".json",tkey)
        
    
def updateBestDataByPath(rstO,curPath,tkey):
    curData=None
    if os.path.exists(curPath):
        curData=loadJson(curPath)
        print(tkey,curData[tkey],rstO[tkey])
        if curData[tkey]<rstO[tkey]:
            curData=rstO
    else:
        curData=rstO
    if curData==rstO:
        saveJson(curPath,curData)
        
def makeNewParam(tarPath,paramTplPath="paramTpl.json"):
    paramTpl=loadJson(paramTplPath)
    print(paramTpl)
    traderO=paramTpl["trader"];
    traderParam=traderO["config"]
    sellerParam=traderO["values"][0][1]["config"]
    print("makeNewParam")
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
    saveJson(tarPath,paramTpl)
               
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

   
def dealNodeWork(paramPath,rstPath):
    print("dealNodeWork",paramPath,rstPath)
    updateBest(paramPath,rstPath)
    makeNewParam(paramPath,"paramTplNew.json")
    print("workNext")
    
def startNode(paramPath,rstPath):
    print("startNode",paramPath,rstPath);
    cmdStr="node StockCmd.max.js "+stockDataPath+" tempCache=stk.cache paramFile="+paramPath+" outFile="+rstPath+" type=BackTestWorker";
    paramO=loadJson("paramTplNew.json")
    #paramO["nextCMD"]="D:/ProgramData/Anaconda3/python.exe findBetterParam.py "+paramPath+" "+rstPath
    saveJson(paramPath,paramO)
    saveJson("paramTplNew.json",paramO)
    runCMD(cmdStr)

def scriptStart():
    paramLen=len(sys.argv)
    print("param:",sys.argv)
    if paramLen==1:
        startNode('nodeParam.json',"nodeRst.json")
        return
    if paramLen==3:
        paramPath=sys.argv[1]
        rstPath=sys.argv[2]
        dealNodeWork(paramPath,rstPath)
if __name__ == "__main__":
    scriptStart()
    
