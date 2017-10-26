package stock 
{
	import laya.stock.StockTools;
	import laya.tools.StockJsonP;
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
		public var stockDic:Object={};
		public override function init(csvStr:String):void
		{
			
			super.init(csvStr);
			stockList = dataList;
			var i:int, len:int;
			len = stockList.length;
			stockCodeList = [];
			var tCode:String;
			for (i = 0; i < len; i++)
			{
				stockList[i]["code"]=StockTools.getPureStock(stockList[i]["code"]);
				tCode = stockList[i]["code"];
				stockDic[tCode] = stockList[i];
				stockCodeList.push(tCode);
			}
		}
		
		public function getRandomStock():String
		{
			var i:int;
			i = Math.floor(Math.random() * stockCodeList.length);
			return stockCodeList[i];
		}
		
		public function getStockData(code:String):Object
		{
			return stockDic[code];
		}
		
		public function getStockName(code:String):String
		{
			if (!code) return "unknow";
			var adptCode:String;
			adptCode = StockTools.getPureStock(code);
			var stockO:Object;
			stockO = StockJsonP.getStockData(adptCode) || stockDic[adptCode];
			if (stockO) return stockO.name;
			return "unknow";
		}
	}

}