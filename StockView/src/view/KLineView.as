package view 
{
	import laya.events.Event;
	import laya.utils.Handler;
	import stock.views.KLine;
	import ui.KLineViewUI;
	/**
	 * ...
	 * @author ww
	 */
	public class KLineView extends KLineViewUI
	{
		public var kLine:KLine;
		public function KLineView() 
		{
			kLine = new KLine();
			addChild(kLine);
			var stock:String;
			stock = "300383";
			//stock = "000546";
			//stock = "000725";
			stock = "002064";
			//stock = "600139";
			
			kLine.pos(0, kLine.lineHeight+90);
			init();
		}
		public function init():void
		{
			stockSelect.labels = "300383,000546,000725,002064,600139";
			stockSelect.selectedIndex = 0;
			stockSelect.selectHandler = new Handler(this, onSelect);
			
			playBtn.on(Event.MOUSE_DOWN, this, onPlayBtn);
			var stock:String;
			stock = "300383";
			kLine.setStock(stock);
		}
		private function onSelect():void
		{
			kLine.setStock(stockSelect.selectedLabel);
		}
		private function onPlayBtn():void
		{
			kLine.setStock(stockSelect.selectedLabel);
		}
	}

}