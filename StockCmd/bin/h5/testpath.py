import os


def adptPath(path):
    return path.replace("\\","/")

def getMAbsPath(path):
    nPath=os.path.abspath(path)

    return adptPath(nPath)


dataPath="D:/stockdata.git/trunk/stockdatas"
rPath=os.path.relpath(dataPath)
print("rpath:",rPath)
tarPath=rPath;
print(getMAbsPath(tarPath))
