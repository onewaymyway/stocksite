package stock 
{
	/**
	 * ...
	 * @author ww
	 */
	public class StockBasicInfo extends CSVParser
	{
		
		public function StockBasicInfo() 
		{
			
		}
		public static var I:StockBasicInfo = new StockBasicInfo();
		public var stockList:Array;
		public var stockCodeList:Array;
		public override function init(csvStr:String):void
		{
			
			super.init(csvStr);
			stockList = dataList;
			var i:int, len:int;
			len = stockList.length;
			stockCodeList = [];
			for (i = 0; i < len; i++)
			{
				stockCodeList.push(stockList[i]["code"]);
			}
		}
	}

}