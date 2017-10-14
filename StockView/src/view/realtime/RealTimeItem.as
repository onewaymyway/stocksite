package view.realtime 
{
	import laya.debug.tools.Notice;
	import laya.events.Event;
	import laya.stock.StockInfoManager;
	import laya.stock.StockTools;
	import laya.tools.DateTools;
	import laya.tools.StockJsonP;
	import msgs.MsgConst;
	import ui.realtime.StockRealTimeItemUI;
	import view.RealTimeView;
	
	/**
	 * ...
	 * @author ww
	 */
	public class RealTimeItem extends StockRealTimeItemUI 
	{
		public var index:int;
		public function RealTimeItem() 
		{
			delBtn.on(Event.MOUSE_DOWN, this, onDeleteBtn);
			markBtn.on(Event.MOUSE_DOWN, this, onMarkBtn);
			this.on(Event.DOUBLE_CLICK, this, onDoubleClick);
		}
		private function onMarkBtn():void
		{
			Notice.notify(MsgConst.Mark_MyStock, stock);
		}
		public var stock:String;
		override public function set dataSource(value:*):void 
		{
			super.dataSource = value;
			
			initByStock(value);
		}
		public static var showStockDic:Object = { };
		private var isSettingV:Boolean = false;
		public function initByStock(stockData:*):void
		{
			if (!stockData) return;
			var stock:String;
			stock = RealTimeView.getStockCode(stockData);
			this.stock = stock;
			txt.text = stock;
			var dataO:Object;
			dataO = StockJsonP.getStockData(stock);
			if (dataO)
			{
				txt.text = dataO.code + "," + dataO.name + "," + dataO.price + "," + StockTools.getGoodPercent((dataO.price-dataO.close) / dataO.close) + "%";
				txt.color = dataO.price-dataO.close > 0?"#ff0000":"#00ff00";
				isSettingV = true;
				showLine.selected = showStockDic[stock];
				showLine.on(Event.CHANGE, this, onShowLineChange);
				isSettingV = false;
			}
			if (stockData is Object)
			{
				if (stockData.markTime)
				{
					txt.text += " M:" + DateTools.getTimeStr(stockData.markTime);
				}
				if (stockData.markPrice&&dataO&&dataO.price)
				{
					txt.text +=","+StockTools.getGoodPercent((dataO.price-stockData.markPrice) / stockData.markPrice) + "%"
				}
			}
			txt.text += " "+StockInfoManager.getStockAvgTrendSign(stock);
		}
		private function onShowLineChange():void
		{
			if (isSettingV) return;
			showStockDic[stock] = showLine.selected;
			if (showLine.selected)
			{
				Notice.notify(MsgConst.Add_MDLine, [stock]);
			}else
			{
				Notice.notify(MsgConst.Remove_MDLine, [stock]);
			}
		}
		private function onDoubleClick():void
		{
			Notice.notify(MsgConst.RealTimeItem_DoubleClick, index);
			Notice.notify(MsgConst.Show_Stock_KLine, StockJsonP.getPureStock(stock));
		}
		private function onDeleteBtn():void
		{
			Notice.notify(MsgConst.Remove_MyStock, stock);
		}
	}

}