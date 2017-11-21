package laya.stock.backtest.traders {
	import laya.math.ArrayMethods;
	import laya.stock.analysers.AverageLineAnalyser;
	import laya.stock.backtest.sellers.SimpleSeller;
	import laya.stock.backtest.Trader;
	import laya.stock.StockTools;
	
	/**
	 * ...
	 * @author ww
	 */
	public class PropsTrader extends Trader {
		public var maxDay:int = 30;
		public var averageAnalyser:AverageLineAnalyser;
		
		public function PropsTrader() {
			
			super();
			averageAnalyser = new AverageLineAnalyser();
			var mySeller:SimpleSeller;
			mySeller = new SimpleSeller();
			seller = mySeller;
			mySeller.loseSell = -0.2;
			mySeller.winSell = 0.9;
			mySeller.backSell = -0.1;
			mySeller.maxDay = maxDay;
		}
		
		override public function getBuyInfos(onlyLast:Boolean = false):void {
			averageAnalyser.analyser(stockData, 0, -1, false);
			var rstData:Object;
			rstData = averageAnalyser.resultData;
			var buyPoints:Array;
			buyPoints = rstData["buys"];
			if (!buyPoints)
				return;
			var i:int, len:int;
			len = buyPoints.length;
			var buyI:int;
			var posInfo:Array;
			
			var stockDataList:Array;
			stockDataList = stockData.dataList;
			for (i = len - 1; i >= 0; i--) {
				var tBuyArr:Array;
				tBuyArr = buyPoints[i];
				buyI = tBuyArr[1];
				if (buyI) {
					
					tryBuyAt(buyI, stockDataList);
					
				}
			}
		}
		public var longVolume:int = 5;
		public var shortVolume:int = 2;
		public function tryBuyAt(buyI:int, stockDataList:Array, delay:Boolean = false):void {
			
			var dataO:Object;
			dataO = {};
			dataO["isDown"] = StockTools.isDownTrendAtDay(stockDataList, buyI) ? 1 : 0;
			dataO["isUp"] = StockTools.isUpTrendAtDay(stockDataList, buyI) ? 1 : 0;
			var preTopPoints:Array;
			preTopPoints = StockTools.findTopPoints(stockDataList, buyI - 100, buyI, 6, 6, true);
			dataO["topCount"] = preTopPoints.length;
			dataO["lastTop"] = preTopPoints[preTopPoints.length - 1];
			dataO["fallDown"] = StockTools.getStockFallDownPartRate(stockDataList, buyI);
			dataO["bounceUp"] = StockTools.getStockBounceUpPartRate(stockDataList, buyI);
			dataO["noDownRate"] = StockTools.getNoDownUpRateBeforeDay(stockDataList, buyI);
			dataO["continueDownHigh"] = StockTools.getContinueDownCount(stockDataList, buyI, "high");
			dataO["continueDownLow"] = StockTools.getContinueDownCount(stockDataList, buyI, "low");
			dataO["ChangeDownDays"] = StockTools.getChangeDownDays(stockDataList, buyI, 5);
			dataO["DayLineAngle"] = StockTools.getDayLineAngleDay(stockDataList, buyI, 5, 0, "close");
			dataO["DayLineAngleDownCount"] = StockTools.getContinueDayLineAngleDownCount(stockDataList, buyI, 5, 0, "close");
			dataO["DayLineRate"]=StockTools.getDayLineRateAtDay(stockDataList, buyI, 5, -1, "close");
			
			var prePrice:Number;
			prePrice = stockDataList[buyI - 1]["close"];
			
			dataO["changeRate"] = Math.abs((stockDataList[buyI]["open"] - stockDataList[buyI]["close"]) / prePrice);
			dataO["curRate"] = StockTools.getStockRateAtDay(stockDataList, buyI);
			dataO["bodyRate"] = StockTools.getBodyRate(stockDataList, buyI);

			
			if (buyI < longVolume)
				return;
			var daysVolume:Number;
			daysVolume = ArrayMethods.averageKey(stockDataList, "volume", buyI - longVolume, buyI);
			var nearVolumes:Number;
			nearVolumes = ArrayMethods.averageKey(stockDataList, "volume", buyI - shortVolume, buyI);
			
			var volumeRate:Number;
			volumeRate = nearVolumes / daysVolume;
			dataO["volumeRate"] = volumeRate;
			var maxVolume:Number;
			maxVolume = ArrayMethods.getMax(stockDataList, "volume", buyI - shortVolume, buyI);
			var myVolumeRate:Number;
			myVolumeRate = stockDataList[buyI]["volume"] / maxVolume;
			dataO["myVolumeRate"] = myVolumeRate;

			buyStaticAt(buyI, maxDay, seller, dataO);
				
				
			
		}
	}

}