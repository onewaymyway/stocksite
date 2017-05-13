package laya.stock.analysers.lines {
	import laya.math.ArrayMethods;
	import laya.math.DataUtils;
	import laya.math.ValueTools;
	import laya.stock.analysers.AnalyserBase;
	import laya.stock.StockTools;
	import laya.structs.RankInfo;
	
	/**
	 * ...
	 * @author ww
	 */
	public class PositionLine extends AnalyserBase {
		
		public function PositionLine() {
			super();
		}
		public var dayCount:String = "90";
		public var priceType:String = "close";
		public var color:String = "#ffff00";
		public var winColor:String = "#ff0000";
		public var loseColor:String = "#00ff00";
		public var expColor:String = "#ffff00";
		public var barHeight:Number = 50;
		public var minBuyExp:Number = 0.3;
		public var minBuyLose:Number = -0.05;
		public var maxBuyLose:Number = -0.3;
		public var gridLineValue:String = "0,0.5,1,1.5,2,2.5";
		
		override public function initParamKeys():void {
			paramkeys = ["barHeight", "priceType", "color", "dayCount", "minBuyExp","minBuyLose", "maxBuyLose"];
		}
		
		override public function analyseWork():void {
			doAWork();
		}
		
		public function doAWork():void {
			if (forSelect) return;
			var dataList:Array;
			dataList = disDataList;
			var i:int, len:int;
			
			var days:Array = (dayCount + "").split(",");
			len = days.length;
			var positionList:Array;
			
			positionList = [];
			resultData["positionList"] = positionList;
			for (i = 0; i < len; i++) {
				positionList.push(getWinLoseData(ValueTools.mParseFloat(days[i]), dataList));
			}
			var gridLine:Array;
			//var gridValue:Number;
			//gridValue = barHeight * gridLineValue;
			gridLine = [];
			var values:Array;
			values = gridLineValue.split(",");
			len = values.length;
			for (i = 0; i < len; i++) {
				values[i] = ValueTools.mParseFloat(values[i]) * barHeight;
			}
			gridLine.push(0, dataList.length - 1, values, color, gridLineValue.split(","));
			resultData["gridLine"] = gridLine;
		}
		
		private function getBuyList(positionData:Object):Array
		{
			var expList:Array;
			expList = positionData["expList"];
			var loseList:Array;
			loseList = positionData["loseList"];
			var i:int, len:int;
			var rst:Array;
			rst = [];
			var tExp:Number;
			var tLimit:Number;
			tLimit = minBuyExp * barHeight;
			var tLimitLose:Number;
			tLimitLose = minBuyLose * barHeight;
			var tLimitLoseMax:Number;
			tLimitLoseMax = maxBuyLose * barHeight;
			len = expList.length;
			var tLose:Number;
			for (i = 1; i < len; i++)
			{
				tExp = expList[i][1];
				if (tExp < tLimit) continue;
				tLose = loseList[i][1];
				if (tLose > tLimitLose) continue;
				if (tLose < tLimitLoseMax) continue;
				if (tExp > expList[i - 1][1]&&ArrayMethods.isHighThenBefore(expList,i-1,5))
				{
					rst.push(["buy:"+StockTools.getGoodPercent(tExp/barHeight)+"\n"+disDataList[expList[i][0]]["date"],expList[i][0]])
				}
			}
			return rst;
		}
		public function getWinLoseData(dayCount:int, dataList:Array):Object {
			var resultData:Object;
			resultData = {};
			var i:int, len:int;
			var expList:Array;
			expList = [];
			var winList:Array;
			winList = [];
			var loseList:Array;
			loseList = [];
			var tDatas:Array;
			
			len = dataList.length;
			for (i = 0; i < len; i++) {
				//expList.push([i, DataUtils.getExpDatas(dataList, dayCount, i) * barHeight]);
				tDatas = DataUtils.getWinLoseInfo(dataList, dayCount, i);
				if (tDatas) {
					loseList.push([i, tDatas[0] * barHeight]);
					winList.push([i, tDatas[1] * barHeight]);
					expList.push([i, tDatas[2] * barHeight]);
				}
			}
			resultData["expList"] = expList;
			resultData["winList"] = winList;
			resultData["loseList"] = loseList;
			resultData["buyList"] = getBuyList(resultData);
			return resultData;
		}
		
		override public function getDrawCmds():Array {
			var rst:Array;
			rst = [];
			var positions:Array;
			positions = resultData["positionList"];
			var i:int, len:int;
			len = positions.length;
			var tPositionO:Object;
			for (i = 0; i < len; i++) {
				tPositionO = positions[i];
				rst.push(["drawLinesEx", [tPositionO["expList"], expColor]]);
				rst.push(["drawLinesEx", [tPositionO["winList"], winColor]]);
				rst.push(["drawLinesEx", [tPositionO["loseList"], loseColor]]);
				rst.push(["drawTexts", [tPositionO["buyList"], "low", 30, "#00ff00",true,"#00ff00"]]);
			}
			
			rst.push(["drawGridLineEx", resultData["gridLine"]]);
			return rst;
		}
		
		override public function addToConfigTypes(types:Array):void 
		{
			var tData:Object;
			var tAnalyserInfos:Array;
			var sign:String;
			sign = "exp" + dayCount;
			tData = {};
			tData.label = "exp"+dayCount;
			tData.sortParams = [sign+".exp", true, true];
			tData.dataKey = sign;
			tData.tpl = "{#code#}:exp:{#exp#}\nwin:{#win#}\nlose{#lose#}";
			tAnalyserInfos = [];
			tAnalyserInfos.push(this.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			tData.tip = "n天期望模型";
			types.push(tData);
			
			tData = {};
			tData.label = "win"+dayCount;
			tData.sortParams = [sign+".win", true, true];
			tData.dataKey = sign;
			tData.tpl = "{#code#}:exp:{#exp#}\nwin:{#win#}\nlose{#lose#}";
			tAnalyserInfos = [];
			tAnalyserInfos.push(this.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			tData.tip = "n天期望模型";
			types.push(tData);
			
			tData = {};
			tData.label = "expBuy"+dayCount;
			tData.sortParams = [sign+".lastExpBuy", true, false];
			tData.dataKey = sign;
			tData.tpl = "{#code#}:exp:{#exp#}\nwin:{#win#}\nlose{#lose#}\nbuy:{#lastExpBuy#}";
			tAnalyserInfos = [];
			tAnalyserInfos.push(this.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			tData.tip = "n天期望模型";
			types.push(tData);
		}
		override public function addToShowData(showData:Object):void 
		{
			var sign:String;
			sign = "exp" + dayCount;
			
			var winLose:Array;
			winLose = DataUtils.getWinLoseInfo(this.disDataList, parseInt(this.dayCount), this.disDataList.length - 1);
			var posBuy:Object;
			posBuy = this.getWinLoseData(parseInt(this.dayCount), this.disDataList);
			var expO:Object = {};
			showData[sign] = expO;
			expO.code = showData.code;
			expO.lose = StockTools.getGoodPercent(winLose[0]);
			expO.win = StockTools.getGoodPercent(winLose[1]);
			expO.exp = StockTools.getGoodPercent(winLose[2]);
			if (posBuy && posBuy["buyList"]&&posBuy["buyList"][0])
			{
				var lastBuyI:int;
				lastBuyI = posBuy["buyList"].pop()[1];
				//trace(posBuy["buyList"]);
				expO.lastExpBuy = disDataList[lastBuyI]["date"];
			}else
			{
				expO.lastExpBuy = "0";
			}
		}
	}

}