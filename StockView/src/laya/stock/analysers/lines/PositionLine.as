package laya.stock.analysers.lines 
{
	import laya.math.DataUtils;
	import laya.math.ValueTools;
	import laya.stock.analysers.AnalyserBase;
	/**
	 * ...
	 * @author ww
	 */
	public class PositionLine extends AnalyserBase
	{
		
		public function PositionLine() 
		{
			super();
		}
		public var dayCount:int = 130;
		public var priceType:String = "close";
		public var color:String = "#ffff00";
		public var winColor:String = "#ff0000";
		public var loseColor:String = "#00ff00";
		public var expColor:String = "#ffff00";
		public var barHeight:Number = 50;
		public var gridLineValue:String = "0,0.5,1,1.5,2,2.5";
		override public function initParamKeys():void 
		{
			paramkeys = ["barHeight","priceType","color","dayCount","gridLineValue"];
		}
		override public function analyseWork():void 
		{
			doAWork();
		}
		public function doAWork():void
		{
			var dataList:Array;
			dataList = disDataList;
			var i:int, len:int;
			var expList:Array;
			expList = [];
			var winList:Array;
			winList = [];
			var loseList:Array;
			loseList = [];
			var tDatas:Array;
			
			len = dataList.length;
			for (i = 0; i < len; i++)
			{
				//expList.push([i, DataUtils.getExpDatas(dataList, dayCount, i) * barHeight]);
				tDatas = DataUtils.getWinLoseInfo(dataList, dayCount, i);
				if (tDatas)
				{
					loseList.push([i, tDatas[0] * barHeight]);
					winList.push([i, tDatas[1] * barHeight]);
					expList.push([i, tDatas[2] * barHeight]);
				}
			}
			resultData["expList"] = expList;
			resultData["winList"] = winList;
			resultData["loseList"] = loseList;
			var gridLine:Array;
			var gridValue:Number;
			gridValue = barHeight * gridLineValue;
			gridLine = [];
			var values:Array;
			values = gridLineValue.split(",");
			len = values.length;
			for (i = 0; i < len; i++)
			{
				values[i] = ValueTools.mParseFloat(values[i]) * barHeight;
			}
			gridLine.push(0, dataList.length-1,values,color,gridLineValue.split(","));
			resultData["gridLine"] = gridLine;
		}

		override public function getDrawCmds():Array 
		{
			var rst:Array;
			rst = [];
			
			rst.push(["drawLinesEx", [resultData["expList"], expColor]]);
			rst.push(["drawLinesEx", [resultData["winList"], winColor]]);
			rst.push(["drawLinesEx",[resultData["loseList"],loseColor]]);
			rst.push(["drawGridLineEx",resultData["gridLine"]]);
			return rst;
		}
	}

}