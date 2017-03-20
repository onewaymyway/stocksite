package laya.stock.analysers.bars 
{
	import laya.math.DataUtils;
	import laya.stock.analysers.AnalyserBase;
	
	/**
	 * ...
	 * @author ww
	 */
	public class VolumeBar extends AnalyserBase 
	{
		
		public function VolumeBar() 
		{
			super();
			
		}
		public var barHeight:Number = 100;
		public var offY:Number = 0;
		public var color:String = "#ffff00";
		override public function initParamKeys():void 
		{
			paramkeys = ["barHeight","offY","color"];
		}
		override public function analyseWork():void 
		{
			var sign:String;
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
			for (i = 0; i < len; i++)
			{
				barsData.push([i,-dataList[i][sign]*MRate]);
			}
			resultData["bars"] = barsData;
		}
		override public function getDrawCmds():Array {
			var rst:Array;
			rst = [];
			
			//rst.push(["drawPoints", [resultData["upBreaks"], "low", 3, "#ffff00"]]);
			rst.push(["drawBars", [resultData["bars"], offY, color]]);
			
			return rst;
		}
	}

}