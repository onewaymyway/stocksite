package laya.stock.backtest.traders 
{
	import laya.math.DataUtils;
	import laya.stock.analysers.AverageLineAnalyser;
	import laya.stock.backtest.sellers.SimpleSeller;
	import laya.stock.backtest.Trader;
	
	/**
	 * ...
	 * @author ww
	 */
	public class AverageTrader extends Trader 
	{
		public var averageAnalyser:AverageLineAnalyser;
		public function AverageTrader() 
		{
			super();
			averageAnalyser = new AverageLineAnalyser();
			var seller:SimpleSeller;
			seller = new SimpleSeller();
			seller.loseSell = -0.2;
			seller.winSell = 0.9;
			seller.backSell = -0.1;
			seller.maxDay = maxDay;
		}
		override public function reset():void 
		{
			super.reset();
		}
		public var minBuyLose:Number = -0.20;
		public var maxBuyLose:Number = -0.5;
		public var minBuyExp:Number = 0.4;
		public var posDayCount:int = 90;
		public var maxDay:int = 30;
		override public function runTest():void 
		{
			averageAnalyser.analyser(stockData, 0, -1, false);
			var rstData:Object;
			rstData = averageAnalyser.resultData;
			var buyPoints:Array;
			buyPoints = rstData["buys"];
			if (!buyPoints) return;
			var i:int, len:int;
			len = buyPoints.length;
			var buyI:int;
			var posInfo:Array;
			
			
			for (i = 0; i < len; i++)
			{
				var tBuyArr:Array;
				tBuyArr = buyPoints[i];
				buyI = tBuyArr[1];
				if (buyI)
				{
					//[loseRate,winRate,exp]
					
					posInfo = DataUtils.getWinLoseInfo(stockData.dataList, posDayCount, buyI);
					if (posInfo[2] > minBuyExp&&posInfo[0]<minBuyLose&&posInfo[0]>maxBuyLose)
					{
						buyStaticAt(tBuyArr[1],maxDay,seller);
					}
					
				}
			}
		}
		
		public function getBuyInfos(onlyLast:Boolean=false):void 
		{
			averageAnalyser.analyser(stockData, 0, -1, false);
			var rstData:Object;
			rstData = averageAnalyser.resultData;
			var buyPoints:Array;
			buyPoints = rstData["buys"];
			if (!buyPoints) return;
			var i:int, len:int;
			len = buyPoints.length;
			var buyI:int;
			var posInfo:Array;
			
			
			for (i = len-1; i >=0; i--)
			{
				var tBuyArr:Array;
				tBuyArr = buyPoints[i];
				buyI = tBuyArr[1];
				if (buyI)
				{
					//[loseRate,winRate,exp]
					
					posInfo = DataUtils.getWinLoseInfo(stockData.dataList, posDayCount, buyI);
					if (posInfo[2] > minBuyExp&&posInfo[0]<minBuyLose&&posInfo[0]>maxBuyLose)
					{
						buyStaticAt(tBuyArr[1], maxDay, seller);
						if (onlyLast) return;
					}
					
				}
			}
		}
		
		override public function runAllBuy():void 
		{
			getBuyInfos(false);
		}
		override public function runLastBuy():void 
		{
			getBuyInfos(true);
		}
	}

}