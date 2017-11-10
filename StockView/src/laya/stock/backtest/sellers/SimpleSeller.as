package laya.stock.backtest.sellers 
{
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
		override public function doSell():Number 
		{
			if (!dataList[startIndex]) return buyPrice;
			var i:int, len:int;
			len = dataList.length;
			var tStockInfo:Object;
			tHigh = buyPrice;
			var tRst:Number;
			sellDay = 0;
			for (i = startIndex; i < len; i++)
			{
				tStockInfo = dataList[i];
				sellDay++;
				tPrice = tStockInfo["open"];
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
				tRst=doJudge();
				if (tRst > 0) return tRst;
			}
			return tPrice;
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