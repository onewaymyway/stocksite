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
	public class AverageVolumeTrader extends Trader {
		public var maxDay:int = 30;
		public var averageAnalyser:AverageLineAnalyser;
		
		public function AverageVolumeTrader() {
			super();
			averageAnalyser = new AverageLineAnalyser();
			seller = new SimpleSeller();
			seller.loseSell = -0.05;
			seller.winSell = 0.1;
			seller.backSell = -0.1;
			seller.maxDay = maxDay;
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
					
					tryBuyAt(buyI, stockDataList, delayBuy);
					
				}
			}
		}
		public var maxRate:Number = 0.04;
		public var minRate:Number = 0.00;
		public var preMaxRate:Number = 0.05;
		public var preMaxSumRate:Number = 0.10;
		public var preMaxDays:int = 3;
		public var priceDays:int = 3;
		public var maxDaysRate:Number = 0.1;
		public var minDaysRate:Number = -0.1;
		public var longVolume:int = 5;
		public var shortVolume:int = 2;
		public var minVolumeRate:Number = 0.5;
		public var maxVolumeRate:Number = 20;
		public var minMyVolumeRate:Number = 0.7;
		public var maxCurVolumeRate:Number = 1.5;
		
		public var delayBuy:Boolean = false;
		
		private static var _tempDataO:Object = {};
		
		public function isPreDaysOK(dataList:Array, buyI:int):Boolean {
			var i:int, len:int;
			len = preMaxDays;
			var preDayRate:Number;
			var sumRate:Number;
			sumRate = 0;
			for (i = 0; i < len; i++) {
				preDayRate = StockTools.getStockRateAtDay(dataList, buyI - 1 - i);
				
				if (preDayRate > 0) {
					sumRate += (preDayRate - 1);
					if ((preDayRate - 1) > preMaxRate)
						return false;
				}
			}
			if (sumRate > preMaxSumRate) {
				return false;
			}
			return true;
		}
		
		public function tryBuyAt(buyI:int, stockDataList:Array, delay:Boolean = false):void {
			//if (StockTools.isDownTrendAtDay(stockDataList, buyI)) {
				//return;
			//}
			if (delay) {
				buyI++;
				if (!stockDataList[buyI])
					return;
				delay = false;
				if (StockTools.isDownTrendAtDay(stockDataList, buyI)) {
					return;
				}
			}
			if (StockTools.getStockFallDownPartRate(stockDataList, buyI)<0.22)
			{
				return;
			}
			var prePrice:Number;
			if (!stockDataList[buyI - 1])
				return;
			prePrice = stockDataList[buyI - 1]["close"];
			var curPrice:Number;
			curPrice = stockDataList[buyI]["close"];
			var curRate:Number;
			curRate = (curPrice - prePrice) / prePrice;
			if (curRate > maxRate)
				return;
			if (curRate < minRate)
				return;
			
			var changeRate:Number;
			changeRate = Math.abs((stockDataList[buyI]["open"] - stockDataList[buyI]["close"]) / prePrice);
			if (changeRate > maxRate)
				return;
			if (!isPreDaysOK(stockDataList, buyI)) {
				return;
			}
			if (buyI < longVolume)
				return;
			var preDayI:int;
			preDayI = buyI - priceDays;
			if (preDayI < 0)
				return;
			var dayPrice:Number;
			dayPrice = stockDataList[preDayI]["close"];
			var daysRate:Number;
			daysRate = (curPrice - dayPrice) / dayPrice;
			if (daysRate > maxDaysRate)
				return;
			if (daysRate < minDaysRate)
				return;
			
			if (stockDataList[buyI]["close"] < stockDataList[buyI]["open"])
				return;
			var daysVolume:Number;
			daysVolume = ArrayMethods.averageKey(stockDataList, "volume", buyI - longVolume, buyI);
			var nearVolumes:Number;
			nearVolumes = ArrayMethods.averageKey(stockDataList, "volume", buyI - shortVolume, buyI);
			
			var volumeRate:Number;
			volumeRate = nearVolumes / daysVolume;
			var tVolume:Number;
			tVolume = stockDataList[buyI]["volume"];
			if (tVolume / nearVolumes > maxCurVolumeRate)
				return;
			var maxVolume:Number;
			maxVolume = ArrayMethods.getMax(stockDataList, "volume", buyI - shortVolume, buyI);
			var myVolumeRate:Number;
			myVolumeRate = tVolume / maxVolume;
			
			//trace("volume:",daysVolume,nearVolumes,volumeRate);
			_tempDataO = {};
			_tempDataO["longVolume"] = daysVolume;
			_tempDataO["shortVolume"] = nearVolumes;
			_tempDataO["volumeRate"] = StockTools.getGoodPercent(volumeRate);
			_tempDataO["myVolumeRate"] = StockTools.getGoodPercent(myVolumeRate);
			_tempDataO["curRate"] = curRate;
			if (volumeRate > minVolumeRate && volumeRate < maxVolumeRate && myVolumeRate > minMyVolumeRate) {
				if (delay) {
					
					buyI++;
					if (!stockDataList[buyI])
						return;
					tryBuyAt(buyI, stockDataList);
						//var nextDayRate:Number;
						//nextDayRate = StockTools.getStockRateAtDay(stockDataList, buyI);
						//var nextVoluneRate:Number;
						//nextVoluneRate = StockTools.getStockKeyRateAtDay(stockDataList, buyI, "volume");
						//if (nextDayRate > 0 && nextVoluneRate > 0)
						//{
						//if (nextDayRate < 1 && nextVoluneRate < 1) return;
						//}
//
						//buyStaticAt(buyI, maxDay, seller, _tempDataO);
					
				}
				else {
					buyStaticAt(buyI, maxDay, seller, _tempDataO);
				}
				
			}
		}
	
	}

}