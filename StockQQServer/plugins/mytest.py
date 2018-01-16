# -*- coding: utf-8 -*-
import os
import stockdataworker as dataworker
import valueTools as vt
import tushare as ts
import time

codeCounts={}
reported={}
preDate=""
codes=[]
def initData():
    global preDate
    global codes
    global reported
    tDate=vt.getDayStr()
    if tDate==preDate:
        return
    preDate=vt.getDayStr()
    reported={}
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
        rate=round(100*(tprice/preprice-1),2)
        preCount=codeCounts[dataO["code"]]
        code=dataO["code"]
        print("code:",dataO["code"],dataO["name"],rate," ",preCount)
        if rate <9.8:
            if not code in reported:
                msg="一字板开板提示:"+dataO["code"]+":"+dataO["name"]+" 当前涨跌幅:"+str(rate)+"% 连续一字板数:"+str(preCount)
                print("Warning code:",dataO["code"],dataO["name"],rate," ",preCount)
                os.system("qq send group LayaAir机器人 "+msg)
                reported[code]=code

def workCodes():
    clock=vt.getClockStr()
    if clock<"09:25:00" or clock >"15:00:00":
        print("not trade time:",clock)
        time.sleep(15)
        return;
    initData()
    checkLoop(codes)       
    time.sleep(15)
    
def doLoop():
    global codes
    while(1):
        try:
            workCodes()
        except:
            time.sleep(15)
        
        


doLoop()

   
