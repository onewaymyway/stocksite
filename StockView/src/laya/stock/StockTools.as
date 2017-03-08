package laya.stock 
{
	/**
	 * ...
	 * @author ww
	 */
	public class StockTools 
	{
		
		public function StockTools() 
		{
			
		}
		
		public static var highDays:Array = [7,15,30,45,60];
		public static function getBuyStaticInfos(buyI:int, dataList:Array, rst:Object):void
		{
			var priceLast:Number;
		    var len:int;
			var i:int;
			len = dataList.length;
			priceLast = dataList[len - 1]["close"];
			var priceBuy:Number;
			priceBuy = dataList[buyI]["high"];
			rst.changePercent = (priceLast - priceBuy) / priceBuy;
			var priceHigh:Number;
			priceHigh = -1;
			for (i = buyI + 1; i < len; i++)
			{
				if (dataList[i]["high"] > priceHigh)
				{
					priceHigh = dataList[i]["high"];
				}
			}
			rst.highPercent = (priceHigh - priceBuy) / priceBuy;
			
			len = highDays.length;
			var tDayCount:int;
			for (i = 0; i < len; i++)
			{
				tDayCount = highDays[i];
				priceHigh = getHighInDays(buyI + 1, tDayCount, dataList);
				rst["high"+tDayCount]=(priceHigh - priceBuy) / priceBuy;
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