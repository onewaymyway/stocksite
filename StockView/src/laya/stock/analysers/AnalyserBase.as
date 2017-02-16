package laya.stock.analysers 
{
	import laya.math.DataUtils;
	import laya.math.GraphicUtils;
	import laya.utils.Utils;
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class AnalyserBase 
	{
		
		public function AnalyserBase() 
		{
			
		}
		public var stockData:StockData;
		public var dataList:Array;
		public var disDataList:Array;
		public var resultData:Object;
		public var paramkeys:Array;
		
		public function getParam():Object
		{
			var rst:Object;
			if (paramkeys)
			{
				var i:int, len:int;
				len = paramkeys.length;
				var tKey:String;
				for (i = 0; i < len; i++)
				{
					tKey = paramkeys[i];
					rst[tKey] = this[tKey];
				}
			}
			return rst;
		}
		public function analyser(stockData:StockData,start:int = 0, end:int = -1):void
		{
			this.stockData = stockData;
			dataList = stockData.dataList;
			analyserData(start,end);
		}
		public function initByStrData(data:String):void
		{
			var stockData:StockData;
			stockData = new StockData();
			stockData.init(data);
			analyser(stockData);			
		}
		public function analyserData(start:int = 0, end:int = -1):void
		{
			if (end < start) end = dataList.length - 1;
			disDataList = dataList.slice(start, end);
			resultData = { };
			analyseWork();
		}
		public function getDataByI(i:int):Object
		{
			return disDataList[i];
		}
		public function analyseWork():void
		{

		}
		public function getDrawCmds():Array
		{
			return null;
		}
	}

}