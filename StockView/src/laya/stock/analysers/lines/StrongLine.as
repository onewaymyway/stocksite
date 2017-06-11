package laya.stock.analysers.lines 
{
	import laya.math.DataUtils;
	/**
	 * ...
	 * @author ww
	 */
	public class StrongLine extends AverageLine 
	{
		
		public function StrongLine() 
		{
			super();
			days = "4";
		}
		public var lineHeight:Number = 100;
		public var offY:Number = 10;
		public var buyCount:int = 3;
		public var sellCount:int = 1;
		override public function initParamKeys():void 
		{
			paramkeys = ["days","colors","lineHeight","offY","buyCount","sellCount"];
		}
		override protected function getAverageData(dayCount:int, color:String):Array 
		{
			var avList:Array;
			avList = DataUtils.getAverage(disDataList, dayCount, priceType);
			var avPoints:Array
			avPoints = [];
			var i:int, len:int;
			len = avList.length;
			var strongList:Array = [];
			for (i = 0; i < len; i++)
			{
				avPoints.push([i, (disDataList[i]["close"] / avList[i]) * lineHeight]);
				strongList.push(disDataList[i]["close"] / avList[i]);
				//avPoints.push([i,avList[i]*lineHeight]);
			}
			var rst:Array;
			rst = [[avPoints,color,offY],makeBuys(strongList)];
			return rst;
		}
		
		private function makeBuys(strongList:Array):Array
		{
			var buys:Array;
			buys = []
			var i:int, len:int;
			len = strongList.length;
			var tState:int = 0;
			var bigger:int;
			var smaller:int;
			bigger = 0;
			smaller = 0;
			var preSign:String;
			for (i = 0; i < len; i++)
			{
				if (strongList[i] == 1) continue;
				if (strongList[i] >= 1)
				{
					bigger++;
					smaller=0
				}else
				{
					smaller++;
					bigger = 0;
				}
				if (bigger == buyCount)
				{
					if (preSign == "buy")
					{
						//buys.push(["sBuy",i]);
					}
					preSign = "buy";
					buys.push(["buy",i]);
				}
				if (smaller == sellCount)
				{
					preSign = "sell";
					buys.push(["sell",i]);
				}
			}
			return buys;
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
				rst.push(["drawLinesEx", avgs[i][0]]);
				rst.push(["drawTexts", [avgs[i][1], "low", 30, "#00ff00", true, "#00ff00"]]);
			}
			rst.push(["drawLinesEx",[[[0,lineHeight],[disDataList.length-1,lineHeight]],"#ff0000",offY]]);
			return rst;
		}
	}

}