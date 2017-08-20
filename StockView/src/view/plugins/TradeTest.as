package view.plugins {
	import laya.events.Event;
	import laya.stock.StockTools;
	import laya.ui.Button;
	import ui.plugins.TradeTestUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class TradeTest extends TradeTestUI {
		
		public var tradeInfo:TradeInfo;
		public function TradeTest() {
			tradeInfo = new TradeInfo();
			tradeInfo.reset();
			var btns:Array;
			btns = [buyBtn, sellBtn, resetBtn, anotherBtn, nextDayBtn];
			var i:int, len:int;
			len = btns.length;
			for (i = 0; i < len; i++) {
				var tBtn:Button;
				tBtn = btns[i];
				tBtn.on(Event.CLICK, this, onBtnClick, [tBtn]);
			}
			setDataList(null);
		}
		
		private var _dataList:Array;
		private var _stock:String;
		public function setDataList(dataList:Array,stock:String):void
		{
			_dataList = dataList;
			_stock = stock;
			tradeInfo.tStock = stock;
			updateUIInfo();
			
		}
		
		public function updateUIInfo():void
		{
			updateCurInfo();
			updateInfo();
		}
		public static const OPEN:String = "open";
		public static const CLOSE:String = "close";
		public var tState:String = CLOSE;
		public function updateCurInfo():void
		{
			if (!_dataList)
			{
				stockInfoTxt.text = "";
				tradeInfo.tStockPrice = 0;
				return;
			}
			var len:int;
			len = _dataList.length;
			var tData:Object;
			var preData:Object;
			tData = _dataList[len - 1];
			preData = _dataList[len - 2];
			tradeInfo.tStockPrice = tData.close;
			tradeInfo.tDate = tData.date;
			
			if (tState == OPEN)
			{
				stockInfoTxt.text = "当前股价:"+tData.open;
			}else
			{
				stockInfoTxt.text = "当前股价:"+tData.close+"\n涨幅:"+StockTools.getGoodPercent((tData.close-preData.close)/preData.close);
			}
			
		}
		
		public function get curStockCount():Number
		{
			return parseInt(countTxt.text);
		}
		public function updateInfo():void
		{
			tradeInfoTxt.text = "总金额:" + tradeInfo.total 
			+"\n当前仓位:"+StockTools.getGoodPercent(tradeInfo.position)+"%"
			+"\n股票:" + tradeInfo.curStockMoney+" 现金:"+Math.floor(tradeInfo.money)
			+"\n总盈亏:" + tradeInfo.stockWinOfTotal+","+StockTools.getGoodPercent(tradeInfo.stockWinRateOfTotal)+"%"
			+"\n持仓盈亏:" + tradeInfo.stockWin+","+StockTools.getGoodPercent(tradeInfo.stockWinRate)+"%";
			
		}
		
		public static const NEXT_DAY:String = "NEXT_Day";
		public static const ANOTHER:String = "ANOTHER";
		private function onBtnClick(btn:Button):void {
			switch (btn) {
				case buyBtn:
					tradeInfo.buyStock(tradeInfo.tStockPrice, curStockCount);
					updateUIInfo();
					break;
				case sellBtn:
					tradeInfo.sellStock(tradeInfo.tStockPrice, curStockCount);
					updateUIInfo();
					break;
				case resetBtn:
					tradeInfo.reset();
					updateUIInfo();
					break;
				case anotherBtn:
					tradeInfo.sellAll();
					event(ANOTHER);
					break;
				case nextDayBtn:
					event(NEXT_DAY);
					break;
			}
		}
	
	}

}