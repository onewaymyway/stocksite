package laya.tools 
{
	import laya.debug.tools.ColorTool;
	import laya.debug.tools.Notice;
	import laya.stock.StockTools;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import stock.sinastock.DataTool;
	/**
	 * ...
	 * @author ww
	 */
	public class SinaMData 
	{
		public var stock:String;
		public var completeHandler:Handler;
		public var basic:Object;
		public var dataArr:Array;
		public var color:String;
		
		public static function getRandomColor():String
		{
			return ColorTool.getRGBStr([Math.random()*100,Math.random()*100,Math.random()*255]);
			return ColorTool.getRGBStr([Math.random()*255,Math.random()*255,Math.random()*255]);
		}
		public function SinaMData() 
		{
			color = getRandomColor();
			
		}
		//https://hq.sinajs.cn/?list=ml_sh600012
		public function getData(stock:String):void
		{
			stock = StockTools.getAdptStockStr(stock);
			this.stock = stock;
			basic = null;
			//color = "#" + StockTools.getPureStock(stock);
			getBasicFromServer();
		}
		public function getBasicFromServer():void
		{
			var path:String;
			path = "https://hq.sinajs.cn/list="+stock;;
			JsonP.getData(path, Handler.create(this, basicComplete));
			
		}
		private function basicComplete():void
		{
			//trace("basicLoaded");
			StockJsonP.parserStockData(stock);
			basic = StockJsonP.getStockData(stock);
			getDataFromServer();
		}
		
		public function getDataFromServer():void
		{
			if (!basic) return;
			//trace("getdataFromServer");
			JsonP.getData("https://hq.sinajs.cn/?list=ml_"+stock, Handler.create(this, dataComplete));
		}
		private function dataComplete():void
		{
			parserStockData(stock);
		}
		public function parserStockData(stock:String):void
		{
			var tStr:String;
			tStr = "hq_str_ml_" + stock;
			if (Browser.window[tStr])
			{
				parseStockStrToData(stock, Browser.window[tStr]);
				if (completeHandler)
				{
					dataArr = stockDataDic[stock];
					completeHandler.runWith([this]);
				}
			}
		}
		public static var stockDataDic:Object = { };
		public static function parseStockStrToData(stock:String, dataStr:String):void
		{
			stockDataDic[stock] = DataTool.parseMinutesData(dataStr);
			Notice.notify("MD" + stock, stockDataDic[stock]);
		}
		
	}

}