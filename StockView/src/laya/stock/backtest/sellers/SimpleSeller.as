package laya.stock.backtest.sellers {
	import laya.math.ArrayMethods;
	import laya.stock.StockTools;
	
	/**
	 * ...
	 * @author ww
	 */
	public class SimpleSeller extends SellerBase {
		
		public function SimpleSeller() {
		
		}
		//public var dataList:Array;
		//public var startIndex:int; 
		//public var buyPrice:Number;
		/**
		 * 止损比例
		 */
		public var loseSell:Number = -0.05;
		/**
		 * 止赢比例
		 */
		public var winSell:Number = 0.2;
		/**
		 * 是否启动回撤卖出
		 */
		public var sellByBack:Boolean = false;
		/**
		 * 回撤卖出比例
		 */
		public var backSell:Number = -0.1;
		/**
		 * 最大交易日
		 */
		public var maxDay:int = 20;
		/**
		 * 当前价
		 */
		private var tPrice:Number;
		/**
		 * 最高价
		 */
		private var tHigh:Number;
		
		/**
		 * 当前最大成交量
		 */
		private var curMaxVolume:Number;
		
		/**
		 * 当前最大涨幅
		 */
		private var tMaxDayRate:Number;
		/**
		 * 当前最小涨幅
		 */
		private var tMinDayRate:Number;
		/**
		 * 是否向下缺口卖出
		 */
		public var sellByDownBreak:Boolean = false;
		/**
		 * 成交量下跌单日跌幅保护
		 */
		public var downPriceRateLimit:Number = -0.01;
		/**
		 * 是否启用成交量下跌卖出
		 */
		public var sellByDownVolume:Boolean = false;
		/**
		 * 是否启用单日跌幅卖出
		 */
		public var sellByOneDown:Boolean = false;
		/**
		 * 单日最大跌幅限制
		 */
		public var oneDownLimit:Number = -0.05;
		/**
		 * 是否启用成交量回撤卖出
		 */
		public var sellByVolumeRateDown:Boolean = false;
		/**
		 * 成交量下跌比例限制
		 */
		public var downVolumeRateLimit:Number = 0.5;
		/**
		 * 是否启用5日线上方不卖出
		 */
		public var enalble5DayProtected:Boolean = false;
		/**
		 * 五日线保护比例
		 */
		public var min5DayRate:Number = 0.99;
		/**
		 * 是否启用连续下跌卖出
		 */
		public var sellByDaysDown:Boolean = false;
		/**
		 * 连续下跌卖出天数
		 */
		public var daysDownLimit:int = 4;
		/**
		 * 是否启用低于五日线卖出
		 */
		public var sell5DayDanger:Boolean = false;
		/**
		 * 低于五日线卖出连续
		 */
		public var DayDangerDays:int = 3;
		/**
		 * 低于五日线比例
		 */
		public var min5DayDangerRate:Number = 1;
		
		override public function doSell():Number {
			if (!dataList[startIndex])
				return buyPrice;
			var i:int, len:int;
			len = dataList.length;
			var tStockInfo:Object;
			tHigh = buyPrice;
			var tRst:Number;
			var preDayPrice:Number;
			var tDayRate:Number;
			var upStopPrice:Number;
			var downStopPrice:Number;
			sellDay = 0;
			curMaxVolume = dataList[startIndex]["volume"];
			var preTopPoints:Array;
			preTopPoints = StockTools.findTopPoints(dataList, startIndex - 100, startIndex - 1, 6, 6, true);
			var lastTop:Number = -1;
			if (preTopPoints.length > 0) {
				lastTop = preTopPoints[preTopPoints.length - 1];
			}
			var preBreakTopFailIndex:int = -1;
			for (i = startIndex; i < len; i++) {
				tStockInfo = dataList[i];
				sellDay++;
				preDayPrice = dataList[i - 1]["close"];
				
				tPrice = tStockInfo["open"];
				tDayRate = tPrice / preDayPrice;
				
				if (Math.abs(tDayRate - 1) < 0.098) {
					
					if (sellByDownBreak) {
						if (isDownBreak(dataList, i)) {
							sellReason = "downBreak";
							return tPrice;
						}
					}
					if (sellByOneDown) {
						if (JudgeOneDown(dataList, i))
							return tPrice;
					}
					if (sellDay >= maxDay) {
						sellReason = "maxDayLimit";
						return tPrice;
					}
					tRst = doJudge();
					if (tRst > 0)
						return tRst;
				}
				
				//tPrice = tStockInfo["high"];
				//tRst=doJudge();
				//if (tRst > 0) return tRst;
				//
				//tPrice = tStockInfo["low"];
				//tRst=doJudge();
				//if (tRst > 0) return tRst;
				
				tPrice = tStockInfo["close"];
				tDayRate = tPrice / preDayPrice;
				if (Math.abs(tDayRate - 1) > 0.098)
					continue;
				//if (StockTools.getContinueDownCount(dataList, i, "high") >= 2) {
				//if (StockTools.getStockKeyRateAtDay(dataList, i, "close") < 1) {
				//sellReason = "ContinueDown";
				//return tPrice;
				//}
				//
				//}
				
				//if (preBreakTopFailIndex == i - 1)
				//{
					//if (tDayRate < 1)
					//{
						//sellReason = "downAfterBreakTop";
						//return tPrice;
					//}
				//}
				if (lastTop > 0) {
					if (dataList[i]["high"] > lastTop) {
						if(preBreakTopFailIndex<0)
						preBreakTopFailIndex = i;
					}
				}
				if (StockTools.getStockKeyRateAtDay(dataList, i, "volume") > 1.1) {
					if (StockTools.getStockKeyRateAtDay(dataList, i, "close") < 0.96) {
						sellReason = "volumeAgPrice";
						return tPrice;
					}
				}
				//if (StockTools.isDownTrendAtDay(dataList, i))
				//{
				//sellReason = "DownTrendAtDay";
				//return tPrice;
				//}
				//if (dataList[i]["close"] < dataList[i]["open"])
				//{
				//if (tPrice > buyPrice)
				//{
				//sellReason = "close<open";
				//return tPrice;
				//}
				//}
				//if (StockTools.getStockRateAtDay(dataList, i) - 1 < -0.06)
				//{
				//sellReason = "< -0.06";
				//return tPrice;
				//}
				//if (StockTools.isAttackUpFailAtDay(dataList, i))
				//{
				//sellReason = "attackFail";
				//return tPrice;
				//}
				//if (StockTools.isTopConer(dataList, i))
				//{
				//sellReason = "TopConer";
				//return tPrice;
				//}
				
				if (sell5DayDanger) {
					if (is5DayLineDanger(dataList, i)) {
						sellReason = "5DayDanger";
						return tPrice;
					}
				}
				
				//if (sellByOneDown) {
				//if (JudgeOneDown(dataList, i))
				//return tPrice;
				//}
				
				//if (JudgeOneDown(dataList, i))
				//{
				//
				//}
				
				if (enalble5DayProtected) {
					if (isHighThen5DayLine(dataList, i, tPrice))
						continue;
				}
				
				if (StockTools.isDownBreakContainAtDay(dataList, i)) {
					sellReason = "DownBreakContain";
					//trace("DownBreakContain");
					return tPrice;
				}
				
				//if (StockTools.getStockFallDownPartRate(dataList, i - 1) < 0.33) 
				//{
				//if (StockTools.getStockKeyRateAtDay(dataList, i, "close") < 0.99)
				//{
				//sellReason = "Fall&<0.99";
				//return tPrice;
				//}
				//}
				
				if (sellByDaysDown) {
					if (isDaysDown(dataList, i)) {
						sellReason = "Day3Down";
						return tPrice;
					}
				}
				if (sellByOneDown) {
					if (JudgeOneDown(dataList, i))
						return tPrice;
				}
				
				if (sellByDownVolume) {
					if (JudgeDownVolume(dataList, i))
						return tPrice;
				}
				tRst = doJudge();
				if (tRst > 0)
					return tRst;
			}
			return tPrice;
		}
		
		public function isDownBreak(dataList:Array, index:int):Boolean {
			if (!dataList[index - 1])
				return false;
			var preLow:Number;
			preLow = dataList[index - 1]["low"];
			if (tPrice < preLow) {
				return true;
			}
			return false;
		}
		
		public function isDaysDown(dataList:Array, index:int):Boolean {
			var i:int, len:int;
			len = daysDownLimit;
			var tChange:Number;
			for (i = 0; i < len; i++) {
				tChange = StockTools.getChangePriceAtDay(dataList, index - 1 - i);
				if (tChange < 0)
					return true;
			}
			return false;
		}
		
		public function is5DayLineDanger(dataList:Array, index:int, offset:int = -1):Boolean {
			if (StockTools.getStockRateAtDay(dataList, index) > 1) {
				return false;
			}
			if (StockTools.getStockBounceUpPartRate(dataList, index) > 0.6) {
				return false;
			}
			var average:Number;
			var i:int, len:int;
			len = DayDangerDays;
			var tIndex:int;
			for (i = 0; i < len; i++) {
				tIndex = index - i;
				average = get5DayLine(dataList, tIndex, offset);
				if (average <= 0)
					continue;
				if (dataList[tIndex]["close"] > average * min5DayDangerRate) {
					return false;
				}
			}
			
			return true;
		}
		
		public function get5DayLine(dataList:Array, index:int, offset:int = -1):Number {
			return StockTools.getDayLineAtDay(dataList, index, 5, offset);
			//if (index == 0)
			//return 0;
			//var startI:int;
			//startI = index - 5;
			//if (startI < 0)
			//startI = 0;
			//var average:Number;
			//average = ArrayMethods.averageKey(dataList, "close", startI, index - 1);
			//return average;
		}
		
		public function isHighThen5DayLine(dataList:Array, index:int, tPrice:Number, offset:int = -1):Boolean {
			if (index == 0)
				return true;
			var average:Number;
			average = get5DayLine(dataList, index, offset);
			return tPrice / average > min5DayRate;
		}
		
		public function JudgeOneDown(dataList:Array, index:int):Boolean {
			if (index < 1)
				return false;
			var prePrice:Number;
			prePrice = dataList[index - 1]["close"];
			var curRate:Number;
			curRate = (tPrice - prePrice) / prePrice;
			if (curRate < oneDownLimit) {
				sellReason = "priceDown:" + StockTools.getGoodPercent(curRate) + "%" + tPrice;
				return true;
			}
			return false;
		}
		
		public function JudgeDownVolume(dataList:Array, index:int):Boolean {
			
			var curVolume:Number;
			curVolume = dataList[index]["volume"];
			var curVolumeRate:Number;
			curVolumeRate = curVolume / curMaxVolume;
			if (curVolume > curMaxVolume)
				curMaxVolume = curVolume;
			
			var isDown:Boolean;
			isDown = ArrayMethods.isDowns(dataList, "volume", index - 2, index);
			var prePrice:Number;
			prePrice = dataList[index - 2]["close"];
			var curPrice:Number;
			curPrice = dataList[index]["close"];
			var curOpen:Number;
			curOpen = dataList[index]["open"];
			if (curPrice > curOpen)
				return false;
			if (curPrice > dataList[index - 1]["close"])
				return false;
			
			if (sellByVolumeRateDown) {
				if (curVolumeRate < downVolumeRateLimit) {
					sellReason = "volumeRateDown:" + StockTools.getGoodPercent(curVolumeRate) + "%";
					return true;
				}
			}
			var priceRate:Number;
			curPrice = dataList[index]["low"];
			priceRate = (curPrice - prePrice) / prePrice;
			if (priceRate > downPriceRateLimit)
				return false;
			if (isDown) {
				sellReason = "volume3down";
			}
			return isDown;
		}
		
		public function doJudge():Number {
			if (tPrice > tHigh)
				tHigh = tPrice;
			var tRate:Number;
			tRate = tPrice / buyPrice - 1;
			
			if (tRate > winSell) {
				sellReason = "rate>winSell";
				return tPrice;
			}
			if (tRate < loseSell) {
				sellReason = "rate<loseSell";
				return tPrice;
			}
			
			if (sellByBack) {
				var dRate:Number;
				dRate = tPrice / tHigh - 1;
				if (dRate < backSell) {
					return tPrice;
				}
			}
			
			return 0;
		}
	}

}