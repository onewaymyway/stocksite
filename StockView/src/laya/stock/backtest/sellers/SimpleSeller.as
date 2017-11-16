package laya.stock.backtest.sellers 
{
	import laya.math.ArrayMethods;
	import laya.stock.StockTools;
	/**
	 * ...
	 * @author ww
	 */
	public class SimpleSeller extends SellerBase
	{
		
		public function SimpleSeller() 
		{
			
		}
		//public var dataList:Array;
		//public var startIndex:int; 
		//public var buyPrice:Number;
		public var loseSell:Number = -0.05;
		public var winSell:Number = 0.2;
		public var backSell:Number = -0.1;
		public var maxDay:int = 20;
		private var tPrice:Number;
		private	var tHigh:Number;
		public var downPriceRateLimit:Number = -0.01;
		public var sellByDownVolume:Boolean = false;
		public var sellByOneDown:Boolean = false;
		public var oneDownLimit:Number = -0.05;
		public var sellByVolumeRateDown:Boolean = false;
		public var downVolumeRateLimit:Number = 0.5;
		public var enalble5DayProtected:Boolean = false;
		public var min5DayRate:Number = 0.99;
		private var curMaxVolume:Number;
		override public function doSell():Number 
		{
			if (!dataList[startIndex]) return buyPrice;
			var i:int, len:int;
			len = dataList.length;
			var tStockInfo:Object;
			tHigh = buyPrice;
			var tRst:Number;
			sellDay = 0;
			curMaxVolume = dataList[startIndex]["volume"];
			for (i = startIndex; i < len; i++)
			{
				tStockInfo = dataList[i];
				sellDay++;
				tPrice = tStockInfo["open"];
				if (sellByOneDown)
				{
					if (JudgeOneDown(dataList, i)) return tPrice;
				}
				if (sellDay >= maxDay) return tPrice;
				tRst=doJudge();
				if (tRst > 0) return tRst;
				
				//tPrice = tStockInfo["high"];
				//tRst=doJudge();
				//if (tRst > 0) return tRst;
				//
				//tPrice = tStockInfo["low"];
				//tRst=doJudge();
				//if (tRst > 0) return tRst;
				
				tPrice = tStockInfo["close"];
				if (enalble5DayProtected)
				{
					if (isHighThen5DayLine(dataList, i, tPrice)) continue;
				}
				
				if (sellByOneDown)
				{
					if (JudgeOneDown(dataList, i)) return tPrice;
				}
				
				if (sellByDownVolume)
				{
					if (JudgeDownVolume(dataList,i)) return tPrice;
				}
				tRst=doJudge();
				if (tRst > 0) return tRst;
			}
			return tPrice;
		}
		public function isHighThen5DayLine(dataList:Array, index:int,tPrice:Number):Boolean
		{
			if (index == 0) return true;
			var startI:int;
			startI = index - 5;
			if (startI < 0) startI = 0;
			var average:Number;
			average = ArrayMethods.averageKey(dataList, "close", index - 5, index - 1);
			return tPrice / average>min5DayRate;
		}
		public function JudgeOneDown(dataList:Array,index:int):Boolean
		{
			if (index < 1) return false;
			var prePrice:Number;
			prePrice = dataList[index-1]["close"];
			var curRate:Number;
			curRate = (tPrice-prePrice) / prePrice;
			if (curRate < oneDownLimit)
			{
				sellReason = "priceDown:"+StockTools.getGoodPercent(curRate)+"%"+tPrice;
				return true;
			} 
			return false;
		}
		public function JudgeDownVolume(dataList:Array,index:int):Boolean
		{
			
			var curVolume:Number;
			curVolume = dataList[index]["volume"];
			var curVolumeRate:Number;
			curVolumeRate = curVolume / curMaxVolume;
			if (curVolume > curMaxVolume) curMaxVolume = curVolume;
			
			var isDown:Boolean;
			isDown = ArrayMethods.isDowns(dataList, "volume", index - 2, index);
			var prePrice:Number;
			prePrice = dataList[index - 2]["close"];
			var curPrice:Number;
			curPrice = dataList[index]["close"];
			var curOpen:Number;
			curOpen = dataList[index]["open"];
			if (curPrice > curOpen) return false;
			if (curPrice > dataList[index - 1]["close"]) return false;
			
			if (sellByVolumeRateDown)
			{
				if (curVolumeRate < downVolumeRateLimit)
				{
					sellReason = "volumeRateDown:"+StockTools.getGoodPercent(curVolumeRate)+"%";
					return true;
				}
			}
			var priceRate:Number;
			curPrice = dataList[index]["low"];
			priceRate = (curPrice-prePrice) / prePrice;
			if (priceRate > downPriceRateLimit) return false;
			if (isDown)
			{
				sellReason = "volume3down";
			}
			return isDown;
		}
		public function doJudge():Number
		{
			if (tPrice > tHigh) tHigh = tPrice;
			var tRate:Number;
			tRate = tPrice / buyPrice-1;
			if (tRate > winSell)
			{
				sellReason = "rate>winSell";
				return tPrice;
			}
			if (tRate < loseSell)
			{
				sellReason = "rate<loseSell";
				return tPrice;
			}
			//var dRate:Number;
			//dRate = tPrice / tHigh - 1;
			//if (dRate < backSell)
			//{
				//return tPrice;
			//}
			
			return 0;
		}
	}

}