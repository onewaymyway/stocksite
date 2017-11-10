package laya.stock.backtest 
{
	import laya.math.ArrayMethods;
	import laya.stock.backtest.sellers.SellerBase;
	import laya.stock.backtest.sellers.SellTools;
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
		public var sell:Number;
		public var sellDay:int;
		
		public function get sellRate():Number
		{
			return (sell - buy) / buy;
		}
		
		public function get ifSellWin():int
		{
			return sellRate > 0?1:0;
		}
		
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

		public function ifWin(key:String):int
		{
			return this[key] > 0?1:0;
		}
		
		public function rateX(key:String):Number
		{
			return (this[key] - buy) / buy;
		}
		
		public function winX(key:String, value:Number):int
		{
			return this[key] > value?1:0;
		}
		
		public static function sum(dataList:Array, key:String, value:Number,funName:String="winX"):Number
		{
			var rst:Number;
			rst = 0;
			var i:int, len:int;
			len = dataList.length;
			var tInfo:BackTestInfo;
			for (i = 0; i < len; i++)
			{
				tInfo = dataList[i];
				rst += tInfo[funName](key, value);
			}
			return rst;
		}
		public static function getStaticInfo(dataList:Array, buyI:int,maxDay:int=15,seller:SellerBase):Object
		{
			var priceBuy:Number;
			priceBuy = dataList[buyI]["high"];
			var priceHigh:Number;
			priceHigh = StockTools.getHighInDays(buyI+1, maxDay, dataList)||priceBuy;
			var priceLow:Number;
			priceLow = StockTools.getLowInDays(buyI+1, maxDay, dataList)||priceBuy;
			var rst:BackTestInfo;
			rst = new BackTestInfo();
			rst.buy = priceBuy;
			rst.high = priceHigh;
			rst.low = priceLow;
			if (seller)
			{
				rst.sell = seller.sell(dataList, buyI + 1, priceBuy);
				rst.sellDay = seller.sellDay;
			}
			
			//rst.sell = SellTools.sellSimple(dataList, buyI + 1, priceBuy,maxDay, -0.2, 0.4, -0.1);
			return rst;
		}
		
		public static function getStaticInfoOfBuyList(buyList:Array):Object
		{
			var buyCount:int;
			buyCount = buyList.length;
			var rst:Object;
			rst = { };
			rst.buyTime = buyCount;
			rst.exp = ArrayMethods.sumKey(buyList, "exp") / buyCount;
			rst.win = ArrayMethods.sumKey(buyList, "winRate") / buyCount;
			
			
			rst.lose=ArrayMethods.sumKey(buyList, "loseRate") / buyCount;
			rst.winTime = ArrayMethods.sumKey(buyList, "ifWin");
			rst.winRate = ArrayMethods.sumKey(buyList, "ifWin") / buyCount;
			
			var keyList:Array;
			keyList = [5, 10, 15, 20, 25, 30, 35, 40,45,50,55];
			var i:int;
			var len:int;
			len = keyList.length;
			var tNum:int;
			for (i = 0; i < len; i++)
			{
				tNum = keyList[i];
				rst["win" + tNum + "Time"] = sum(buyList, "winRate", tNum * 0.01);
				rst["win" + tNum + "Rate"] = rst["win" + tNum + "Time"] / buyCount;
			}
			
			for (i = 0; i < len; i++)
			{
				tNum = keyList[i];
				rst["swin" + tNum + "Time"] = sum(buyList, "sellRate", tNum * 0.01);
				rst["swin" + tNum + "Rate"] = rst["swin" + tNum + "Time"] / buyCount;
			}
			
			rst.swin=ArrayMethods.sumKey(buyList, "sellRate") / buyCount;
			rst.swinTime = ArrayMethods.sumKey(buyList, "ifSellWin");
			rst.swinRate = ArrayMethods.sumKey(buyList, "ifSellWin") / buyCount;
			rst.sSellDay = ArrayMethods.sumKey(buyList, "sellDay") / buyCount;
			rst.yearRate = (rst.swin / rst.sSellDay) * 240;

			return rst;
			
		}
	}

}