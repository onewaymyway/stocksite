package laya.stock.analysers 
{
	import laya.math.maps.Distribution;
	import laya.stock.StockTools;
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
		public var showPercent:int = 0;
		override public function initParamKeys():void 
		{
			paramkeys = ["width","color","showPercent"];
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
			var percents:Array;
			percents = tDis.percents;
			var tLineParam:Array;
			for (i = 0; i < len; i++)
			{
				tLineParam = [values[i], disDatas[i] * rate ];
				if (showPercent > 0)
				{
					tLineParam.push(StockTools.getGoodPercent(disDatas[i]) + "%" + "(" + StockTools.getGoodPercent(percents[i]) + "%)");
				}
				tLineParam[3] = getRateColor(percents[i]);
				lines.push(tLineParam);
			}
			resultData["bars"] = lines;
		}
		private static const colorList:Array = ["#FFFFCC","#FFCCCC","#996699","#FF6666","#FFFF66","#CC3333","#003399"];
		private function getRateColor(rate:Number):String
		{
			var id:int;
			id = Math.floor(rate / 0.2);
			return colorList[id];
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