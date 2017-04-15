package laya.stock.analysers 
{
	import laya.math.DataUtils;
	/**
	 * ...
	 * @author ww
	 */
	public class BounceAnalyser extends AnalyserBase 
	{
		
		public function BounceAnalyser() 
		{
			super();
			
		}
		public var rightMin:int = 15;
		public var leftMin:int = 15;
		override public function initParamKeys():void 
		{
			paramkeys = ["leftMin","rightMin"];
		}
		override public function analyseWork():void {
			myCalculate();
		}
		public function myCalculate():void {
			var maxList:Array;
			maxList = DataUtils.getMaxInfo(disDataList, false);
			var maxs:Array;
			var mins:Array;
			maxs = DataUtils.getMaxs(maxList, leftMin, rightMin);
			mins = DataUtils.getMins(maxList, leftMin, rightMin);
			
			resultData["mins"] = mins;
			resultData["maxs"] = maxs;
			
			var tState = 0;
			var tUpCount:int = 0;
			var tDownCount:int = 0;
			var i:int, len:int;
			len = mins.length;
			
			
		}
		
		override public function getDrawCmds():Array {
			var rst:Array;
			rst = [];
			
			//rst.push(["drawPoints", [resultData["upBreaks"], "low", 3, "#ffff00"]]);
			//rst.push(["drawPoints", [resultData["downBreaks"], "high", 3, "#00ff00"]]);
			//rst.push(["drawTexts", [resultData["buys"], "low", 30, "#00ff00", true, "#00ff00"]]);
			
			rst.push(["drawPointsLine", [resultData["maxs"], "high", -20]]);
			rst.push(["drawPointsLine", [resultData["mins"], "low", 20]]);
			
			return rst;
		}
	}

}