package laya.math 
{
	/**
	 * ...
	 * @author ww
	 */
	public class DataUtils 
	{
		
		public function DataUtils() 
		{
			
		}
		public static function mParseFloat(v:*):Number
		{
			var rst:Number;
			rst = parseFloat(v);
			if (isNaN(rst)) return 0;
			return rst;
		}
		
		public static function getKeyMax(datas:Array, key:String):Number
		{
			var i:int, len:int;
			len = datas.length;
			var tV:Number;
			tV = mParseFloat(datas[0][key]);
			for (i = 0; i < len; i++)
			{
				if (mParseFloat(datas[i][key]) > tV)
				{
					tV = mParseFloat(datas[i][key]);
				}
			}
			return tV;
		}
		public static function getKeyMaxI(datas:Array, key:String):Number
		{
			var i:int, len:int;
			len = datas.length;
			var tV:Number;
			tV = mParseFloat(datas[0][key]);
			var tI:Number = 0;
			for (i = 0; i < len; i++)
			{
				if (mParseFloat(datas[i][key]) > tV)
				{
					tV = mParseFloat(datas[i][key]);
					tI = i;
				}
			}
			return tI;
		}
		
		public static function getKeyMin(datas:Array, key:String):Number
		{
			var i:int, len:int;
			len = datas.length;
			var tV:Number;
			tV = mParseFloat(datas[0][key]);
			for (i = 0; i < len; i++)
			{
				if (mParseFloat(datas[i][key]) < tV)
				{
					tV = mParseFloat(datas[i][key]);
				}
			}
			return tV;
		}
		public static function getKeyMinI(datas:Array, key:String):Number
		{
			var i:int, len:int;
			len = datas.length;
			var tV:Number;
			tV = mParseFloat(datas[0][key]);
			var tI:Number = 0;
			for (i = 0; i < len; i++)
			{
				if (mParseFloat(datas[i][key]) < tV)
				{
					tV = mParseFloat(datas[i][key]);
					tI = i;
				}
			}
			return tI;
		}
		public static function getBreakInfo(datas:Array):Array
		{
			var rst:Array;
			rst = [];
			var i:int, len:int;
			len = datas.length;
			if (len < 1) return rst;
			var preData:Object;
			var tData:Object;
			preData = datas[0];
			var tBreak:Object;
			for (i = 1; i < len; i++)
			{
				tData = datas[i];
				if (tData["high"] < preData["low"])
				{
					tBreak = { };
					tBreak["index"] = i;
					tBreak["type"] = "down";
					rst.push(tBreak);
				}
				if (tData["low"] > preData["high"])
				{
					tBreak = { };
					tBreak["index"] = i;
					tBreak["type"] = "up";
					rst.push(tBreak);
				}
				preData = tData;
			}
			
			return rst;
		}
		public static function getMaxInfo(datas:Array,allowEdge:Boolean=true):Array
		{
			var rst:Array;
			rst = [];
			var i:int, len:int;
			len = datas.length;
			for (i = 0; i < len; i++)
			{
				rst.push(getIMaxInfo(i, datas,allowEdge));
			}
			return rst;
		}
		public static function getMaxs(maxList:Array, leftLimit:int=15, rightLimit:int=10):Array
		{
			var i:int, len:int;
			len = maxList.length;
			var tData:Object;
			var rst:Array;
			rst = [];
			for (i = 0; i < len; i++)
			{
				tData = maxList[i];
				if ((tData["highL"] > leftLimit)&&tData["highR"] > rightLimit)
				{
					rst.push(i);
				}
			}
			return rst;
		}
		
		public static function getMins(maxList:Array,leftLimit:int=15, rightLimit:int=10):Array
		{
			var i:int, len:int;
			len = maxList.length;
			var tData:Object;
			var mins:Array;
			mins = [];
			for (i = 0; i < len; i++)
			{
				tData = maxList[i];
				if ((tData["lowL"] > leftLimit)&&tData["lowR"] > rightLimit)
				{
					mins.push(i);
				}
			}
			return mins;
		}
		public static function getIMaxInfo(index:int,datas:Array,allowEdge:Boolean=true):Object
		{
			var i:int, len:int;
			len = datas.length;
			var mValue:Number;
			mValue = datas[index]["high"];
			var rst:Object;
			rst = { };
			
			i = index;
			while (i > 0 && datas[i - 1]["high"] < mValue) i--;
			if (i==0&&allowEdge)
			{
				i = -99;
			}
			rst["highL"] = index - i;
			
			i = index;
			while (i < len - 1 && datas[i + 1]["high"] < mValue) i++;
			if (i==len-1&&allowEdge)
			{
				i = len+99;
			}
			rst["highR"] = i - index;
			
			rst["high"] = Math.min(rst["highL"], rst["highR"]);
			rst["highM"] = Math.max(rst["highL"],rst["highR"]);
			
			mValue = datas[index]["low"];
			i = index;
			while (i > 0 && datas[i - 1]["low"] > mValue) i--;
			if (i==0&&allowEdge)
			{
				i = -99;
			}
			rst["lowL"] = index - i;
			
			i = index;
			while (i < len - 1 && datas[i + 1]["low"] > mValue) i++;
			if (i==len-1&&allowEdge)
			{
				i = len+99;
			}
			rst["lowR"] = i - index;
			rst["low"] = Math.min(rst["lowL"], rst["lowR"]);
			rst["lowM"] = Math.max(rst["lowL"], rst["lowR"]);
			
			return rst;
		}
		public static function isBigThenBefore(index:int, dataList:Array, priceSign:String="close",count:int = 3):Boolean
		{
			var tPrice:Number;
			tPrice = dataList[index][priceSign];
			var tI:int;
			var i:int, len:int;
			len = count;
			for (i = 1; i <= len; i++)
			{
				tI = index - i;
				if (!dataList[tI] || dataList[tI][priceSign] > tPrice) return false;
			}
			
			return true;
			
		}
		public static function findFirstUp(startI:int,dataList:Array, priceSign:String="close", minLen:int = 3):int
		{
			var i:int, len:int;
			len = dataList.length;
			for (i = startI + 1; i < len; i++)
			{
				if (isBigThenBefore(i, dataList, priceSign, minLen)) return i;
			}
			return -1;
		}
		
		public static function getAverage(dataList:Array,dayCount:int=5, priceSign:String = "close"):Array
		{
			var i:int, len:int;
			len = dataList.length;
			var rst:Array;
			rst = [];
			var tSum:Number;
			if (!dataList.length) return rst;
			tSum = dayCount * dataList[0][priceSign];
			var preI:int;
			preI = 0;
			var tV:Number;
			for (i = 0; i < len; i++)
			{
				tV = dataList[i][priceSign];
				tSum = tSum - dataList[preI][priceSign];
				tSum += tV;
				rst.push(tSum / dayCount);
				if (i >= dayCount)
				{
					preI++;
				}
				
			}
			return rst;
		}
		
		public static function createGridLineData(start:int, end:int, values:Array):Array
		{
			var rst:Array;
			rst = [];
			var i:int, len:int;
			len = values.length;
			for (i = 0; i < len; i++)
			{
				rst.push([start, values[i]]);
				rst.push([end, values[i]]);
			}
			return rst;
		}
		
		public static function getExpDatas(dataList:Array, dayCount:int, index:int,priceType:String="close"):Number
		{
			if (dataList.length <= index) return 0;
			var i:int, len:int;
			var startI:int;
			startI = index - dayCount;
			if (startI < 0) startI = 0;
			var max:Number;
			var min:Number;
			min = max = dataList[startI][priceType];
			var tValue:Number;
			len = index;
			for (i = startI; i <= len; i++)
			{
				tValue = dataList[i][priceType];
				if (min > tValue) min = tValue;
				if (max < tValue) max = tValue;
			}
			tValue=dataList[index][priceType];
			var loseRate:Number;
			loseRate = (min - tValue) / tValue;
			var winRate:Number;
			winRate = (max - tValue) / tValue;
			var exp:Number;
			exp = winRate+2 * loseRate;
			return exp;
		}
		public static function getMinMaxInfo(dataList:Array, dayCount:int, index:int,priceType:String="close"):Array
		{
			if (dataList.length <= index) return null;
			var i:int, len:int;
			var startI:int;
			startI = index - dayCount;
			if (startI < 0) startI = 0;
			var max:Number;
			var min:Number;
			min = max = dataList[startI][priceType];
			var tValue:Number;
			len = index;
			for (i = startI; i <= len; i++)
			{
				tValue = dataList[i][priceType];
				if (min > tValue) min = tValue;
				if (max < tValue) max = tValue;
			}
			tValue = dataList[index][priceType];
			return [min,max,tValue]
		}
		public static function getWinLoseInfo(dataList:Array, dayCount:int, index:int,priceType:String="close"):Array
		{
			dayCount = ValueTools.mParseFloat(dayCount);
			if (dataList.length <= index) return null;
			var datas:Array;
			datas = getMinMaxInfo(dataList, dayCount, index, priceType);
			if (!datas || datas.length < 3) return null;
			var min:Number, max:Number, tValue:Number;
			min = datas[0];
			max = datas[1];
			tValue = datas[2];
			var loseRate:Number;
			loseRate = (min - tValue) / tValue;
			var winRate:Number;
			winRate = (max - tValue) / tValue;
			var exp:Number;
			exp = winRate+2 * loseRate;
			return [loseRate,winRate,exp]
		}
		
		
		public static const K_Top:String = "top";
		public static const K_Bottom:String = "bottom";
		public static const K_Unknow:String = "unknow";
		public static function getKLineType(dataList:Array, i:int,highSign:String="high",lowSign:String="low"):String
		{
			var preData:Object;
			preData = dataList[i - 1];
			var tData:Object;
			tData = dataList[i];
			var nextData:Object;
			nextData = dataList[i + 1];
			if (!preData || !tData || !nextData) return K_Unknow;
			
			//trace("getKlineType:");
			//trace(preData[lowSign], preData[highSign]);
			//trace(tData[lowSign], tData[highSign]);
			//trace(nextData[lowSign], nextData[highSign]);
			
			if (preData[highSign] < tData[highSign] && preData[lowSign] < tData[lowSign]&&nextData[highSign] < tData[highSign] && nextData[lowSign] < tData[lowSign])
			{
				return K_Top;
			}
			if (preData[highSign] > tData[highSign] && preData[lowSign] > tData[lowSign]&&nextData[highSign] > tData[highSign] && nextData[lowSign] > tData[lowSign])
			{
				return K_Bottom;
			}
			return K_Unknow;
		}
		
		public static function getDistanceRate(arr:Array):Number
		{
			var sum:Number;
			sum = 0;
			var i:int, len:int;
			len = arr.length;
			for (i = 0; i < len; i++)
			{
				sum += arr[i];
			}
			var avg:Number;
			avg = sum / len;
			sum = 0;
			for (i = 0; i < len; i++)
			{
				sum += Math.pow(arr[i]-avg, 2);
			}
			sum = Math.sqrt(sum) / avg;
			return sum;
		}
	}

}