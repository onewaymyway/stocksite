package laya.stock.analysers.lines 
{
	import laya.math.DataUtils;
	import laya.math.ValueTools;
	import laya.stock.analysers.AnalyserBase;
	
	/**
	 * ...
	 * @author ww
	 */
	public class AverageLine extends AnalyserBase 
	{
		
		public function AverageLine() 
		{
			super();
			
		}
		public var days:String = "12,26";
		public var colors:String = "#00ffff,#ffff00";
		public var priceType:String = "close";
		override public function initParamKeys():void 
		{
			paramkeys = ["days","colors","priceType"];
		}
		override public function analyseWork():void 
		{
			doAverages();
		}
		public function getDays():Array
		{
			var daysArr:Array;
			daysArr = days.split(",");
			var i:int, len:int;
			var rst:Array;
			rst = [];
			len = daysArr.length;
			var tDay:int;
			for (i = 0; i < len; i++)
			{
				tDay = Math.floor(ValueTools.mParseFloat(daysArr[i]));
				if (tDay > 0)
				{
					rst.push(tDay);
				}
			}
			return rst;
		}
		public function doAverages():void
		{
			var avgs:Array;
			avgs = [];
			var daysList:Array;
			daysList = getDays();
			var i:int, len:int;
			len = daysList.length;
			var colorList:Array;
			colorList = colors.split(",");
			for (i = 0; i < len; i++)
			{
				avgs.push(getAverageData(daysList[i],colorList[i%colorList.length]));
			}
			
			resultData["averages"] = avgs;
		}
		private function getAverageData(dayCount:int,color:String):Array
		{
			var avList:Array;
			avList = DataUtils.getAverage(disDataList, dayCount, priceType);
			var avPoints:Array
			avPoints = [];
			var i:int, len:int;
			len = avList.length;
			for (i = 0; i < len; i++)
			{
				avPoints.push([i,avList[i]]);
			}
			return [avPoints,color];
		}
		override public function getDrawCmds():Array 
		{
			var rst:Array;
			rst = [];
			var avgs:Array;
			avgs = resultData["averages"];
			var i:int, len:int;
			len = avgs.length;
			for (i = 0; i < len; i++)
			{
				rst.push(["drawLines",avgs[i]]);
			}
			
			return rst;
		}
	}

}