package laya.stock.analysers 
{
	import laya.math.DataUtils;
	/**
	 * ...
	 * @author ww
	 */
	public class BreakAnalyser extends AnalyserBase
	{
		
		public function BreakAnalyser() 
		{
			paramkeys = [];
		}
		override public function analyseWork():void 
		{
			getBreaks();
		}
		public function getBreaks():void
		{
			var breaks:Array;
			breaks = DataUtils.getBreakInfo(disDataList);
			resultData["breaks"] = breaks;
			var i:int, len:int;
			len = breaks.length;
			var upBreaks:Array;
			upBreaks = [];
			var downBreaks:Array;
			downBreaks = [];
			var tBreak:Object;
			for (i = 0; i < len; i++)
			{
				tBreak = breaks[i];
				if (tBreak["type"] == "down")
				{
					downBreaks.push(tBreak["index"]);
				}else
				{
					upBreaks.push(tBreak["index"]);
				}
			}
			resultData["upBreaks"] = upBreaks;
			resultData["downBreaks"] = downBreaks;
		}
		
		override public function getDrawCmds():Array
		{
			var rst:Array;
			rst = [];

			rst.push(["drawPoints", [resultData["upBreaks"], "low", 3, "#ffff00"]]);
			rst.push(["drawPoints", [resultData["downBreaks"], "high", 3, "#00ff00"]]);

			return rst;
		}
	}

}