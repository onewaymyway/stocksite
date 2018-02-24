package laya.stock 
{
	import laya.math.ArrayMethods;
	import laya.stock.analysers.AnalyserBase;
	import laya.tools.StockJsonP;
	/**
	 * ...
	 * @author ww
	 */
	public class StockTools 
	{
		public static var NoticePath:String = "https://onewaymyway.github.io/stocknotice/notices/";
		public static var StockPath:String = "https://onewaymyway.github.io/stockdata/";
		public function StockTools() 
		{
			
		}
		public static function DebugMode():void
		{
			NoticePath = "D:/lovekxy/codes/python/stocknotice.git/trunk/notices/";
			StockPath = "D:/lovekxy/codes/python/stockdata.git/trunk/";
		}
		public static function getStockNoticePath(stock:String):String
		{
			stock = getPureStock(stock);
			var stockUrl:String;
			stockUrl = NoticePath + stock + ".csv";
			//stockUrl = "https://onewaymyway.github.io/stocknotice/notices/" + stock + ".csv";
			//stockUrl = "D:/lovekxy/codes/python/stocknotice.git/trunk/notices/" + stock + ".csv";
			return stockUrl;
		}
		public static function getStockCsvPath(stock:String):String
		{
			var stockUrl:String;
			stockUrl = StockPath +"stockdatas/"+ stock + ".csv";
			//stockUrl = "https://onewaymyway.github.io/stockdata/stockdatas/" + stock + ".csv";
			//stockUrl = "res/stockdata/" + "002694" + ".csv";
			return stockUrl;
		}
		
		public static function getStockPicPath(stock:String):String
		{
			var stockUrl:String;
			stockUrl = StockPath +"smallpics/"+ stock + ".png";
			return stockUrl;
		}
		
		public static function getAdptStockStr(stock:String):String
		{
			var tChar:String;
			tChar = stock.charAt(0);
			if (tChar == "s") return stock;
			if (stock.charAt(0)=="6")
			{
				return "sh"+stock;
			}
			return "sz" + stock;
		}
		public static function getAdptStockCode(stock:*):String
		{
			return StockJsonP.getAdptStockStr(getStockCode(stock));
		}
		
		public static function getStockCode(stock:*):String {
			if (stock is String)
				return stock;
			return stock.code;
		}
		
		public static function getPureStock(stock:String):String
		{
			if (stock.length > 6)
			{
				stock = stock.substr(2, 6);
			}
			if (stock.length < 6)
			{
				var count:int;
				count = 6 - stock.length;
				var i:int;
				for (i = 0; i < count; i++)
				{
					stock = "0" + stock;
				}
			}
			return stock;
		}
		public static var highDays:Array = [7, 15, 30, 45, 60];
		public static function getGoodPercent(v:Number):Number
		{
			return Math.floor(v * 10000) / 100;
		}
		public static function getGoodPercentList(arr:Array):Array
		{
			var i:int, len:int;
			len = arr.length;
			for (i = 0; i < len; i++)
			{
				arr[i] = getGoodPercent(arr[i]);
			}
			return arr;
		}
		public static function getStockPrice(index:int, type:String, dataList:Array):Number
		{
			return dataList[index][type];
		}
		public static function getContinueDownCount(dataList:Array, index:int,key:String="close"):int
		{
			var rst:int;
			rst = 0;
			while (dataList[index - 1] && dataList[index - 1][key] > dataList[index][key])
			{
				index--;
				rst++;
			}
			return rst;
		}
		public static function getStockPriceEx(index:int, type:String, analyser:AnalyserBase):Number
		{
			return getStockPrice(index, type, analyser.disDataList);
		}
		public static function getStockKeyRateAtDay(dataList:Array, index:int, key:String):Number
		{
			if (!dataList[index] || !dataList[index - 1]) return -1;
			return dataList[index][key] / dataList[index - 1][key];
		}
		public static function getStockRateAtDay(dataList:Array, index:int):Number
		{
			if (!dataList[index] || !dataList[index - 1]) return -1;
			return dataList[index]["close"] / dataList[index - 1]["close"];
		}
		public static function getBodyRate(dataList:Array, index:int):Number
		{
			if (!dataList[index]) return -1;
			var tData:Object;
			tData = dataList[index];
			var totalLen:Number;
			totalLen = tData["high"] - tData["low"];
			if (totalLen == 0) return - 1;
			//if (bodyLen * 4 > totalLen) return false;
			var tBLine:Number;
			tBLine = Math.abs(tData["close"]-tData["open"]);
			var tLineRate:Number;
			tLineRate = tBLine / totalLen;
			return tLineRate;
		}
		public static function getStockFallDownPartRate(dataList:Array, index:int):Number
		{
			if (!dataList[index]) return -1;
			var tData:Object;
			tData = dataList[index];
			var totalLen:Number;
			totalLen = tData["high"] - tData["low"];
			if (totalLen == 0) return - 1;
			//if (bodyLen * 4 > totalLen) return false;
			var tBLine:Number;
			tBLine = Math.max(tData["close"], tData["open"]);
			var tLineRate:Number;
			tLineRate = (tBLine-tData["low"]) / totalLen;
			return tLineRate;
		}
		public static function getStockBounceUpPartRate(dataList:Array, index:int):Number
		{
			if (!dataList[index]) return -1;
			var tData:Object;
			tData = dataList[index];
			var totalLen:Number;
			totalLen = tData["high"] - tData["low"];
			if (totalLen == 0) return - 1;
			//if (bodyLen * 4 > totalLen) return false;
			var tBLine:Number;
			tBLine = Math.min(tData["close"], tData["open"]);
			var tLineRate:Number;
			tLineRate = (tBLine-tData["low"]) / totalLen;
			return tLineRate;
		}
		public static function isAttackUpFailAtDay(dataList:Array, index:int):Boolean
		{
			if (!dataList[index]) return false;
			var tData:Object;
			tData = dataList[index];
			var bodyLen:Number;
			bodyLen = Math.abs((tData["close"] - tData["open"]));
			var totalLen:Number;
			totalLen = tData["high"] - tData["low"];
			//if (bodyLen * 4 > totalLen) return false;
			var tBLine:Number;
			tBLine = Math.max(tData["close"], tData["open"]);
			var tLineRate:Number;
			tLineRate = (tBLine-tData["low"]) / totalLen;
			return tLineRate < 0.25;
		}
		public static function isDownTrendAtDay(dataList:Array, index:int):Boolean
		{
			if (!dataList[index - 1]) return false;
			var preData:Object;
			var tData:Object;
			preData = dataList[index - 1];
			tData = dataList[index];
			return tData["high"] < preData["high"] && tData["low"] < preData["low"];
		}
		public static function getDayLineRateAtDay(dataList:Array, index:int, dayCount:int = 5, offset:int = -1, key:String = "close"):Number
		{
			var preValue:Number;
			preValue = getDayLineAtDay(dataList, index - 1, dayCount, offset, key);
			var curValue:Number;
			curValue = getDayLineAtDay(dataList, index, dayCount, offset, key);
			if (preValue == 0) return 0;
			return  curValue / preValue;
		}
		public static function getContinueDayLineAngleDownCount(dataList:Array, index:int, dayCount:int = 5, offset:int = -1, key:String="close"):int
		{
			var rst:int;
			rst = 0;
			while (dataList[index - 1] && getDayLineAngleDay(dataList,index-1,dayCount,offset,key) > getDayLineAngleDay(dataList,index,dayCount,offset,key))
			{
				index--;
				rst++;
			}
			return rst;
		}
		public static function getDayLineAngleDay(dataList:Array, index:int, dayCount:int = 5, offset:int = -1, key:String = "close"):Number
		{
			var preValue:Number;
			preValue = getDayLineAtDay(dataList, index - 1, dayCount, offset, key);
			var curValue:Number;
			curValue = getDayLineAtDay(dataList, index, dayCount, offset, key);
			if (preValue == 0) return 0;
			var dValue:Number;
			dValue = curValue-preValue;
			var angle:Number;
			angle = Math.atan2(dValue, 1);
			angle = angle*180 / Math.PI;
			return angle;
		}
		public static function getDayLineAtDay(dataList:Array, index:int,dayCount:int=5,offset:int=-1,key:String="close"):Number {
			if (index == 0)
				return 0;
			var startI:int;
			startI = index - dayCount+1+offset;
			if (startI < 0)
				startI = 0;
			var average:Number;
			average = ArrayMethods.averageKey(dataList, key, startI, index +offset);
			return average;
		}
		public static function isUpTrendAtDay(dataList:Array, index:int):Boolean
		{
			if (!dataList[index - 1]) return false;
			var preData:Object;
			var tData:Object;
			preData = dataList[index - 1];
			tData = dataList[index];
			return tData["high"] > preData["high"] && tData["low"] > preData["low"];
		}
		public static function isTopConer(dataList:Array, index:int):Boolean
		{
			if (!dataList[index - 2]) return false;
			return isUpTrendAtDay(dataList, index - 1) && isDownTrendAtDay(dataList, index);
		}
		public static function isDownBreakContainAtDay(dataList:Array, index:int):Boolean
		{
			//trace("isDownBreakContainAtDay");
			if (!dataList[index - 1]) return false;
			if (!isContainedByBefore(dataList,index - 1)) return false;
			//trace("contained",dataList[index]["low"] < dataList[index - 1]["low"]);
			return dataList[index]["close"] < dataList[index - 2]["low"];
			
		}
		public static function isContainedByBefore(dataList:Array, index:int):Boolean
		{
			if (!dataList[index - 1]) return false;
			var preData:Object;
			var tData:Object;
			preData = dataList[index - 1];
			tData = dataList[index];
			//trace("isContaine:",tData["high"] , preData["high"] , tData["low"] , preData["low"]);
			return tData["high"] < preData["high"] && tData["low"] > preData["low"];
		}
		public static function getUpStopValue(price:Number):Number
		{
			return Math.round(price * 1.1 * 1000) / 1000;
		}
		public static function getDownStopValue(price:Number):Number
		{
			return Math.round(price * 0.9 * 1000) / 1000;
		}
		public static function getNoDownUpRateBeforeDay(dataList:Array, index:int):Number
		{
			var curHigh:Number;
			curHigh = dataList[index]["high"];
			var dayCount:int;
			dayCount = 0;
			var tLow:Number = 0;
			while (dataList[index - 1] && (dataList[index - 1]["low"]<dataList[index]["low"]||getChangePriceAtDay(dataList, index - 1) > 0 || getStockRateAtDay(dataList, index - 1) > 1))
			{
				index--;
				dayCount++;
				if (tLow <= 0 || dataList[index]["low"] < tLow)
				{
					tLow=dataList[index]["low"]
				}
			}
			if (tLow <= 0) return 0;
			
			return curHigh/tLow;
		}
		public static function findTopPoints(dataList:Array, start:int, end:int, leftLimit:int=6, rightLimit:int=6,onlyPrice:Boolean=false):Array
		{
			var rst:Array;
			rst = [];
			var i:int, len:int;
			if (start < 0) start = 0;
			for (i = start+leftLimit; i < end-rightLimit; i++)
			{
				if (isTopPoint(dataList, i, leftLimit, rightLimit))
				{
					if (onlyPrice)
					{
						rst.push(dataList[i]["high"]);
					}else
					{
						rst.push({"index":i,"price":dataList[i]["high"]});
					}
					
				}
			}
			return rst;
		}
		public static function isTopPoint(dataList:Array, index:int, leftLimit:int, rightLimit:int):Boolean
		{
			var curValue:Number;
			
			var i:int, len:int;
			
			var tIndex:int;
			var tValue:Number;
			curValue = dataList[index]["high"];
			len = leftLimit;
			for (i = 0; i < len; i++)
			{
				tIndex = index - i - 1;
				tValue = dataList[tIndex]["high"];
				if (tValue > curValue) return false;
			}
			
			len = rightLimit;
			for (i = 0; i < len; i++)
			{
				tIndex = index + i + 1;
				tValue = dataList[tIndex]["high"];
				if (tValue > curValue) return false;
			}
			return true;
		}
		
		public static function getChangePriceAtDay(dataList:Array, index:int):Number
		{
			return dataList[index]["close"] - dataList[index]["open"];
		}
		public static function getChangeDownDays(dataList:Array, index:int, len:int):int
		{
			var rst:Number;
			rst = 0;
			var i:int;
			var tData:Object;
			for (i = 0; i < len; i++)
			{
				tData = dataList[index - i];
				if (tData)
				{
					if (tData["close"] < tData["open"])
					{
						rst++;
					}
				}
			}
			return rst;
		}
		public static function getBuyStaticInfos(buyI:int, dataList:Array, rst:Object):void
		{
			var priceLast:Number;
		    var len:int;
			var i:int;
			len = dataList.length;
			priceLast = dataList[len - 1]["close"];
			var priceBuy:Number;
			priceBuy = dataList[buyI]["high"];
			rst.changePercent = getGoodPercent((priceLast - priceBuy) / priceBuy);
			var priceHigh:Number;
			priceHigh = -1;
			for (i = buyI + 1; i < len; i++)
			{
				if (dataList[i]["high"] > priceHigh)
				{
					priceHigh = dataList[i]["high"];
				}
			}
			rst.highPercent = getGoodPercent((priceHigh - priceBuy) / priceBuy);
			
			len = highDays.length;
			var tDayCount:int;
			for (i = 0; i < len; i++)
			{
				tDayCount = highDays[i];
				priceHigh = getHighInDays(buyI + 1, tDayCount, dataList)||priceBuy;
				rst["high"+tDayCount]=getGoodPercent((priceHigh - priceBuy) / priceBuy);
			}
			
		}
		
		public static function getHighInDays(start:int,days:int, dataList:Array):Number
		{
			if (!dataList[start]) return 0;
			var i:int, len:int;
			var priceHigh:Number;
			priceHigh = dataList[start]["low"];
			len = days + start;
			if (len > dataList.length) len = dataList.length;
			for (i = start; i < len; i++)
			{
				if (dataList[i]["high"] > priceHigh)
				{
					priceHigh = dataList[i]["high"];
				}
			}
			return priceHigh;
		}
		
		public static function getLowInDays(start:int,days:int, dataList:Array):Number
		{
			if (!dataList[start]) return 0;
			var i:int, len:int;
			var priceLow:Number;
			priceLow = dataList[start]["low"];
			len = days + start;
			if (len > dataList.length) len = dataList.length;
			for (i = start; i < len; i++)
			{
				if (dataList[i]["low"] < priceLow)
				{
					priceLow = dataList[i]["low"];
				}
			}
			return priceLow;
		}
		
		public static function isSameTrend(dataList:Array, up:Boolean = true):Boolean
		{
			var i:int, len:int;
			len = dataList.length;
			for (i = 1; i < len; i++)
			{
				if (up && dataList[i] > dataList[i - 1]) return false;
				if ((!up) && dataList[i] < dataList[i - 1]) return false;
			}
			return true;
		}
		
	}

}