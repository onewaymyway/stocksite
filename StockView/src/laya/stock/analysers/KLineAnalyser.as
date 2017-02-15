package laya.stock.analysers 
{
	import laya.math.DataUtils;
	import laya.math.GraphicUtils;
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class KLineAnalyser 
	{
		
		public function KLineAnalyser() 
		{
			
		}
		public var stockData:StockData;
		public var dataList:Array;
		public var disDataList:Array;
		public var resultData:Object;
		public function analyser(stockData:StockData):void
		{
			this.stockData = stockData;
			dataList = stockData.dataList;
			analyserData();
		}
		public function initByStrData(data:String):void
		{
			var stockData:StockData;
			stockData = new StockData();
			stockData.init(data);
			analyser(stockData);			
		}
		public function analyserData(start:int = 0, end:int = -1):void
		{
			if (end < start) end = dataList.length - 1;
			disDataList = dataList.slice(start, end);
			resultData = { };
			analyseWork();
		}
		public function analyseWork():void
		{
			workMaxValues();
			drawMaxs();
		}
		public function workMaxValues():void
		{
			var dataList:Array;
			dataList = disDataList;
			var maxI:int;
			maxI = DataUtils.getKeyMaxI(dataList, "high");
			var minI:int;
			minI = DataUtils.getKeyMinI(dataList, "low");
			var xPos:Number;
			resultData["high"] = maxI;
			resultData["low"] = minI;
		}
		public function drawMaxs():void
		{
			var dataList:Array;
			dataList = disDataList;
		    var maxList:Array;
			maxList = DataUtils.getMaxInfo(dataList);
			var i:int, len:int;
			len = maxList.length;
			var tData:Object;
			var mins:Array;
			var maxs:Array;
			mins = [];
			maxs = [];
			var leftLimit:int;
			var rightLimit:int;
			leftLimit = 10;
			rightLimit = 25;
			for (i = 0; i < len; i++)
			{
				tData = maxList[i];
				if ((tData["highL"] > rightLimit)&&tData["highR"] > leftLimit)
				{
					maxs.push(i);
				}
				if ((tData["lowL"] > rightLimit)&&tData["lowR"] > leftLimit)
				{
					mins.push(i);
				}
			}
			len = mins.length;
			var preData:Object;
			var tUnderCount:int;
			var minUnders:Array;
			minUnders = [];
			for (i = 1; i < len; i++)
			{
				preData = dataList[mins[i - 1]];
				tData = dataList[mins[i]];
				tUnderCount=hasUnders(mins[i - 1], preData["low"], mins[i], tData["low"], mins[i - 1], mins[i], dataList);
				if (tUnderCount > 0)
				{
					minUnders.push([tUnderCount,mins[i - 1],mins[i]]);
				}
			}
			
			len = maxs.length;
			for (i = 1; i < len; i++)
			{
				preData = dataList[maxs[i - 1]];
				tData = dataList[maxs[i]];
			}
			resultData["mins"] = mins;
			resultData["maxs"] = maxs;
			resultData["minUnders"] = minUnders;
		}
		public function getLastUnderLine(minCount:int = 3):Object
		{
			if (!resultData) return null;
			var minUnders:Array;
			minUnders = resultData["minUnders"];
			var i:int, len:int;
			len = minUnders.length;
			var tData:Array;
			for (i = len-1; i >=0; i--)
			{
				tData = minUnders[i];
				if (tData[0] >= minCount)
				{
					return tData;
				}
			}
			return null;
		}
		public function getDataByI(i:int):Object
		{
			return disDataList[i];
		}
		public function hasUnders(x0:Number, y0:Number, x1:Number, y1:Number,startI:int,endI:int,datas:Array):int
		{
			var i:int, len:int;
			var tData:Object;
			var tX:Number;
			var tY:Number;
			var rst:int;
			rst = 0;
			for (i = startI + 1; i < endI; i++)
			{
				tData = datas[i];
				tX = i;
				tY = tData["low"];
				if (GraphicUtils.pointOfLine(tX, tY, x0, y0, x1, y1) > 0)
				{
					rst++;
				}
			}
			return rst;
		}
	}

}