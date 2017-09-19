package laya.stock.analysers 
{
	import laya.math.maps.Distribution;
	/**
	 * ...
	 * @author ww
	 */
	public class DistAnalyser extends AnalyserBase 
	{
		
		public function DistAnalyser() 
		{
			super();
			
		}
		
		public var width:Number = 40;
		public var color:String = "#ffff00";
		override public function initParamKeys():void 
		{
			paramkeys = ["width","color"];
		}
		override public function analyseWork():void 
		{
			doDist();
		}
		
		public function doDist():void
		{
			var dataList:Array = disDataList;
			var i:int, len:int;
			len = dataList.length;
			var tDistData:Array;
			tDistData = [];
			for (i = 0; i < len; i++)
			{
				var tData:Object;
				tData = dataList[i];
				tDistData.push([tData["low"],tData["high"],tData["volume"]]);
			}
			var tDis:Distribution;
			tDis = new Distribution();
			tDis.addDatas(tDistData);
			
			var disDatas:Array;
			disDatas = tDis.datas;
			var values:Array;
			values = tDis.values;
			len = values.length;
			var lines:Array;
			lines = [];
			var rate:Number;
			rate = width * dataList.length / 10;
			for (i = 0; i < len; i++)
			{
				lines.push([values[i],disDatas[i]*rate,0,values[i]]);
			}
			resultData["bars"] = lines;
		}
		override public function getDrawCmds():Array 
		{
			var rst:Array;
			rst = [];
			
			//rst.push(["drawPoints", [resultData["upBreaks"], "low", 3, "#ffff00"]]);
			rst.push(["drawBarsH", [resultData["bars"], 10,color]]);

			
			return rst;
		}
	}

}