package stockcmd 
{
	import laya.stock.analysers.ChanAnalyser;
	import laya.stock.StockTools;
	import nodetools.devices.FileManager;
	import nodetools.devices.FileTools;
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class GreatKLineWorker 
	{
		
		public function GreatKLineWorker() 
		{
			
		}
		public function work():void {
			if (!FileTools.exist(RunConfig.filePath)) {
				trace("file not found:", RunConfig.filePath);
				return;
			}
			analyser = new ChanAnalyser();
			if (FileTools.isDirectory(RunConfig.filePath)) {
				workDir(RunConfig.filePath);
			}
			else {
				analyserAFile(RunConfig.filePath);
			}
		}
		
		private var dirInfos:Array;
		public function workDir(path:String):void {
			dirInfos = [];
			var fileList:Array;
			
			fileList = FileTools.getFileList(path);
			var i:int, len:int;
			len = fileList.length;
			for (i = 0; i < len; i++) {
				//trace("file:", fileList[i]);
				analyserAFile(fileList[i], dirInfos);
			}
		
			var moData:Object;
			moData = { };
			moData.keys = ["code", "start", "end", "rate"];
			moData.data = dirInfos;
			
			FileManager.createJSONFile(RunConfig.outFile, moData);
		}
		
		public var analysers:Array;
		private var analyser:ChanAnalyser;
		public function analyserAFile(path:String, rst:Array = null):void {
			trace("work:", path);
			var data:String;
			data = FileManager.readTxtFile(path);
			
			var tStockName:String;
			tStockName = FileManager.getFileName(path);
			var stockData:StockData;
			stockData = new StockData();
			stockData.init(data);
			if (stockData.dataList.length < 2) return;
			analyser.analyser(stockData,0,-1,true);
			var tResult:Object;
			tResult = analyser.resultData;
			var pointList:Array;
			pointList = tResult["points"];
			var preData:Array;
			var tData:Array;
			var i:int, len:int;
			len = pointList.length;
			
			var upKs:Array = rst;
			for (i = 0; i < len; i++)
			{
				tData = pointList[i];
				if (preData)
				{
					var tIndex:int;
					tIndex = tData[0];
					var tType:String;
					tType = tData[2];
					var preIndex:int;
					preIndex = preData[0];
					if (tType = "high")
					{
						var tPrice:Number;
						var prePrice:Number;
						prePrice = StockTools.getStockPriceEx(preIndex, "low", analyser);
						tPrice = StockTools.getStockPriceEx(tIndex, "high", analyser);
						var rate:Number;
						rate = tPrice / prePrice;
						rate = parseFloat(rate.toFixed(3));
						if (rate> 1.5)
						{
							trace(tStockName, StockTools.getStockPriceEx(preIndex, "date", analyser), StockTools.getStockPriceEx(tIndex, "date", analyser), rate);
							upKs.push([tStockName, StockTools.getStockPriceEx(preIndex, "date", analyser), StockTools.getStockPriceEx(tIndex, "date", analyser), rate]);
						}
					}
				}
				preData = tData;
			}
		
		}
		
	}

}