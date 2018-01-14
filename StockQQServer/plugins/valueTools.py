# -*- coding: utf-8 -*-
import os

tplArrDic={}

def getMyPath(filepath):
    myRoot=os.path.split(os.path.realpath(filepath))[0]
    myRoot=myRoot.replace("\\","/")+"/"
    return myRoot

def getFlatKeyValue(obj,key):
    if not obj:
        return None
    if not key:
        return obj
    keys=key.split(".")
    tV=obj
    try:
        for tkey in keys:
            tV=tV[tkey]
    except:
        return None
    return tV

def getFlatKeyValueNum(obj,key):
    rst=getFlatKeyValue(obj,key)
    if not rst:
        return 0
    return getNum(rst)

def getFlatKeyValueStr(obj,key):
    rst=getFlatKeyValue(obj,key)
    if not rst:
        return ""
    return getStr(rst)

def getNum(v):
    #print(v,type(v))
    if type(v)!="float":
        return float(v)
    return v;

def getStr(v):
    if type(v)!="str":
        return str(v)
    return v

def sortBigFirst(a, b):
    a=getStr(a)
    b=getStr(b)

    if a==b:
        return 0
    return 1 if b>a else -1

def sortSmallFirst(a, b):
    a=getStr(a)
    b=getStr(b)

    if a==b:
        return 0
    return -1 if b>a else 1

def sortNumBigFirst(a, b):
    a=getNum(a)
    b=getNum(b)
    if a==b:
        return 0
    return 1 if b>a else -1

def sortNumSmallFirst(a, b):
    a=getNum(a)
    b=getNum(b)
    if a==b:
        return 0
    return -1 if b>a else 1
    
def sortByKey(key,forceNum = True):
    def msort(a):
        return getNum(a[key]) if forceNum else getStr(a[key])
    return msort;
    
def sortByKeyEX(key,forceNum = True):
    if not "." in key:
        return sortByKey(key,forceNum)
    
    getKeyFun=getFlatKeyValueNum if forceNum else getFlatKeyValueStr
    def msort(a):
        return getKeyFun(a, key)
    return msort;
    
def sortListByKey(dataList,key,bigFirst=False,forceNum=True):
    return sorted(dataList,key=sortByKeyEX(key,forceNum),reverse = bigFirst)

def copyArr(arr):
    return arr[:]

def splitStpl(tplStr):
    if tplStr in tplArrDic:
        return copyArr(tplArrDic[tplStr])
    rst=[]
    preI=0
    for i in range(0,len(tplStr)):
        tStr=tplStr[i]
        if tStr=="#":
            if i-1>=preI:
                #print(preI,i)
                rst.append(tplStr[preI:i])
            preI=i+1
                
        if tStr=="{" or tStr=="}":
            if i-1>=preI:
                rst.append(tplStr[preI:i])
            rst.append(tStr)
            preI=i+1
    if i-1>=preI:
        rst.append(tplStr[preI:i])
    tplArrDic[tplStr]=rst
    return copyArr(rst)

def getTplStr(tplStr, data):
    tps=splitStpl(tplStr)
    preOpen=False
    nextEnd=False
    lenTps=len(tps)
    #print(tps)
    for i in range(0,lenTps):
        tStr=tps[i]
        if i+1<lenTps:
            nextStr=tps[i+1]
        else:
            nextStr=""
        if nextStr=="}":
            nextEnd=True
        else:
            nextEnd=False
        if preOpen and nextEnd:
            if tStr in data:
                #print(data,tStr)
                tps[i]=getStr(data[tStr])
            else:
                tps[i]=getFlatKeyValueStr(data,tStr)
            tps[i-1]=""
            tps[i+1]=""
        if tStr=="{":
            preOpen=True
        else:
            preOpen=False
    return "".join(tps)
