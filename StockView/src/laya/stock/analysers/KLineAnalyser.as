package laya.stock.analysers 
{
	import laya.math.DataUtils;
	import laya.math.GraphicUtils;
	import laya.utils.Utils;
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class KLineAnalyser extends AnalyserBase
	{
		public var leftLimit:int=10;
		public var rightLimit:int = 25;
		public var buyMinUnder:int = 3;
		
		public function KLineAnalyser() 
		{
			
		}
		
		
		override public function initParamKeys():void 
		{
			paramkeys = ["leftLimit","rightLimit","buyMinUnder"];
		}
		
		
	
		override public function analyseWork():void
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
			for (i = 0; i < len; i++)
			{
				tData = maxList[i];
				if ((tData["highR"] > rightLimit)&&tData["highL"] > leftLimit)
				{
					maxs.push(i);
				}
				if ((tData["lowR"] > rightLimit)&&tData["lowL"] > leftLimit)
				{
					mins.push(i);
				}
			}
			len = mins.length;
			var preData:Object;
			var tUnderCount:int;
			var minUnders:Array;
			minUnders = [];
			var underIs:Array;
			underIs = [];
			var tUnders:Array;
			var buys:Array;
			buys = [];
			for (i = 1; i < len; i++)
			{
				preData = dataList[mins[i - 1]];
				tData = dataList[mins[i]];
				tUnders=hasUnders(mins[i - 1], preData["low"], mins[i], tData["low"], mins[i - 1], mins[i], dataList);
				tUnderCount = tUnders.length;
				if (tUnderCount > 0)
				{
					minUnders.push([tUnderCount, mins[i - 1], mins[i]]);
					underIs = Utils.concatArray(underIs, tUnders);
				}
				if (tUnderCount > buyMinUnder)
				{
					buys.push([tData["date"] + ":Buy",mins[i]]);
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
			resultData["underPoints"] = underIs;
			resultData["buys"] = buys;
		}
		override public function getDrawCmds():Array
		{
			var rst:Array;
			rst = [];
			rst.push(["drawPointsLine",[ resultData["maxs"], "high", -20]]);
			rst.push(["drawPointsLine",[ resultData["mins"], "low", 20]]);
			rst.push(["drawPoints", [resultData["underPoints"], "low", 3, "#ffff00"]]);
			rst.push(["drawTexts", [resultData["buys"], "low", 30, "#00ff00",true,"#00ff00"]]);
			return rst;
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

		public function hasUnders(x0:Number, y0:Number, x1:Number, y1:Number,startI:int,endI:int,datas:Array):Array
		{
			var resultArr:Array = [];
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

					resultArr.push(i);
					rst++;
				}
			}
			return resultArr;
		}
	}

}