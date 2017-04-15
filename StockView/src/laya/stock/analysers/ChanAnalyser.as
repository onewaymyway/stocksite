package laya.stock.analysers {
	import laya.math.DataUtils;
	import laya.stock.analysers.chan.ChanKBar;
	import laya.stock.analysers.chan.ChanKList;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ChanAnalyser extends AnalyserBase {
		
		public function ChanAnalyser() {
			super();
		
		}
		public var ifShowIndex:int = 0;
		public var showRaw:int = 0;
		
		override public function initParamKeys():void {
			paramkeys = ["ifShowIndex", "showRaw"];
		}
		
		override public function analyseWork():void {
			myCalculate();
		}
		
		public function getMegerLines(chanList:ChanKList):void {
			var cPointList:Array;
			cPointList = chanList.kList;
			var i:int, len:int;
			len = cPointList.length;
			var tops:Array;
			var bottoms:Array;
			tops = [];
			bottoms = [];
			var tDataO:ChanKBar;
			for (i = 0; i < len; i++) {
				tDataO = cPointList[i];
				tops.push(ChanKList.getIndex(tDataO.topO));
				bottoms.push(ChanKList.getIndex(tDataO.bottomO));
				
			}
			resultData["tops"] = tops;
			resultData["bottoms"] = bottoms;
		}
		
		public function myCalculate():void {
			
			if (ifShowIndex)
				showIndexs();
			var cPointList:Array;
			cPointList = [];
			var chanList:ChanKList;
			chanList = new ChanKList();
			
			chanList.setDataList(disDataList);
			
			if (showRaw) {
				getMegerLines(chanList);
				return;
			}
			else {
				
			}
			
			cPointList = chanList.findTopBottoms();
			var i:int, len:int;
			len = cPointList.length;
			var tops:Array;
			var bottoms:Array;
			tops = [];
			bottoms = [];
			var tType:String;
			var tArr:Array;
			var tDataO:ChanKBar;
			
			var points:Array;
			points = [];
			for (i = 0; i < len; i++) {
				tArr = cPointList[i];
				tType = tArr[0];
				tDataO = tArr[1];
				if (tType != DataUtils.K_Unknow) {
					if (tType == DataUtils.K_Top) {
						tops.push(ChanKList.getIndex(tDataO.topO));
						points.push([ChanKList.getIndex(tDataO.topO),"high"]);
					}
					if (tType == DataUtils.K_Bottom) {
						bottoms.push(ChanKList.getIndex(tDataO.bottomO));
						points.push([ChanKList.getIndex(tDataO.bottomO),"low"]);
					}
				}
			}
			resultData["tops"] = tops;
			resultData["bottoms"] = bottoms;
			resultData["points"] = points;
		}
		
		override public function getDrawCmds():Array {
			var rst:Array;
			rst = [];
			
			//rst.push(["drawPoints", [resultData["bottoms"], "low", 3, "#ffff00"]]);
			//rst.push(["drawPoints", [resultData["tops"], "high", 3, "#00ff00"]]);
			rst.push(["drawPointsLineEx", [resultData["points"]]]);
			if (ifShowIndex)
				rst.push(["drawTexts", [resultData["indexs"], "low", 30, "#00ff00", true, "#00ff00"]]);
			
			//rst.push(["drawPointsLine", [resultData["maxs"], "high", -20]]);
			//rst.push(["drawPointsLine", [resultData["mins"], "low", 20]]);
			
			return rst;
		}
	}

}