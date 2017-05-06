package view.realtime 
{
	import laya.debug.tools.Notice;
	import laya.events.Event;
	import laya.stock.StockTools;
	import laya.tools.StockJsonP;
	import msgs.MsgConst;
	import ui.realtime.StockRealTimeItemUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class RealTimeItem extends StockRealTimeItemUI 
	{
		
		public function RealTimeItem() 
		{
			delBtn.on(Event.MOUSE_DOWN, this, onDeleteBtn);
			this.on(Event.DOUBLE_CLICK, this, onDoubleClick);
		}
		public var stock:String;
		override public function set dataSource(value:*):void 
		{
			super.dataSource = value;
			
			initByStock(value);
		}
		public function initByStock(stock:String):void
		{
			this.stock = stock;
			txt.text = stock;
			var dataO:Object;
			dataO = StockJsonP.I.getStockData(stock);
			if (dataO)
			{
				txt.text = dataO.code+","+dataO.name+","+dataO.price+","+StockTools.getGoodPercent((dataO.price-dataO.close)/dataO.close)+"%";
			}
		}
		private function onDoubleClick():void
		{
			Notice.notify(MsgConst.Show_Stock_KLine, StockJsonP.getPureStock(stock));
		}
		private function onDeleteBtn():void
		{
			Notice.notify(MsgConst.Remove_MyStock, stock);
		}
	}

}