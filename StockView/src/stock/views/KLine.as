package stock.views 
{
	import laya.display.Sprite;
	import laya.math.DataUtils;
	import laya.math.GraphicUtils;
	import laya.net.Loader;
	import laya.stock.analysers.AnalyserBase;
	import laya.stock.analysers.KLineAnalyser;
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
			analysers = [];
			
			//analyser = new KLineAnalyser();
			
			analysers.push(new KLineAnalyser());
		}
		public var analysers:Array;
		//public var analyser:KLineAnalyser;
		public var autoPlay:Boolean = false;
		public var tStock:String;
		public var stockUrl:String;
		public var gridWidth:int = 3;
		public function setStock(stock:String):void
		{
			Laya.timer.clear(this, timeEffect);
			this.graphics.clear();
			showMsg("loadingData:" + stock);
			tStock = stock;
			stockUrl = "https://onewaymyway.github.io/stockdata/stockdatas/" + stock + ".csv";
			//stockUrl = "res/stockdata/" + stock + ".csv";
			Laya.loader.load(stockUrl, Handler.create(this, dataLoaded), null, Loader.TEXT);
		}
		private function dataErr():void
		{
			showMsg("dataErr");
		}
		private function dataLoaded():void
		{
			var data:String;
			data = Loader.getRes(stockUrl);
			if (!data)
			{
				dataErr();
				return;
			}
			showMsg("dataLoaded");
			initByStrData(data);
		}
		public function initByStrData(data:String):void
		{
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
			
			if (autoPlay)
			{
				showMsg("playing K-line Animation");
				Laya.timer.loop(10, this, timeEffect);
			}else
			{
				showMsg("K-line Showed");
			}
			
			
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
		
		public function analysersDoAnalyse(start:int=0, end:int=-1):void
		{
			var i:int, len:int;
			len = analysers.length;
			var tAnalyser:AnalyserBase;
			for (i = 0; i < len; i++)
			{
				tAnalyser = analysers[i];
				tAnalyser.analyser(stockData, start, end);
			}
		}
		public function drawdata(start:int=0, end:int=-1 ):void
		{
			
			analysersDoAnalyse(start,end);
			//trace(analyser);
			this.graphics.clear();
			if (end < start) end = dataList.length - 1;
			disDataList = dataList.slice(start, end);
			
			drawStockKLine();
			drawGrid();
			drawAnalysers();
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
			xRate = lineWidth / (len * gridWidth);
			for (i = 0; i < len; i++)
			{
				tData = dataList[i];
				var pos:Number;
				pos = getAdptXV(i * gridWidth);
				if (tData["close"] > tData["open"])
				{
					tColor = "#ff0000";
				}else
				{
					tColor = "#00ffff";
				}
				this.graphics.drawLine(pos, getAdptYV(tData["high"]), pos, getAdptYV(tData["low"]), tColor,1*xRate);
				this.graphics.drawLine(pos, getAdptYV(tData["open"]), pos, getAdptYV(tData["close"]), tColor, gridWidth*xRate);
			}
			
			
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
			drawPoint(maxI, dataList[maxI]["high"],"high:" + dataList[maxI]["high"],  -10);		
			drawPoint(minI, dataList[minI]["low"], "low:" + dataList[minI]["low"], 10);
		}
		public function drawAnalysers():void
		{
			var i:int, len:int;
			len = analysers.length;
			var tAnalyser:AnalyserBase;
			for (i = 0; i < len; i++)
			{
				tAnalyser = analysers[i];
				drawAnalyser(tAnalyser);
				//tAnalyser.analyser(stockData, start, end);
			}
			
		}
		public function drawAnalyser(analyser:AnalyserBase):void
		{
			var cmds:Array;
			cmds = analyser.getDrawCmds();
			if (!cmds) return;
			var i:int, len:int;
			len = cmds.length;
			var tCmdArr:Array;
			var tFunSign:String;
			for (i = 0; i < len; i++) 
			{
				tCmdArr = cmds[i];
				tFunSign = tCmdArr[0];
				if (this[tFunSign] is Function)
				{
					this[tFunSign].apply(this, tCmdArr[1]);
				}
			}
		}
		public function drawTexts(texts:Array,sign:String,dy:Number=0,color:String="#ff0000",withLine:Boolean=false, lineColor:String = null ):void
		{
			var i:int, len:int;
			len = texts.length;
			var tArr:Array;
			for (i = 0; i < len; i++)
			{
				tArr = texts[i];
				drawText(tArr[0], tArr[1], sign, dy, color,withLine,lineColor);
			}
		}
		public function drawText(text:String, i:int, sign:String, dY:Number = 0, color:String = "#ff0000", withLine:Boolean = false, lineColor:String = null ):void
		{

			//var tData:Object;
			//tData=dataList[i];
			this.graphics.fillText(text, getAdptXV(i * gridWidth), getAdptYV(dataList[i][sign]) + dY, null, color, "center");
			if (withLine)
			{
				if (!lineColor) lineColor = color;
				this.graphics.drawLine(getAdptXV(i * gridWidth), getAdptYV(dataList[i][sign]) + dY, getAdptXV(i * gridWidth), getAdptYV(dataList[i][sign]) , lineColor);
			}
		}
		public function drawPointsLine(iList:Array, sign:String="high",dY:Number=-20):void
		{
			var dataList:Array;
			dataList = disDataList;
			var tI:int;
			var i:int, len:int;
			var preData:Object;
			var tData:Object;
			len = iList.length;
			for (i = 0; i < len; i++)
			{
				tI = iList[i];
				tData = dataList[tI];

				drawPoint(tI, tData[sign], tData[sign], dY,"#ff00ff");
			}
			for (i = 1; i < len; i++)
			{
				preData = dataList[iList[i - 1]];
				tData = dataList[iList[i]];
				drawLine(iList[i - 1], preData[sign], iList[i], tData[sign], "#ff0000");
			}
		}
		public function drawPoints(iList:Array, sign:String, r:Number = 2, color:String = "#ff0000"):void
		{
			var dataList:Array;
			dataList = disDataList;
			var tI:int;
			var i:int, len:int;
			var preData:Object;
			var tData:Object;
			len = iList.length;
			for (i = 0; i < len; i++)
			{
				tI = iList[i];
				tData = dataList[tI];

				drawCircle(tI, tData[sign], r,color);
			}
		}
		
		public function drawCircle(i:int, y:Number, r:Number=2, color:String = "#ff0000"):void
		{
			this.graphics.drawCircle(getAdptXV(i * gridWidth), getAdptYV(y), r, color) ;
		}
		
		public function drawPoint(i:int, y:Number,text:String,dy:Number=10,color:String="#ffff00"):void
		{
			var xPos:Number;
			xPos = getAdptXV(i * gridWidth);
			this.graphics.drawCircle(xPos, getAdptYV(y), 2, color);
			if (text)
			{
				this.graphics.fillText(text, xPos, getAdptYV(y) + dy, null, color, "center");
			}
			
		}
		
		public function drawLine(startI:int, startY:Number, endI:int, endY:Number, color:String = "#ff0000"):void
		{
			this.graphics.drawLine(getAdptXV(startI * gridWidth), getAdptYV(startY), getAdptXV(endI * gridWidth), getAdptYV(endY), color);
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