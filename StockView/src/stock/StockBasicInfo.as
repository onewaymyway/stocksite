package stock 
{
	/**
	 * ...
	 * @author ww
	 */
	public class StockBasicInfo 
	{
		
		public function StockBasicInfo() 
		{
			
		}
		public static var I:StockBasicInfo = new StockBasicInfo();
		public var stockList:Array;
		public function init(csvStr:String):void
		{
			
			var lines:Array;
			lines = csvStr.split("\n");
			debugger;
			var keys:Array;
			keys = lines[0].split(",");
			var i:int, len:int;
			len = lines.length;
			stockList = [];
			var tArr:Array;
			var tStockO:Object;
			var j:int, jLen:int;
			jLen = keys.length;
			
			for (i = 1; i < len; i++)
			{
				tStockO = { };
				stockList.push(tStockO);
				tArr = lines[i].split(",");
				for (j = 0; j < jLen; j++)
				{
					tStockO[keys[j]] = tArr[j];
				}
			}
		}
	}

}