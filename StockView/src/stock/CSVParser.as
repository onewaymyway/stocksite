package stock 
{
	import laya.math.DataUtils;
	/**
	 * ...
	 * @author ww
	 */
	public class CSVParser 
	{
		
		public function CSVParser() 
		{
			
		}
		public var dataList:Array;
		public var numKeys:Array = [];
		public function adaptValues():void
		{
			var i:int, len:int;
			len = dataList.length;
			for (i = 0; i < len; i++)
			{
				adptDataValues(dataList[i] );
			}
		}
		public function adptDataValues(data:Object):void
		{
			var i:int, len:int;
			len = numKeys.length;
			var tKey:String;
			for (i = 0; i < len; i++)
			{
				tKey = numKeys[i];
				data[tKey] = DataUtils.mParseFloat(data[tKey]);
			}
		}
		public function init(csvStr:String):void
		{
			
			var lines:Array;
			lines = csvStr.split("\n");
			var keys:Array;
			keys = lines[0].split(",");
			var i:int, len:int;
			len = lines.length;
			dataList = [];
			var tArr:Array;
			var tStockO:Object;
			var j:int, jLen:int;
			jLen = keys.length;
			
			for (i = 1; i < len; i++)
			{
				if (!lines[i]) continue;
				tStockO = { };
				dataList.push(tStockO);
				tArr = lines[i].split(",");
				for (j = 0; j < jLen; j++)
				{
					tStockO[keys[j]] = tArr[j];
				}
			}
			adaptValues();
		}
	}

}