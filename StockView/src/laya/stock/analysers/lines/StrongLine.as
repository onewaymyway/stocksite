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
			
		}
		public var lineHeight:Number = 100;
		public var offY:Number = 10;
		override public function initParamKeys():void 
		{
			paramkeys = ["days","colors","lineHeight","offY"];
		}
		override protected function getAverageData(dayCount:int, color:String):Array 
		{
			var avList:Array;
			avList = DataUtils.getAverage(disDataList, dayCount, priceType);
			var avPoints:Array
			avPoints = [];
			var i:int, len:int;
			len = avList.length;
			for (i = 0; i < len; i++)
			{
				avPoints.push([i, (disDataList[i]["close"] / avList[i]) * lineHeight]);
				//avPoints.push([i,avList[i]*lineHeight]);
			}
			return [avPoints,color,offY];
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
			rst.push(["drawLinesEx",[[[0,lineHeight],[disDataList.length-1,lineHeight]],"#ff0000",offY]]);
			return rst;
		}
	}

}