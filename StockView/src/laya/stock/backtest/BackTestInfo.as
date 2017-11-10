package laya.stock.backtest 
{
	import laya.math.ArrayMethods;
	import laya.stock.StockTools;
	/**
	 * ...
	 * @author ww
	 */
	public class BackTestInfo 
	{
		public function BackTestInfo() 
		{
			
		}
		public var buy:Number;
		public var high:Number;
		public var low:Number;
		
		public function get loseRate():Number
		{
			return (low - buy) / buy;
		}
		public function get winRate():Number
		{
			return (high - buy) / buy;
		}
		public function get exp():int
		{
			return winRate + 2 * loseRate;
		}
		public function get ifWin():int
		{
			return exp > 0?1:0;
		}
		public static function getStaticInfo(dataList:Array, buyI:int,len:int=15):Object
		{
			var priceBuy:Number;
			priceBuy = dataList[buyI]["high"];
			var priceHigh:Number;
			priceHigh = StockTools.getHighInDays(buyI, len, dataList);
			var priceLow:Number;
			priceLow = StockTools.getLowInDays(buyI, len, dataList);
			var rst:BackTestInfo;
			rst = new BackTestInfo();
			rst.buy = priceBuy;
			rst.high = priceHigh;
			rst.low = priceLow;
			return rst;
		}
		
		public static function getStaticInfoOfBuyList(buyList:Array):Object
		{
			var len:int;
			len = buyList.length;
			var rst:Object;
			rst = { };
			rst.buyTime = len;
			rst.exp = ArrayMethods.sumKey(buyList, "exp") / len;
			rst.win = ArrayMethods.sumKey(buyList, "winRate") / len;
			rst.lose=ArrayMethods.sumKey(buyList, "loseRate") / len;
			rst.winTime = ArrayMethods.sumKey(buyList, "ifWin");
			rst.winRate = ArrayMethods.sumKey(buyList, "ifWin") / len;
			return rst;
			
		}
	}

}