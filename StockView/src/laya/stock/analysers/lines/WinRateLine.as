package laya.stock.analysers.lines 
{
	import laya.stock.analysers.AnalyserBase;
	
	/**
	 * ...
	 * @author ww
	 */
	public class WinRateLine extends AverageLine 
	{
		
		public function WinRateLine() 
		{
			super();
			priceType = "rise";
			
		}
		public var lineHeight:Number = 100;
		public var offY:Number = 10;
		override public function initParamKeys():void 
		{
			paramkeys = ["days","colors","lineHeight","offY"];
		}
		override public function analyseWork():void 
		{
			doAverages();
		}
		private function adptDataList(dataList:Array,dayCount:int):void
		{
			var i:int, len:int;
			len = dataList.length;
			var tData:Object;
			for (i = 0; i < len; i++)
			{
				tData = dataList[i];
				if (tData["close"] > tData["open"])
				{
					tData["rise"] = lineHeight*1;
				}else
				{
					tData["rise"] = 0;
				}
			}
		}
		override protected function getAverageData(dayCount:int, color:String):Array 
		{
			adptDataList(disDataList, dayCount);
			var rst:Array;
			rst = super.getAverageData(dayCount, color);
			rst.push(offY);
			return rst;
		}

		override public function getDrawCmds():Array 
		{
			var rst:Array;
			rst = [];
			var avgs:Array;
			avgs = resultData["averages"];
			var i:int, len:int;
			len = avgs.length;
			for (i = 0; i < len; i++)
			{
				rst.push(["drawLinesEx",avgs[i]]);
			}
			
			return rst;
		}
	}

}