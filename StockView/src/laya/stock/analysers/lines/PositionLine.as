package laya.stock.analysers.lines 
{
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
		public var color:String = "#ff0000";
		public var barHeight:Number = 50;
		override public function initParamKeys():void 
		{
			paramkeys = ["barHeight","priceType","color","dayCount"];
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
			debugger;
			rst.push(["drawLinesEx",[resultData["expList"],color]]);
			
			return rst;
		}
	}

}