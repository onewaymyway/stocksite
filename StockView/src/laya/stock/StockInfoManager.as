package laya.stock 
{
	/**
	 * ...
	 * @author ww
	 */
	public class StockInfoManager 
	{
		
		public function StockInfoManager() 
		{
			
		}
		private static var _stockList:Array;
		private static var _stockInfoDic:Object = { };
		public static function setStockList(stockList:Array):void
		{
			_stockList = stockList;
			var i:int, len:int;
			len = stockList.length;
			var tStockO:Object;
			var tCode:String;
			for (i = 0; i < len; i++)
			{
				tStockO = stockList[i];
				tCode = tStockO.code;
				tCode = StockTools.getPureStock(tCode);
				_stockInfoDic[tCode] = tStockO;
			}
		}
		public static function getStockInfo(stock:String):Object
		{
			return _stockInfoDic[StockTools.getPureStock(stock)];
		}
		
		public static function getStockAvgTrendSign(stock:String,price:Number):String
		{
			var tStockO:Object;
			tStockO = getStockInfo(stock);
			if (!tStockO||!tStockO.averageO) return "~";
			var tAvgs:Array;
			tAvgs = tStockO.averageO.avgs;
			if (!tAvgs) return "~";
			var i:int, len:int;
			len = tAvgs.length;
			var curCount:int;
			curCount = 0;
			for (i = 0; i < len; i++)
			{
				if (price >= tAvgs[i]) curCount++;
			}
			var rst:String;
			rst = "~";
			if (StockTools.isSameTrend(tAvgs, true)) rst = "↗";
			if (StockTools.isSameTrend(tAvgs, false)) rst = "↘";
			rst += ""+curCount;
			return rst;
		}
		
		
	}

}