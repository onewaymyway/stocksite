package stock.views 
{
	import laya.display.Sprite;
	import laya.math.DataUtils;
	import laya.net.Loader;
	import laya.utils.Handler;
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class KLine extends Sprite
	{
		
		public function KLine() 
		{
			
		}
		public function setStock(stock:String):void
		{
			Laya.timer.clear(this, timeEffect);
			this.graphics.clear();
			showMsg("loadingData:" + stock);
			var stockUrl:String;
			stockUrl = "https://onewaymyway.github.io/stockdata/stockdatas/" + stock + ".csv";
			//stockUrl = "res/stockdata/" + stock + ".csv";
			Laya.loader.load(stockUrl, Handler.create(this, dataLoaded), null, Loader.TEXT);
		}
		private function dataErr():void
		{
			showMsg("dataErr");
		}
		private function dataLoaded(data:String):void
		{
			if (!data)
			{
				dataErr();
				return;
			}
			showMsg("dataLoaded");
			var stockData:StockData;
			stockData = new StockData();
			stockData.init(data);
			setStockData(stockData);
		}
		public function showMsg(msg:String):void
		{
			event("msg",msg);
		}
		public var stockData:StockData;
		public var dataList:Array;
		public var disDataList:Array;
		public function setStockData(stockData:StockData):void
		{
			this.stockData = stockData;
			dataList = stockData.dataList;
			//drawdata();
			drawdata();
			tLen = 10;
			showMsg("playing K-line Animation");
			Laya.timer.loop(10, this, timeEffect);
		}
		public var tLen:int=10;
		public function timeEffect():void
		{
			tLen++;
			if (tLen >= dataList.length)
			{
				showMsg("Animation End");
				Laya.timer.clear(this, timeEffect);
				return;
			} 
			drawdata(0, tLen);
		}
		public var lineHeight:Number = 400;
		public var lineWidth:Number = 800;
		public function drawdata(start:int=0, end:int=-1 ):void
		{
			this.graphics.clear();
			if (end < start) end = dataList.length - 1;
			disDataList = dataList.slice(start, end);
			
			drawStockKLine();
		}
		public function drawStockKLine():void
		{
			var i:int, len:int;
			var dataList:Array;
			dataList = disDataList;
			len = dataList.length;
			var tData:Object;
			var max:Number;
			max = DataUtils.getKeyMax(dataList, "close");
			yRate = lineHeight / max;
			var tColor:String;
			xRate = lineWidth / (len * 3);
			for (i = 0; i < len; i++)
			{
				tData = dataList[i];
				var pos:Number;
				pos = getAdptXV(i * 3);
				if (tData["close"] > tData["open"])
				{
					tColor = "#ff0000";
				}else
				{
					tColor = "#00ffff";
				}
				this.graphics.drawLine(pos, getAdptYV(tData["high"]), pos, getAdptYV(tData["low"]), tColor,1*xRate);
				this.graphics.drawLine(pos, getAdptYV(tData["open"]), pos, getAdptYV(tData["close"]), tColor, 3*xRate);
				
		
				//this.graphics.drawCircle(i*2, getAdptV(tData["close"]), 2, "#ff0000");
			}
			drawGrid();
			drawMaxs();
		}
		public function drawGrid():void
		{
			var dataList:Array;
			dataList = disDataList;
			var maxI:int;
			maxI = DataUtils.getKeyMaxI(dataList, "high");
			var minI:int;
			minI = DataUtils.getKeyMinI(dataList, "low");
			var xPos:Number;
			drawPoint(maxI, "high:" + dataList[maxI]["high"], dataList[maxI]["high"], -10);		
			drawPoint(minI, "low:" + dataList[minI]["low"], dataList[minI]["low"], 10);
		}
		public function drawMaxs():void
		{
			var dataList:Array;
			dataList = disDataList;
		    var maxList:Array;
			maxList = DataUtils.getMaxInfo(dataList);
			var i:int, len:int;
			len = maxList.length;
			var tData:Object;
			var mins:Array;
			var maxs:Array;
			mins = [];
			maxs = [];
			var leftLimit:int;
			var rightLimit:int;
			leftLimit = 10;
			rightLimit = 25;
			for (i = 0; i < len; i++)
			{
				tData = maxList[i];
				if ((tData["highL"] > rightLimit)&&tData["highR"] > leftLimit)
				{
					maxs.push(i);
					drawPoint(i, dataList[i]["high"], dataList[i]["high"], -20,"#ff00ff");
				}
				if ((tData["lowL"] > rightLimit)&&tData["lowR"] > leftLimit)
				{
					mins.push(i);
					drawPoint(i, dataList[i]["low"], dataList[i]["low"], 20,"#ffff00");
				}
			}
			len = mins.length;
			var preData:Object;
			for (i = 1; i < len; i++)
			{
				preData = dataList[mins[i - 1]];
				tData = dataList[mins[i]];
				this.graphics.drawLine(getAdptXV(mins[i - 1] * 3), getAdptYV(preData["low"]), getAdptXV(mins[i] * 3), getAdptYV(tData["low"]), "#ff0000");
			}
			
			len = maxs.length;
			for (i = 1; i < len; i++)
			{
				preData = dataList[maxs[i - 1]];
				tData = dataList[maxs[i]];
				this.graphics.drawLine(getAdptXV(maxs[i - 1] * 3), getAdptYV(preData["high"]), getAdptXV(maxs[i] * 3), getAdptYV(tData["high"]), "#ff0000");
			}
		}
		public function drawPoint(i:int, text:String, y:Number,dy:Number=10,color:String="#ffff00"):void
		{
			var xPos:Number;
			xPos = getAdptXV(i * 3);
			this.graphics.drawCircle(xPos, getAdptYV(y), 2, color);
			this.graphics.fillText(text, xPos, getAdptYV(y) + dy, null, color, "center");
		}
		public var yRate:Number;
		public var xRate:Number;
		public function getAdptYV(v:Number):Number
		{
			return -DataUtils.mParseFloat(v) * yRate;
		}
		public function getAdptXV(v:Number):Number
		{
			return DataUtils.mParseFloat(v) * xRate;
		}
	}

}