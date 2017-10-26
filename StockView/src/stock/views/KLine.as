package stock.views 
{
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.math.DataUtils;
	import laya.math.GraphicUtils;
	import laya.net.Loader;
	import laya.stock.analysers.AnalyserBase;
	import laya.stock.analysers.KLineAnalyser;
	import laya.stock.StockTools;
	import laya.tools.StockJsonP;
	import laya.utils.Handler;
	import msgs.MsgConst;
	import stock.StockBasicInfo;
	import stock.StockData;
	import view.StockListManager;
	import view.TradeTestManager;
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
			_myLoader = new Loader();
		}
		public var analysers:Array;
		//public var analyser:KLineAnalyser;
		public var autoPlay:Boolean = false;
		public var tStock:String;
		public var stockUrl:String;
		public var gridWidth:int = 3;
		public var start:int = 0;
		private var _myLoader:Loader;
		public function setStock(stock:String):void
		{
			Laya.timer.clear(this, timeEffect);
			this.graphics.clear();
			showMsg("loadingData:" + stock);
			tStock = stock;
			stockUrl = "https://onewaymyway.github.io/stockdata/stockdatas/" + stock + ".csv";
			//stockUrl = "res/stockdata/" + stock + ".csv";
			stockUrl = StockTools.getStockCsvPath(stock);
			_myLoader.once(Event.COMPLETE, this, dataLoaded);
			_myLoader.load(stockUrl, Loader.TEXT);
			//Laya.loader.load(stockUrl, Handler.create(this, dataLoaded), null, Loader.TEXT);
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
		
		public function freshStockData():void
		{
			var dataO:Object;
			dataO = StockJsonP.getStockData(tStock);
			if (!dataO) return;
			dataO = StockJsonP.adptStockO(dataO);
			if (dataO.price <= 0) return;
			if (dataO.amount <= 0) return;
			var lastDataO:Object;
			lastDataO = dataList[dataList.length - 1];
			if (dataO.date == lastDataO.date)
			{
				dataList[dataList.length - 1] = dataO;
			}else
			{
				if (dataO.date > lastDataO.date)
				{
					dataList.push(dataO);
				}
			}
		}
		
		public function showMsg(msg:String):void
		{
			event("msg",StockBasicInfo.I.getStockName(tStock)+":"+msg);
		}
		public var stockData:StockData;
		public var dataList:Array;
		public var disDataList:Array;
		public static const KlineShowed:String = "KlineShowed";
		public function setStockData(stockData:StockData):void
		{
			this.stockData = stockData;
			dataList = stockData.dataList;
			freshStockData();
			//drawdata();
			this.cacheAsBitmap = false;
			event(MsgConst.Stock_Data_Inited);
			drawdata(this.start);
			tLen = 10;
			
			if (autoPlay)
			{
				
				showMsg("playing K-line Animation");
				Laya.timer.loop(10, this, timeEffect);
			}else
			{
				showMsg("K-line Showed");
				this.cacheAsBitmap = true;
				event(KlineShowed);
			}
			
			
		}
		public var tLen:int = 10;
		public var maxShowCount:int = -1;
		public function timeEffect():void
		{
			tLen++;
			if (tLen >= dataList.length)
			{
				showMsg("Animation End");
				Laya.timer.clear(this, timeEffect);
				this.cacheAsBitmap = true;
				return;
			}		
			drawdata(start, tLen);
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
			//debugger;
			if (maxShowCount > 0)
			{
				end = start + maxShowCount;
				if (end > dataList.length) end = dataList.length;
			}
			analysersDoAnalyse(start,end);
			//trace(analyser);
			this.graphics.clear();
			if (end < start) end = dataList.length;
			disDataList = dataList.slice(start, end);
			
			drawStockKLine();
			//drawAmounts();
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
			var markTime:String;
			markTime = StockListManager.getStockLastMark(tStock);
			var prePrice:Number=0;
			for (i = 0; i < len; i++)
			{
				tData = dataList[i];
				var pos:Number;
				pos = getAdptXV(i * gridWidth);
				
				if (tData["close"] >= tData["open"])
				{
					tColor = "#ff0000";
				}else
				{
					tColor = "#00ffff";
				}
				
				if (tData["high"] == tData["low"])
				{ 
					if (tData["high"] < prePrice)
					{
						tColor = "#00ffff";
					}
					this.graphics.drawLine(pos, getAdptYV(tData["open"]), pos, getAdptYV(tData["close"])+1, tColor, gridWidth*xRate);
				}else
				{
					this.graphics.drawLine(pos, getAdptYV(tData["high"]), pos, getAdptYV(tData["low"]), tColor, 1 * xRate);
					if (tData["open"] == tData["close"])
					{
						this.graphics.drawLine(pos, getAdptYV(tData["open"]), pos, getAdptYV(tData["close"])+0.5, tColor, gridWidth*xRate);
					}else
					{
						this.graphics.drawLine(pos, getAdptYV(tData["open"]), pos, getAdptYV(tData["close"]), tColor, gridWidth*xRate);
					}
					
				}
				prePrice = tData["close"];
			}
			if (markTime)
			{
				for (i = 0; i < len; i++)
				{
					tData = dataList[i];
					if (tData.date == markTime||(tData.date<markTime&&dataList[i+1]&&dataList[i+1].date>markTime))
					{
						pos = getAdptXV(i * gridWidth);
						this.graphics.drawLine(pos, getAdptYV(tData["low"]), pos, getAdptYV(tData["low"]) + 30, "#00ff00");
						this.graphics.fillText("Mark", pos, getAdptYV(tData["low"]) + 30, null, "#00ff00", "center");
						break;
					}
					if (tData.date > markTime)
					{
						break;
					}
				}
			}
			if (TradeTestManager.isTradeTestOn)
			{
				var tradeActionDic:Object;
				tradeActionDic = TradeTestManager.curTradeInfo.getActionDic(tStock);
				for (i = 0; i < len; i++)
				{
					tData = dataList[i];
					var tDate:String;
					tDate = tData.date;
					if (tradeActionDic[tDate])
					{
						pos = getAdptXV(i * gridWidth);
						this.graphics.drawLine(pos, getAdptYV(tData["low"]), pos, getAdptYV(tData["low"]) + 30, "#00ff00");
						this.graphics.fillText(tradeActionDic[tDate], pos, getAdptYV(tData["low"]) + 30, null, "#00ff00", "center");
					}
				}
			}
		}
		public function drawAmounts():void
		{
			var sign:String;
			sign = "amount";
			sign = "volume";
			var i:int, len:int;
			var dataList:Array;
			dataList = disDataList;
			len = dataList.length;
			var tData:Object;
			var max:Number;
			max = DataUtils.getKeyMax(dataList, sign);
			var MRate:Number;
			MRate = 100 / max;
			var barsData:Array;
			barsData = [];
			for (i = 0; i < len; i++)
			{
				barsData.push([i,-dataList[i][sign]*MRate]);
			}
			drawBars(barsData, 0);
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
			this.graphics.fillText(text, getAdptXV(i * gridWidth), getAdptYV(disDataList[i][sign]) + dY, null, color, "center");
			if (withLine)
			{
				if (!lineColor) lineColor = color;
				this.graphics.drawLine(getAdptXV(i * gridWidth), getAdptYV(disDataList[i][sign]) + dY, getAdptXV(i * gridWidth), getAdptYV(disDataList[i][sign]) , lineColor);
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
		
		public static var SignDrawDes:Object = 
		{
			"high":
				{
					color:"#ffff00",
					dy:-20
				},
			"low":
				{
					color:"#00ff00",
					dy:20
				}	
		};
		public function drawPointsLineEx(iList:Array, lineWidth:Number=2):void
		{
			var dataList:Array;
			dataList = disDataList;
			var tI:int;
			var i:int, len:int;
			var preData:Object;
			var tData:Object;
			len = iList.length;
			var tArr:Array;
			var tSign:String;
			var exTxt:String;
			for (i = 0; i < len; i++)
			{
				tArr=iList[i];
				tI = tArr[0];
				tData = dataList[tI];
				tSign = tArr[1];
				exTxt = tArr[2];
				if (exTxt)
				{
					drawPoint(tI, tData[tSign], exTxt, SignDrawDes[tSign]["dy"],SignDrawDes[tSign]["color"],3);
				}else
				{
					drawPoint(tI, tData[tSign], tData[tSign], SignDrawDes[tSign]["dy"],SignDrawDes[tSign]["color"],3);
				}
				
			}
			for (i = 1; i < len; i++)
			{
				preData = dataList[iList[i - 1][0]];
				tData = dataList[iList[i][0]];
				drawLine(iList[i - 1][0], preData[iList[i - 1][1]], iList[i][0], tData[iList[i][1]], "#ff00ff",2);
			}
		}
		
		public function drawBars(barList:Array, yZero:Number = 0 , color:String = "#ffff00"):void
		{
			var i:int, len:int;
			len = barList.length;
			var tData:Array;
			var tX:Number;
			var tV:Number;
			for (i = 0; i < len; i++)
			{
				tData = barList[i];
				tX = tData[0];
				tV = tData[1];
				this.graphics.drawLine(getAdptXV(tX * gridWidth), yZero + tV, getAdptXV(tX * gridWidth), yZero, color, gridWidth * xRate);
				//this.graphics.drawLine(getAdptXV(tX * gridWidth), yZero+tV, getAdptXV(tX * gridWidth),yZero, "#ff0000",5);
			}
		}
		
		public function drawBarsH(barList:Array, xZero:Number = 0 , color:String = "#ffff00"):void
		{
			var i:int, len:int;
			len = barList.length;
			var tData:Array;
			var tY:Number;
			var tV:Number;
			var tTxt:String;
			var tColor:String;
			for (i = 0; i < len; i++)
			{
				tData = barList[i];
				tY = getAdptYV(tData[0]);
				tV = tData[1];
				tTxt = tData[2];
				tColor = tData[3];
				if (!tColor) tColor = color;
				this.graphics.drawLine(getAdptXV(tV * gridWidth) + xZero, tY, xZero, tY, tColor, gridWidth);
				if (tTxt)
				{
					this.graphics.fillText(tTxt, getAdptXV(tV * gridWidth) + xZero+5, tY-6, null, tColor, "left");
				}
				//this.graphics.drawLine(getAdptXV(tX * gridWidth), yZero+tV, getAdptXV(tX * gridWidth),yZero, "#ff0000",5);
			}
		}
		
		public function drawLines(pointList:Array,color:String="#ff0000"):void
		{
			var i:int, len:int;
			len = pointList.length;
			
			for (i = 1; i < len; i++)
			{
				drawLine(pointList[i - 1][0], pointList[i - 1][1], pointList[i][0], pointList[i][1], color);
			}
		}
		public function drawLinesEx(pointList:Array,color:String="#ff0000",offY:Number=0):void
		{
			var i:int, len:int;
			len = pointList.length;
			
			for (i = 1; i < len; i++)
			{
				drawLineEx(pointList[i - 1][0], pointList[i - 1][1]+offY, pointList[i][0], pointList[i][1]+offY, color);
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
		
		public function drawPoint(i:int, y:Number,text:String,dy:Number=10,color:String="#ffff00",radio:Number=2):void
		{
			var xPos:Number;
			xPos = getAdptXV(i * gridWidth);
			this.graphics.drawCircle(xPos, getAdptYV(y), radio, color);
			if (text)
			{
				this.graphics.fillText(text, xPos, getAdptYV(y) + dy, null, color, "center");
			}
			
		}
		
		public function drawLine(startI:int, startY:Number, endI:int, endY:Number, color:String = "#ff0000",lineWidth:Number=1):void
		{
			this.graphics.drawLine(getAdptXV(startI * gridWidth), getAdptYV(startY), getAdptXV(endI * gridWidth), getAdptYV(endY), color,lineWidth);
		}
		public function drawLineEx(startI:int, startY:Number, endI:int, endY:Number, color:String = "#ff0000"):void
		{
			this.graphics.drawLine(getAdptXV(startI * gridWidth), -startY, getAdptXV(endI * gridWidth), -endY, color);
		}
		public function drawGridLine(startI:int, endI:int, values:Array,color:String="#ff0000",texts:Array=null):void
		{
			var i:int, len:int;
			len = values.length;
			var tValue:Number;
			var tTxt:String;
			for (i = 0; i < len; i++)
			{
				tValue = values;
				drawLine(startI, tValue, endI, tValue, color);
				
			}
			if (texts)
			{
				len = texts.length;
				for (i = 0; i < len; i++)
				{
					tTxt = texts[i];
					tValue = values[i];
					this.graphics.fillText(tTxt, getAdptXV(startI* gridWidth), getAdptYV(tValue), null, color, "left");
					this.graphics.fillText(tTxt, getAdptXV(endI* gridWidth), getAdptYV(tValue), null, color, "right");
				}
			}
		}
		public function drawGridLineEx(startI:int, endI:int, values:Array,color:String="#ff0000",texts:Array=null):void
		{
			
			var i:int, len:int;
			len = values.length;
			var tValue:Number;
			var tTxt:String;
			var g:Graphics;
			g = this.graphics;
			g.save();
			g.alpha(0.5)
			for (i = 0; i < len; i++)
			{
				tValue = values[i];
				drawLineEx(startI, tValue, endI, tValue, color);
			}
			g.restore();
			if (texts)
			{
				len = texts.length;
				for (i = 0; i < len; i++)
				{
					tTxt = texts[i];
					tValue = values[i];
					this.graphics.fillText(tTxt, getAdptXV(startI* gridWidth), -tValue, null, color, "left");
					this.graphics.fillText(tTxt, getAdptXV(endI* gridWidth), -tValue, null, color, "right");
				}
			}
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