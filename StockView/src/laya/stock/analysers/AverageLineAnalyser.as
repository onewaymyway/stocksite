package laya.stock.analysers 
{
	import laya.stock.analysers.lines.AverageLine;
	
	/**
	 * ...
	 * @author ww
	 */
	public class AverageLineAnalyser extends AverageLine 
	{
		
		public function AverageLineAnalyser() 
		{
			super();
			days = "5,12,26";
			colors = "#ff0000,#00ffff,#ffff00";
		}
		
		override public function addToConfigTypes(types:Array):void 
		{
			var tData:Object;
			var tAnalyserInfos:Array;
			var sign:String;
			sign = "average";
			tData = {};
			tData.label = "AvgTrend";
			tData.sortParams = [sign+".day", true, true];
			tData.dataKey = sign;
			tData.tpl = "{#code#}:day:{#day#}";
			tAnalyserInfos = [];
			tAnalyserInfos.push(this.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			tData.tip = "average 多头";
			types.push(tData);
			
		}
		
		
		override public function addToShowData(showData:Object):void {
			var kLineO:Object;
			kLineO = {};
			
			kLineO.code = showData.code;
			kLineO.day = 0;
			kLineO.rate = 0;
			
			var avgs:Array;
			avgs = resultData["averages"];
			var i:int, len:int;
			len = avgs.length;
			var upCount:int = 0;
			var tI:int;
			tI = disDataList.length - 1;
			while (tI >= 0)
			{
				if (isUpTrend(avgs, tI))
				{
					tI--;
					upCount++;
				}else
				{
					break;
				}
			}
			kLineO.day = upCount;
			showData["average"] = kLineO;
			
		}
		
		private function isUpTrend(avgs:Array,index:int):void
		{
			var i:int, len:int;
			len = avgs.length;
			var preLine:Array;
			var tLine:Array;
			for (i = 1; i < len; i++)
			{
				preLine = avgs[i - 1][0][index];
				tLine = avgs[i][0][index];
				if (tLine[1] > preLine[1])
				{
					return false;
				}
			}
			return true;
		}
	}

}