package view {
	import laya.debug.tools.Notice;
	import laya.events.Event;
	import laya.net.LocalStorage;
	import laya.tools.StockJsonP;
	import laya.ui.Box;
	import laya.uicomps.MessageManager;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import msgs.MsgConst;
	import stock.StockSocket;
	import stock.views.MDLine;
	import ui.realtime.RealTimeUI;
	import view.netcomps.MainSocket;
	
	/**
	 * ...
	 * @author ww
	 */
	public class RealTimeView extends RealTimeUI {
		public static const DataSign:String = "Mystocks";
		public var mdView:MDLine;
		
		public function RealTimeView() {
			list.renderHandler = new Handler(this, stockRenderHandler);
			mdView = new MDLine();
			recoverData();
			fresh();
			Notice.listen(StockJsonP.StockFresh, this, fresh);
			StockJsonP.I.freshData();
			
			checkAuto();
			this.on(Event.DISPLAY, this, mDisplayChanged);
			this.on(Event.UNDISPLAY, this, mDisplayChanged);
			
			addBtn.on(Event.MOUSE_DOWN, this, onAddClick);
			
			autoFresh.on(Event.CHANGE, this, checkAuto);
			
			Notice.listen(MsgConst.Add_MyStock, this, addStockAndSave);
			Notice.listen(MsgConst.Remove_MyStock, this, removeStockAndSave);
			Notice.listen(MsgConst.Mark_MyStock, this, markStock);
			
			Notice.listen(MsgConst.Add_MDLine, this, addMdStock);
			Notice.listen(MsgConst.Remove_MDLine, this, removeMdStock);
			
			//showMDView(true);
			showMDCheck.on(Event.CHANGE, this, showMDChange);
			showListCheck.selected = true;
			showListCheck.on(Event.CHANGE, this, showListChange);
			netBox.visible = false;
			MainSocket.I.socket.on(StockSocket.Logined, this, onLogin);
			MainSocket.I.socket.on("stocks", this, onServerStock);
			saveBtn.on(Event.MOUSE_DOWN, this, onSaveStocks);
			loadBtn.on(Event.MOUSE_DOWN, this, onLoadStocks);
			
			Notice.listen(MsgConst.RealTimeItem_DoubleClick, this, onRealTimeDoubleClick);
		}
		
		private function onRealTimeDoubleClick(index:int):void
		{
			StockListManager.setStockList(list.array, index);
		}
		private function onServerStock(dataO:Object):void {
			trace("onServerStock:", dataO);
			MessageManager.I.show("get stock success");
			if (dataO.data) {
				var tArr:Array;
				tArr = dataO.data;
				switchStockList(tArr);
				fresh();
			}
		}
		
		private function onSaveStocks():void {
			MainSocket.I.socket.saveUserData("stocks", stockList);
		}
		
		private function onLoadStocks():void {
			MainSocket.I.socket.getUserData("stocks");
		}
		
		private function onLogin():void {
			updateUIState();
		}
		
		private function updateUIState():void {
			if (MainSocket.I.socket.isLogined) {
				netBox.visible = true;
			}
			else {
				netBox.visible = false;
			}
		}
		
		private function showListChange():void {
			list.visible = showListCheck.selected;
		}
		
		private function showMDChange():void {
			showMDView(showMDCheck.selected);
		}
		
		private function addMdStock(stock:String):void {
			mdView.addStock(stock);
		}
		
		private function removeMdStock(stock:String):void {
			mdView.removeStock(stock);
		}
		
		override protected function changeSize():void {
			super.changeSize();
			mdView.lineHeight = this.height;
			mdView.lineWidth = this.width;
			mdView.pos(0, mdView.lineHeight);
			mdView.setUpGrids();
		}
		
		public function showMDView(show:Boolean):void {
			if (show) {
				addChildAt(mdView, 0);
				mdView.startFresh();
			}
			else {
				mdView.removeSelf();
				mdView.stopFresh();
			}
		}
		
		private function recoverData():void {
			var data:Array;
			data = LocalStorage.getJSON(DataSign) as Array;
			if (data && data is Array) {
				
				stockList = data;
				
			}
			else {
				addStock("000912");
			}
			var i:int, len:int;
			len = stockList.length;
			for (i = 0; i < len; i++) {
				addStock(stockList[i]);
			}
		}
		
		public function switchStockList(newList:Array):void {
			var i:int, len:int;
			len = stockList.length;
			for (i = len - 1; i >= 0; i--) {
				removeStock(stockList[i]);
			}
			stockList.length = 0;
			//stockList = newList;
			len = newList.length;
			for (i = 0; i < len; i++) {
				addStock(newList[i]);
			}
			fresh();
			StockJsonP.I.freshData();
		}
		
		private function saveData():void {
			LocalStorage.setJSON(DataSign, stockList);
		}
		
		private function onAddClick():void {
			addStockAndSave(stockInput.text);
		
		}
		
		public function addStockAndSave(stock:String):void {
			addStock(stock);
			saveData();
			StockJsonP.I.freshData();
			//debugger;
		}
		
		public function markStock(stock:String):void {
			var i:int, len:int;
			len = stockList.length;
			for (i = 0; i < len; i++) {
				if (getStockCode(stockList[i]) == stock) {
					var tData:Object;
					tData = {};
					tData.code = stock;
					tData.markTime = Browser.now();
					var dataO:Object;
					dataO = StockJsonP.getStockData(stock);
					if (dataO) {
						tData.markPrice = dataO.price;
					}
					stockList[i] = tData;
					break;
				}
			}
			saveData();
			fresh();
		}
		
		public function removeStockAndSave(stock:String):void {
			removeStock(stock);
			saveData();
			fresh();
		}
		
		private function mDisplayChanged():void {
			checkAuto();
		}
		
		public function checkAuto():void {
			if (autoFresh.selected && this.displayedInStage) {
				StockJsonP.I.startFresh();
			}
			else {
				StockJsonP.I.stopFresh();
			}
		
		}
		public var stockList:Array = [];
		
		public function addStock(stock:String):void {
			if (!stock)
				return;
			var stockCode:String;
			stockCode = getStockCode(stock);
			stockCode = StockJsonP.getAdptStockStr(stockCode);
			StockJsonP.I.addStock(stockCode);
			//mdView.addStock(stock);
			if (!hasStock(stockCode))
				stockList.push(stock);
		
		}
		
		private function hasStock(stock:String):Boolean
		{
			stock = getStockCode(stock);
			stock = StockJsonP.getAdptStockStr(stock);
			var i:int, len:int;
			len = stockList.length;
			for (i = 0; i < len; i++) {
				if (getAdptStockCode(stockList[i]) == stock) {
					return true;
				}
			}
			return false;
		}
		
		public function removeStock(stock:String):void {
			if (!stock) return;
			//mdView.removeStock(stock);
			stock = getStockCode(stock);
			stock = StockJsonP.getAdptStockStr(stock);
			//debugger;
			StockJsonP.I.removeStock(stock);
			var i:int, len:int;
			len = stockList.length;
			for (i = len-1; i >=0; i--) {
				if (getAdptStockCode(stockList[i]) == stock) {
					stockList.splice(i, 1);
				}
			}
		}
		
		public static function getAdptStockCode(stock:*):String
		{
			return StockJsonP.getAdptStockStr(getStockCode(stock));
		}
		public static function getStockCode(stock:*):String {
			if (stock is String)
				return stock;
			return stock.code;
		}
		
		public function fresh():void {
			StockListManager.setMyStockList(stockList);
			list.array = stockList;
		}
	
		public function stockRenderHandler(box:Box, index:int):void
		{
			box.index = index;
		}
	}

}