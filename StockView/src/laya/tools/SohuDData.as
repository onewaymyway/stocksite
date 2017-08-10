package laya.tools 
{
	import laya.stock.StockTools;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import stock.sinastock.DataTool;
	/**
	 * ...
	 * @author ww
	 */
	public class SohuDData 
	{
		//http://q.stock.sohu.com/hisHq?code=cn_601918,cn_300080&start=20170806&end=20170807&stat=1&order=D&period=d&callback=historySearchHa&rt=jsonp
		public function SohuDData() 
		{
			
		}
		public static function getData(stock:String,handler:Handler,start:String=null,end:String=null):void
		{
			if (!Browser.window.orzHistorySearch)
			{
				Browser.window.orzHistorySearch = onStockData;
			}
			if (!start)
			{
				start = DateTools.getDateStr(DateTools.getDateEx(-1));
			}
			if (!end)
			{
				end = start;
			}
			var pureCode:String;
			pureCode = StockTools.getPureStock(stock);
			var url:String;
			url = "http://q.stock.sohu.com/hisHq?code=cn_" + pureCode + "&start="+start+"&end="+end+"&stat=1&order=D&period=d&callback=orzHistorySearch&rt=jsonp";
			JsonP.getData(url, handler);
		}
		public static function onStockData(stockData:Array):void
		{
			trace("sohuStock:", stockData);
			var i:int, len:int;
			len = stockData.length;
			for (i = 0; i < len; i++)
			{
				dealStockData(stockData[i]);
			}
		}
		private static function dealStockData(stockData:Object):void
		{
			
		}
	}

}