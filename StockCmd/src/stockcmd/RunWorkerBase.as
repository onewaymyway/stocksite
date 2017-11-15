package stockcmd 
{
	import laya.utils.Utils;
	import nodetools.devices.CMDShell;
	import nodetools.devices.FileManager;
	import nodetools.devices.FileTools;
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class RunWorkerBase 
	{
		
		public function RunWorkerBase() 
		{
			
		}
		public var isCacheChanged:Boolean;
		public var cacheO:Object;
		public var useCache:Boolean = false;
		public var nextCMD:String;
		public function work():void {
			trace("work");
			if (!FileTools.exist(RunConfig.filePath)) {
				trace("file not found:", RunConfig.filePath);
				return;
			}
			nextCMD = null;
			initCache();
			workInits();
			trace('nextCMD:',nextCMD)
			//dealNextCMD()
			//return;
			if (FileTools.isDirectory(RunConfig.filePath)) {
				workDir(RunConfig.filePath);
			}
			else {
				analyserAFile(RunConfig.filePath);
			}
			workEnd();
			//dealCache();
			dealNextCMD();
		}
		public function dealNextCMD():void
		{
			if (nextCMD)
			{
				CMDShell.execute(nextCMD,Utils.bind(myCMDCallBack,this));
			}
		}
		private function myCMDCallBack(err:String, stdOut:String, stdErr:String):void
		{
			trace("stdOut:", stdOut)
			trace("err:", err)
			trace("stdErr:", stdErr)
			if (stdOut)
			{
				var strArr:Array;
				strArr = stdOut.split("\n")
				var lastCmd:String;
				
				trace(strArr)
				
				
				
				while (!lastCmd && strArr.length) lastCmd = strArr.pop();
				trace("type",typeof(lastCmd),lastCmd.indexOf("workNext") >= 0)
				trace("LCMD:", lastCmd)
				if (lastCmd.indexOf("workNext") >= 0)
				{
					trace("work new")
					work();
				}
			}
		}
		public function initCache():void
		{
			if (cacheO) return;
			if (RunConfig.tempCache != "")
			{
				useCache = true;
				if (FileManager.exists(RunConfig.tempCache))
				{
					try{
						cacheO = FileManager.readJSONFile(RunConfig.tempCache);
						trace("Read cache success");
					}catch (e:*)
					{
						cacheO = {};
					}
				}else
				{
					cacheO = {};
				}
			}
			isCacheChanged = false;
		}
		public function getFile(filePath:String):String
		{
			if (!useCache) return FileManager.readTxtFile(filePath);
			if (cacheO[filePath]) return cacheO[filePath];
			isCacheChanged = true;
			cacheO[filePath] = FileManager.readTxtFile(filePath);
			trace("readFile:",filePath)
			return cacheO[filePath];
		}
		public function getStockData(filePath:String):StockData
		{
			if (cacheO[filePath]) return cacheO[filePath];
			isCacheChanged = true;
			var data:String;
			data = FileManager.readTxtFile(filePath);
			var tStockName:String;
			tStockName = FileManager.getFileName(filePath);
			var stockData:StockData;
			stockData = new StockData();
			stockData.init(data);
			if(useCache)
			cacheO[filePath] = stockData;
			trace("readStockData:",filePath);
			return stockData;
		}
		public function dealCache():void
		{
			if (useCache && isCacheChanged)
			{
				trace("saveCache");
				FileManager.createJSONFile(RunConfig.tempCache, cacheO);
				trace("saveCache success");
			}
		}
		public function workInits():void
		{
			
		}
		public function workEnd():void
		{
			
		}
		public function workDir(path:String):void {
			var fileList:Array;
			
			fileList = FileTools.getFileList(path);
			var i:int, len:int;
			len = fileList.length;
			for (i = 0; i < len; i++) {
				//trace("file:", fileList[i]);
				analyserAFile(fileList[i]);
			}
		}
		
		public function analyserAFile(path:String):void {
			trace("work:", path);
			var data:String;
			data = getFile(path);
			
			var tStockName:String;
			tStockName = FileManager.getFileName(path);
			var stockData:StockData;
			stockData = new StockData();
			stockData.stockName = tStockName;
			stockData.init(data);
			
			//var stockData:StockData;
			//stockData = getStockData(path);
			doAnalyse(stockData);
		}
		
		public function doAnalyse(stockData:StockData):void
		{
			
		}
	}

}