package laya.stock.analysers.bars {
	import laya.math.DataUtils;
	import laya.stock.analysers.AnalyserBase;
	
	/**
	 * ...
	 * @author ww
	 */
	public class VolumeBar extends AnalyserBase {
		
		public function VolumeBar() {
			super();
		
		}
		public var barHeight:Number = 100;
		public var offY:Number = 0;
		public var color:String = "#ffff00";
		public var buyDownCount:int = 3;
		public var showSign:int = 0;
		public var sign:String = "volume";
		
		override public function initParamKeys():void {
			paramkeys = ["barHeight", "offY", "color", "buyDownCount","showSign"];
		}
		
		override public function analyseWork():void {
			//var sign:String;
			sign = "amount";
			sign = "volume";
			var i:int, len:int;
			var dataList:Array;
			dataList = disDataList;
			len = dataList.length;
			var tData:Object;
			var max:Number;
			max = DataUtils.getKeyMax(dataList, sign);
			var MRate:Number;
			MRate = barHeight / max;
			var barsData:Array;
			barsData = [];
			for (i = 0; i < len; i++) {
				barsData.push([i, -dataList[i][sign] * MRate]);
			}
			resultData["bars"] = barsData;
			doBuyPoints(false, "down");
			doBuyPoints(true, "up");
		}
		
		private function doBuyPoints(isBigger:Boolean = false, markSign:String = "down"):void {
			var i:int, len:int;
			var tDownCount:int;
			var preValue:Number = 0;
			var dataList:Array;
			dataList = disDataList;
			len = dataList.length;
			var tData:Object;
			var tValue:Number;
			tDownCount = 0;
			var buyList:Array;
			buyList = [];
			for (i = 0; i < len; i++) {
				tData = dataList[i];
				tValue = tData[sign];
				if (tValue == preValue || (isBigger == (tValue > preValue))) {
					tDownCount++;
					
				}
				else {
					if (tDownCount >= buyDownCount) {
						buyList.push([markSign + ":" + tDownCount, i]);
					}
					tDownCount = 0;
				}
				preValue = tValue;
				
			}
			resultData[markSign] = buyList;
		}
		
		override public function getDrawCmds():Array {
			var rst:Array;
			rst = [];
			
			//rst.push(["drawPoints", [resultData["upBreaks"], "low", 3, "#ffff00"]]);
			rst.push(["drawBars", [resultData["bars"], offY, color]]);
			if (showSign) {
				rst.push(["drawTexts", [resultData["up"], "low", 30, "#00ff00", true, "#00ff00"]]);
				rst.push(["drawTexts", [resultData["down"], "low", 50, "#ffff00", true, "#00ff00"]]);
			}
			
			return rst;
		}
	}

}