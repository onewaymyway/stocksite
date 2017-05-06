package laya.tools 
{
	import laya.debug.tools.Notice;
	import laya.utils.Browser;
	import laya.utils.Handler;
	/**
	 * ...
	 * @author ww
	 */
	public class StockJsonP 
	{
		public static const StockFresh:String = "StockFresh";
		public function StockJsonP() 
		{
			
		}
		public static var I:StockJsonP = new StockJsonP();
		public static function getStockData(stock:String, complete:Handler):void
		{
			var scp:*= Browser.createElement("script");
			Browser.document.body.appendChild(scp);
			scp.type = "text/javascript";
			scp.src = "https://hq.sinajs.cn/list="+stock;
			scp.onload = function()
			{
				scp.src = "";
				Browser.removeElement(scp);
				complete.run();
			}
		}
		public static function getStockUrl(stocks:Array):String
		{
			return "https://hq.sinajs.cn/list=" + stocks.join(",");
		}
		public static function getAdptStockStr(stock:String):String
		{
			var tChar:String;
			tChar = stock.charAt(0);
			if (tChar == "s") return stock;
			if (stock.charAt(0)=="6")
			{
				return "sh"+stock;
			}
			return "sz" + stock;
		}
		
		public static function getPureStock(stock:String):String
		{
			if (stock.length > 6)
			{
				stock = stock.substr(2, 6);
			}
			return stock;
		}
		public var listenStocks:Array = [];
		public var tUrl:String;
		public function updateStockUrl():void
		{
			if (listenStocks.length > 0)
			{
				tUrl = getStockUrl(listenStocks);
			}else
			{
				tUrl = null;
			}
			
		}
		public function addStock(stock:String):void
		{
			if (listenStocks.indexOf(stock) < 0)
			{
				listenStocks.push(stock);
				updateStockUrl();
			}
			
		}
		public function freshData():void
		{
			if (tUrl)
			{
				JsonP.getData(tUrl, Handler.create(this, dataComplete));
			}
			
		}
		public function getStockData(stock:String):Object
		{
			return stockDataO[stock];
		}
		public function startFresh(interval:int=5000):void
		{
			Laya.timer.loop(interval, this, freshData);
			
		}
		public function stopFresh():void
		{
			Laya.timer.clear(this, freshData);
		}
		private function dataComplete():void
		{
			var i:int, len:int;
			len = listenStocks.length;
			for (i = 0; i < len; i++)
			{
				parserStockData(listenStocks[i]);
			}
			Notice.notify(StockFresh);
		}
		private static const keys:Array = [
		"name",
		"open",
		"close",
		"price",
		"high",
		"low",
		"tbuy",
		"tsell",
		"amount",
		"money",
		"buy1count",
		"buy1price",
		"buy2count",
		"buy2price",
		"buy3count",
		"buy3price",
		"buy4count",
		"buy4price",
		"buy5count",
		"buy5price",
		"sell1count",
		"sell1price",
		"sell2count",
		"sell2price",
		"sell3count",
		"sell3price",
		"sell4count",
		"sell4price",
		"sell5count",
		"sell5price",
		"date",
		"time"];
		
		public static var stockDataO:Object = { };
		private function parserStockData(stock:String):void
		{
			//hq_str_sh601003:"柳钢股份,4.590,4.560,5.020,5.020,4.500,5.020,0.000,82832806,402364911.000,14983707,5.020,1224300,5.010,381700,5.000,515762,4.990,127600,4.980,0,0.000,0,0.000,0,0.000,0,0.000,0,0.000,2017-05-05,15:00:00,00"
			var tStr:String;
			tStr = "hq_str_" + stock;
			if (Browser.window[tStr])
			{
				parseStockStrToData(stock, Browser.window[tStr]);
			}
		}
		public static function parseStockStrToData(stock:String,stockStr:String):void
		{
			var arrs:Array;
			arrs = stockStr.split(",");
			var data:Object;
			data =stockDataO[stock]|| { };
			var i:int, len:int;
			len = keys.length;
			for (i = 0; i < len; i++)
			{
				data[keys[i]] = arrs[i];
			}
			data.code = stock;
			//trace("stockInfo", data);
			stockDataO[stock] = data;
			Notice.notify(stock, data);
		}
	}

}