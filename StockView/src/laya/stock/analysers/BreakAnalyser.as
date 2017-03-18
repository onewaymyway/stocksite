package laya.stock.analysers {
	import laya.math.ArrayMethods;
	import laya.math.DataUtils;
	
	/**
	 * ...
	 * @author ww
	 */
	public class BreakAnalyser extends AnalyserBase {
		
		public function BreakAnalyser() {

		}
		public var rightMin:int = 5;
		public var leftMin:int = 15;
		override public function initParamKeys():void 
		{
			paramkeys = ["leftMin","rightMin"];
		}
		override public function analyseWork():void {
			getBreaks();
		}
		
		public function getBreaks():void {
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
			for (i = 0; i < len; i++) {
				tBreak = breaks[i];
				if (tBreak["type"] == "down") {
					downBreaks.push(tBreak["index"]);
				}
				else {
					upBreaks.push(tBreak["index"]);
				}
			}
			resultData["upBreaks"] = upBreaks;
			resultData["downBreaks"] = downBreaks;
			
			var maxList:Array;
			maxList = DataUtils.getMaxInfo(disDataList, false);
			var maxs:Array;
			var mins:Array;
			maxs = DataUtils.getMaxs(maxList, leftMin, rightMin);
			mins = DataUtils.getMins(maxList, leftMin, rightMin);
			resultData["mins"] = mins;
			resultData["maxs"] = maxs;
			
			var tBreaks:Array;
			tBreaks = downBreaks;
			len = tBreaks.length;
			var buyPoints:Array = [];
			buyPoints = [];
			var buyedDic:Object;
			buyedDic = {};
			var tI:int;
			var tBuy:int;
			var tData:Object;
			for (i = 0; i < len; i++) {
				tI = tBreaks[i];
				var preMax:int;
				var maxPos:Array;
				maxPos = ArrayMethods.findPos(tI, maxs);
				
				if (maxPos.length == 2 && maxPos[0] >= 0) {
					var minPos:Array;
					minPos = ArrayMethods.findPos(tI, mins);
					if (minPos.length == 2 && minPos[1] >= 0) {
						tBuy = mins[minPos[1]] + rightMin;
						tBreak =  disDataList[maxs[maxPos[0]]];
						tData = disDataList[tBuy];
						if (tData["high"] < tBreak["low"]*0.8 ) {
							if (!buyedDic[tBuy]) {
								buyedDic[tBuy] = true;
								
								buyPoints.push([tData["date"] + ":Buy", tBuy]);
							}
						}
						
					}
				}
				
			}
			resultData["buys"] = buyPoints;
		}
		
		override public function getDrawCmds():Array {
			var rst:Array;
			rst = [];
			
			//rst.push(["drawPoints", [resultData["upBreaks"], "low", 3, "#ffff00"]]);
			rst.push(["drawPoints", [resultData["downBreaks"], "high", 3, "#00ff00"]]);
			rst.push(["drawTexts", [resultData["buys"], "low", 30, "#00ff00", true, "#00ff00"]]);
			
			rst.push(["drawPointsLine", [resultData["maxs"], "high", -20]]);
			rst.push(["drawPointsLine", [resultData["mins"], "low", 20]]);
			
			return rst;
		}
	}

}