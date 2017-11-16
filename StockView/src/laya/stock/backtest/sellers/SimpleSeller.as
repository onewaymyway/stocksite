package laya.stock.backtest.sellers 
{
	import laya.math.ArrayMethods;
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
		public function JudgeOneDown(dataList:Array,index:int):Boolean
		{
			if (index < 1) return false;
			var prePrice:Number;
			prePrice = dataList[index-1]["close"];
			var curRate:Number;
			curRate = (tPrice-prePrice) / prePrice;
			if (curRate < oneDownLimit) return true;
			return false;
		}
		public function JudgeDownVolume(dataList:Array,index:int):Boolean
		{
			var curVolume:Number;
			curVolume = dataList[index]["volume"];
			var curVolumeRate:Number;
			curVolumeRate = curVolume / curMaxVolume;
			if (curVolume > curMaxVolume) curMaxVolume = curVolume;
			if (sellByVolumeRateDown)
			{
				if (curVolumeRate < downVolumeRateLimit)
				{
					return true;
				}
			}
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
			var priceRate:Number;
			priceRate = (curPrice-prePrice) / prePrice;
			if (priceRate > downPriceRateLimit) return false;
			return isDown;
		}
		public function doJudge():Number
		{
			if (tPrice > tHigh) tHigh = tPrice;
			var tRate:Number;
			tRate = tPrice / buyPrice-1;
			if (tRate > winSell)
			{
				return tPrice;
			}
			if (tRate < loseSell)
			{
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