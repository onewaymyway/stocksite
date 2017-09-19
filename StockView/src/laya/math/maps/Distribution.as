package laya.math.maps 
{
	/**
	 * ...
	 * @author ww
	 */
	public class Distribution 
	{
		public var dividCount:int = 30;
		public var datas:Array;
		public var values:Array;
		public function Distribution() 
		{
			
		}
		public function addDatas(dataList:Array):void
		{
			var i:int, len:int;
			len = dataList.length;
			var min:Number, max:Number;
			min = max = -1;
			var tData:Array;
			var tValue:Number;
			var sumCount:Number;
			var tCount:Number;
			sumCount = 0;
			values = [];
			for (i = 0; i < len; i++)
			{
				tData = dataList[i];
				
				tCount = tData[2];
				tValue = tData[0];
				if (min == -1 || tValue < min)
				{
					min = tValue;
				}
				if (max == -1 || tValue > max)
				{
					max = tValue;
				}
				tValue = tData[1];
				if (min == -1 || tValue < min)
				{
					min = tValue;
				}
				if (max == -1 || tValue > max)
				{
					max = tValue;
				}
				sumCount += tCount;
			}
			var d:Number;
			d = (max - min) / dividCount;
			var valueArr:Array;
			valueArr = [];
			valueArr.length = dividCount;
			len = dividCount;
			for (i = 0; i < len; i++)
			{
				valueArr[i] = 0;
				values[i] = min + d * i;
			}
			len = dataList.length;
			var startNum:Number;
			var endNum:Number;
			var sumValue:Number;
			sumValue = 0;
			for (i = 0; i < len; i++)
			{
				tData = dataList[i];
				tValue = tData[0];
				startNum = Math.round((tValue-min) / d);
				tValue = tData[1];
				endNum= Math.round((tValue-min) / d);
				tCount = tData[2];
				var j:int, jlen:int;
				var tRange:int;
				tRange = (endNum - startNum + 1);
				var tRate:Number;
				tRate = (tCount/sumCount)/tRange;
				for (j = startNum; j <= endNum; j++)
				{
					valueArr[j] += tRate;
				}
			}
			datas = valueArr;
		}
		
	}

}