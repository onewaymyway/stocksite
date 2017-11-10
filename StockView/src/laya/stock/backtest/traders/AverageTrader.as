package laya.stock.backtest.traders 
{
	import laya.stock.analysers.AverageLineAnalyser;
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
		}
		override public function reset():void 
		{
			super.reset();
		}
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
			for (i = 0; i < len; i++)
			{
				var tBuyArr:Array;
				tBuyArr = buyPoints[i];
				if (tBuyArr[1])
				{
					buyStaticAt(tBuyArr[1]);
				}
			}
		}
	}

}