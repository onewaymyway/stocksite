package laya.stock.analysers.lines 
{
	import laya.math.DataUtils;
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
		public var dayCount:int = 10;
		public var color:String = "#00ff00";
		override public function initParamKeys():void 
		{
			paramkeys = ["dayCount","color"];
		}
		override public function analyseWork():void 
		{
			doAverages();
		}
		public function doAverages():void
		{
			var avList:Array;
			avList = DataUtils.getAverage(disDataList, dayCount, "close");
			var avPoints:Array
			avPoints = [];
			var i:int, len:int;
			len = avList.length;
			for (i = 0; i < len; i++)
			{
				avPoints.push([i,avList[i]]);
			}
			resultData["averages"] = avPoints;
		}
		override public function getDrawCmds():Array 
		{
			var rst:Array;
			rst = [];
			rst.push(["drawLines",[resultData["averages"],color]]);
			return rst;
		}
	}

}