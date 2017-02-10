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
		public override function init(csvStr:String):void
		{
			
			super.init(csvStr);
			stockList = dataList;
		}
	}

}