package stock.views {
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.math.DataUtils;
	import laya.stock.StockTools;
	import laya.tools.SinaMData;
	import laya.utils.Handler;
	
	/**
	 * ...
	 * @author ww
	 */
	public class MDLine extends DrawBoard {
		public var stockSp:Sprite;
		public function MDLine() {
			stockSp = new Sprite();
			addChild(stockSp);
			
			MDData = new SinaMData();
			MDData.completeHandler = new Handler(this, onStockData);
		}
		
		public function setUpGrids():void
		{
			drawGrids(this);
		}
		
		override public function fresh():void 
		{
			freshData();
		}
		public var stock:String;
		public var MDData:SinaMData;
		public var stockList:Array=[];
		public function addStock(stock:String):void
		{
			var mdData:SinaMData;
			mdData = new SinaMData();
			var sp:Sprite;
			sp = new Sprite();
			addChild(sp);
			sp.name=StockTools.getAdptStockStr(stock);
			
			mdData.completeHandler = new Handler(this, onStockData, [mdData, sp]);
			mdData.getData(stock);
			stockList.push(mdData);
		}
		public function removeStock(stock:String):void
		{
			var i:int, len:int;
			len = stockList.length;
			var tStockStr:String;
			var tMDData:SinaMData;
			tStockStr = StockTools.getAdptStockStr(stock);
			for (i = 0; i < len; i++)
			{
				tMDData = stockList[i];
				if (tMDData.stock == tStockStr)
				{
					stockList.splice(i, 1);
					break;
				}
			}
			var tChild:Node;
			tChild = this.getChildByName(tStockStr);
			if (tChild) tChild.removeSelf();
		}
		public function setStock(stock:String):void {
			MDData.getData(stock);
		}
		
		public function freshData():void {
			if (!displayedInStage) return;
			MDData.getDataFromServer();
			var i:int, len:int;
			len = stockList.length;
			var tStockData:SinaMData;
			for (i = 0; i < len; i++)
			{
				tStockData = stockList[i];
				tStockData.getDataFromServer();
			}
		}
		
		public function startFresh(interval:int = 5000):void {
			Laya.timer.loop(interval, this, freshData);
		
		}
		
		public function stopFresh():void {
			Laya.timer.clear(this, freshData);
		}
		
		public var maxXCount:int = 241;
		public var topLine:Number = 1.1;
		public var bottomLine:Number = 0.9;
		public function setRateSize(baseLine:Number):Number
		{
			var maxP:Number;
			maxP = baseLine * topLine;
			var minP:Number;
			minP = baseLine * bottomLine;
			var d:Number;
			d = maxP - minP;
			setDataSize(maxXCount, d);
			return minP;
		}
		private function onStockData(mdData:SinaMData,sp:Sprite=null):void {
			//data.pop();
			if (!sp) sp = stockSp;
			var data:Array
			data = mdData.dataArr;
			var basic:Object;
			basic = mdData.basic;
			//trace("stockData:", data);
			//trace("basic:", basic);
			sp.graphics.clear();
			var color:String;
			color = mdData.color;
			//color = "#" + StockTools.getPureStock(mdData.stock);
			//drawGrids();
			var preClose:Number;
			preClose = parseFloat(basic.close);		
			var minP:Number;
			minP = setRateSize(preClose);
			
			var i:int, len:int;
			len = data.length;
			
			var preX:Number;
			var preY:Number;
			var xpos:Number;
			var yPos:Number;
			
			for (i = 1; i < len; i++) {
				preX = getAdptXV(i - 1);
				preY = getAdptYV(data[i - 1].price - minP);
				xpos = getAdptXV(i);
				yPos = getAdptYV(data[i].price - minP);
				
				sp.graphics.drawLine(preX, preY, xpos, yPos, color);
					//this.graphics.drawCircle(xpos, yPos, 2, "#ff0000");
			}
		}
		
		private function drawGrids(sp:Sprite=null):void {
			//trace("drawGrids");
			if (!sp) sp = this;
			sp.graphics.clear();
			var minP:Number;
			minP = setRateSize(1);
			var rates:Array;
			rates = [];
			var i:int, len:int;
			var tV:Number;
			tV = 0.9;
			var tDrawV:Number;
			var color:String;
			while (tV <= 1.1) {
				tDrawV = tV;
				if (tV < 1) {
					color = "#00ff00";
				}
				else if (tV == 1) {
					color = "#00ffff";
				}
				else {
					color = "#ff0000";
				}
				sp.graphics.drawLine(getAdptXV(0), getAdptYV(tDrawV - minP), getAdptXV(maxXCount), getAdptYV(tDrawV - minP), color);
				sp.graphics.fillText(StockTools.getGoodPercent(tV - 1) + "%", getAdptXV(maxXCount), getAdptYV(tDrawV - minP)-6, null, color, "left");
				tV += 0.01;
			}
		
		}
	}

}