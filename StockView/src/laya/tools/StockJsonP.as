package laya.tools 
{
	import laya.debug.tools.Notice;
	import laya.math.ArrayMethods;
	import laya.utils.Browser;
	import laya.utils.Handler;
	/**
	 * ...
	 * @author ww
	 */
	public class StockJsonP 
	{
		public static const StockFresh:String = "StockFresh";
		public var completeNotice:String;
		public function StockJsonP() 
		{
			completeNotice = StockFresh;
		}
		public static var I:StockJsonP = new StockJsonP();
		public static function getStockData2(stock:String, complete:Handler):void
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
		private var listenStocks:Array = [];
		private var listenStockDic:Object = { };
		public var tUrl:String;
		public var changed:Boolean = true;
		public function updateStockUrl():void
		{
			if (!changed) return;
			if (listenStocks.length > 0)
			{
				tUrl = getStockUrl(listenStocks);
			}else
			{
				tUrl = null;
			}
			changed = false;
			
		}
		public function addStock(stock:String):void
		{
			if (listenStockDic[stock]) return;
			if (listenStocks.indexOf(stock) < 0)
			{
				listenStockDic[stock] = true;
				listenStocks.push(stock);
				changed = true;
			}
			
		}
		
		public function reset():void
		{
			listenStocks.length = 0;
			var key:String;
			for (key in listenStockDic)
			{
				listenStockDic[key] = false;
			}
			changed = true;
		}
		
		public function removeStock(stock:String):void
		{
			if (!listenStockDic[stock]) return;
			ArrayMethods.removeItem(listenStocks, stock);
			listenStockDic[stock] = false;
			changed = true;
		}
		public function freshData():void
		{
			if (changed)
			{
				updateStockUrl();
			}
			if (tUrl)
			{
				JsonP.getData(tUrl, Handler.create(this, dataComplete));
			}
			
		}
		public static function getStockData(stock:String):Object
		{
			stock = getAdptStockStr(stock);
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
			Notice.notify(completeNotice);
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
		private static const numKeys:Array = [
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
		"sell5price"];
		
		public static function adptStockO(stockO:Object):void
		{
			var dataO:Object = { };
			var i:int, len:int;
			len = numKeys.length;
			var tKey:String;
			for (tKey in stockO)
			{
				dataO[tKey] = stockO[tKey];
			}
			for (i = 0; i < len; i++)
			{
				tKey = numKeys[i];
				dataO[tKey] = parseFloat(dataO[tKey]);
			}
			dataO.volume = dataO.amount/100;
			dataO.close = dataO.price;
			return dataO;
		}
		public static var stockDataO:Object = { };
		public static function parserStockData(stock:String):void
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