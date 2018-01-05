# -*- coding: utf-8 -*-

# 插件加载方法：
# 1. 启动 qqbot 
# 2. 将本文件保存至 ~/.qqbot-tmp/plugins 目录 （或 c:\user\xxx\.qqbot-tmp\plugins ）
# 3. 在命令行窗口输入： qq plug sample
import tushare as ts

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
    

