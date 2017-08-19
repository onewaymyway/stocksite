package laya.stock 
{
	import laya.stock.analysers.AnalyserBase;
	import laya.tools.StockJsonP;
	/**
	 * ...
	 * @author ww
	 */
	public class StockTools 
	{
		
		public function StockTools() 
		{
			
		}
		public static function getStockCsvPath(stock:String):String
		{
			var stockUrl:String;
			stockUrl = "https://onewaymyway.github.io/stockdata/stockdatas/" + stock + ".csv";
			//stockUrl = "res/stockdata/" + "002694" + ".csv";
			return stockUrl;
		}
		public static function getAdptStockStr(stock:String):String
		{
			var tChar:String;
			tChar = stock.charAt(0);
			if (tChar == "s") return stock;
			if (stock.charAt(0)=="6")
			{
				return "sh"+stock;
			}
			return "sz" + stock;
		}
		public static function getAdptStockCode(stock:*):String
		{
			return StockJsonP.getAdptStockStr(getStockCode(stock));
		}
		
		public static function getStockCode(stock:*):String {
			if (stock is String)
				return stock;
			return stock.code;
		}
		
		public static function getPureStock(stock:String):String
		{
			if (stock.length > 6)
			{
				stock = stock.substr(2, 6);
			}
			if (stock.length < 6)
			{
				var count:int;
				count = 6 - stock.length;
				var i:int;
				for (i = 0; i < count; i++)
				{
					stock = "0" + stock;
				}
			}
			return stock;
		}
		public static var highDays:Array = [7, 15, 30, 45, 60];
		public static function getGoodPercent(v:Number):Number
		{
			return Math.floor(v * 10000) / 100;
		}
		public static function getGoodPercentList(arr:Array):Array
		{
			var i:int, len:int;
			len = arr.length;
			for (i = 0; i < len; i++)
			{
				arr[i] = getGoodPercent(arr[i]);
			}
			return arr;
		}
		public static function getStockPrice(index:int, type:String, dataList:Array):Number
		{
			return dataList[index][type];
		}
		
		public static function getStockPriceEx(index:int, type:String, analyser:AnalyserBase):Number
		{
			return getStockPrice(index, type, analyser.disDataList);
		}
		
		public static function getBuyStaticInfos(buyI:int, dataList:Array, rst:Object):void
		{
			var priceLast:Number;
		    var len:int;
			var i:int;
			len = dataList.length;
			priceLast = dataList[len - 1]["close"];
			var priceBuy:Number;
			priceBuy = dataList[buyI]["high"];
			rst.changePercent = getGoodPercent((priceLast - priceBuy) / priceBuy);
			var priceHigh:Number;
			priceHigh = -1;
			for (i = buyI + 1; i < len; i++)
			{
				if (dataList[i]["high"] > priceHigh)
				{
					priceHigh = dataList[i]["high"];
				}
			}
			rst.highPercent = getGoodPercent((priceHigh - priceBuy) / priceBuy);
			
			len = highDays.length;
			var tDayCount:int;
			for (i = 0; i < len; i++)
			{
				tDayCount = highDays[i];
				priceHigh = getHighInDays(buyI + 1, tDayCount, dataList);
				rst["high"+tDayCount]=getGoodPercent((priceHigh - priceBuy) / priceBuy);
			}
			
		}
		
		public static function getHighInDays(start:int,days:int, dataList:Array):Number
		{
			var i:int, len:int;
			var priceHigh:Number;
			priceHigh = -1;
			len = days + start;
			if (len > dataList.length) len = dataList.length;
			for (i = start; i < len; i++)
			{
				if (dataList[i]["high"] > priceHigh)
				{
					priceHigh = dataList[i]["high"];
				}
			}
			return priceHigh;
		}
		
		
	}

}