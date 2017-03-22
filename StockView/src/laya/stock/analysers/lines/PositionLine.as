package laya.stock.analysers.lines 
{
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
			var i:int, len:int;
			var expList:Array;
			expList = [];
			len = dataList.length;
			for (i = 0; i < len; i++)
			{
				expList.push([i, getMaxDatas(dataList, dayCount, i)*barHeight]);
			}
			resultData["expList"] = expList;
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
		public function getMaxDatas(dataList:Array, dayCount:int, index:int):Number
		{
			var i:int, len:int;
			var startI:int;
			startI = index - dayCount;
			if (startI < 0) startI = 0;
			var max:Number;
			var min:Number;
			min = max = dataList[startI][priceType];
			var tValue:Number;
			len = index;
			for (i = startI; i <= len; i++)
			{
				tValue = dataList[i][priceType];
				if (min > tValue) min = tValue;
				if (max < tValue) max = tValue;
			}
			tValue=dataList[index][priceType];
			var loseRate:Number;
			loseRate = (min - tValue) / tValue;
			var winRate:Number;
			winRate = (max - tValue) / tValue;
			var exp:Number;
			exp = winRate-2 * loseRate;
			return exp;
		}
		override public function getDrawCmds():Array 
		{
			var rst:Array;
			rst = [];
			
			rst.push(["drawLinesEx",[resultData["expList"],color]]);
			rst.push(["drawGridLineEx",resultData["gridLine"]]);
			return rst;
		}
	}

}