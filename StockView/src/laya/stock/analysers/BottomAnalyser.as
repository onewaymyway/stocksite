package laya.stock.analysers {
	import laya.math.ArrayMethods;
	import laya.math.DataUtils;
	import laya.stock.models.Trend;
	
	/**
	 * ...
	 * @author ww
	 */
	public class BottomAnalyser extends AnalyserBase {
		
		public function BottomAnalyser() {
			paramkeys = [];
		
		}
		
		override public function analyseWork():void {
			myCalculate();
		}
		
		public function myCalculate():void {
			var rightMin:int;
			rightMin = 5;
			var maxList:Array;
			maxList = DataUtils.getMaxInfo(disDataList, false);
			var maxs:Array;
			var mins:Array;
			maxs = DataUtils.getMaxs(maxList, 15, rightMin);
			mins = DataUtils.getMins(maxList, 15, rightMin);
			
			resultData["mins"] = mins;
			resultData["maxs"] = maxs;
			
			var tState = 0;
			var tUpCount:int = 0;
			var tDownCount:int = 0;
			var i:int, len:int;
			len = mins.length;
			
			var tData:Object;
			var preData:Object;
			
			
			var buys:Array;
			buys = [];
			var tI:int;
			var startDownI:int = -1;
			var startUpI:int = -1;
			var lastDownI:int = -1;
			var lastUpI:int = -1;
			var tDownList:Array = [];
			var tUpList:Array = [];
			var preI:int;
			
			if (len > 0) {
				preI = mins[0];
				preData = disDataList[preI];
			}
			
			var trend:Trend;
			trend = new Trend();
			for (i = 0; i < len; i++) {
				tI = mins[i];
				tData = disDataList[tI];
				tData.index = tI;
				trend.addData(tData);
				if (trend.upList.getIndexLen() > 10 && trend.downList.getIndexLen() > 30)
				{
					buys.push([tData["date"] + ":Buy", tI]);
					trend.clear();
				}
				if (trend.upList.getIndexLen() > trend.downList.getIndexLen())
				{
					trend.clear();
				}
			}
			
			resultData["buys"] = buys;
		}
		
		override public function getDrawCmds():Array {
			var rst:Array;
			rst = [];
			
			//rst.push(["drawPoints", [resultData["upBreaks"], "low", 3, "#ffff00"]]);
			//rst.push(["drawPoints", [resultData["downBreaks"], "high", 3, "#00ff00"]]);
			rst.push(["drawTexts", [resultData["buys"], "low", 30, "#00ff00", true, "#00ff00"]]);
			
			rst.push(["drawPointsLine", [resultData["maxs"], "high", -20]]);
			rst.push(["drawPointsLine", [resultData["mins"], "low", 20]]);
			
			return rst;
		}
	}

}