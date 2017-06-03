package view 
{
	import laya.debug.tools.Notice;
	import laya.events.Event;
	import laya.net.LocalStorage;
	import laya.tools.StockJsonP;
	import msgs.MsgConst;
	import stock.views.MDLine;
	import ui.realtime.RealTimeUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class RealTimeView extends RealTimeUI 
	{
		public static const DataSign:String = "Mystocks";
		public var mdView:MDLine;
		public function RealTimeView() 
		{
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
			
			Notice.listen(MsgConst.Add_MDLine, this, addMdStock);
			Notice.listen(MsgConst.Remove_MDLine, this, removeMdStock);
			
			//showMDView(true);
			showMDCheck.on(Event.CHANGE, this, showMDChange);
		}
		
		private function showMDChange():void
		{
			showMDView(showMDCheck.selected);
		}
		private function addMdStock(stock:String):void
		{
			mdView.addStock(stock);
		}
		private function removeMdStock(stock:String):void
		{
			mdView.removeStock(stock);
		}
		override protected function changeSize():void 
		{
			super.changeSize();
			mdView.lineHeight = this.height;
			mdView.lineWidth = this.width;
			mdView.pos(0, mdView.lineHeight);
			mdView.setUpGrids();
		}
		public function showMDView(show:Boolean):void
		{
			if (show)
			{
				addChildAt(mdView, 0);
				mdView.startFresh();
			}else
			{
				mdView.removeSelf();
				mdView.stopFresh();
			}
		}
		private function recoverData():void
		{
			var data:Array;
			data = LocalStorage.getJSON(DataSign) as Array;
			if (data && data is Array)
			{
				
				stockList = data ;
				
			}else
			{
				addStock("000912");
			}
			var i:int, len:int;
			len = stockList.length;
			for (i = 0; i < len; i++)
			{
				addStock(stockList[i]);
			}
		}
		
		private function saveData():void
		{
			LocalStorage.setJSON(DataSign, stockList);
		}
		private function onAddClick():void
		{
			addStockAndSave(stockInput.text);
			
		}
		
		public function addStockAndSave(stock:String):void
		{
			addStock(stock);
			saveData();
			StockJsonP.I.freshData();
			//debugger;
		}
		public function removeStockAndSave(stock:String):void
		{
			removeStock(stock);
			saveData();
			fresh();
		}
		private function mDisplayChanged():void
		{
			checkAuto();
		}
		public function checkAuto():void
		{
			if (autoFresh.selected&&this.displayedInStage)
			{
				StockJsonP.I.startFresh();
			}else
			{
				StockJsonP.I.stopFresh();
			}
			
		}
		public var stockList:Array = [];
	    public function addStock(stock:String):void
		{
			if (!stock) return;
			stock = StockJsonP.getAdptStockStr(stock);
			StockJsonP.I.addStock(stock);
			//mdView.addStock(stock);
			if (stockList.indexOf(stock) < 0) stockList.push(stock);
			
		}
		public function removeStock(stock:String):void
		{
			//mdView.removeStock(stock);
			stock=StockJsonP.getAdptStockStr(stock);
			var i:int, len:int;
			len = stockList.length;
			for (i = 0; i < len; i++)
			{
				if (stockList[i] == stock)
				{
					stockList.splice(i, 1);
					return;
				}
			}
		}
		public function fresh():void
		{
			list.array = stockList;
		}
		
		
	}

}