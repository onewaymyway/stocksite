package view 
{
	import laya.events.Event;
	import laya.utils.Handler;
	import stock.StockBasicInfo;
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
			
			kLine.pos(0, kLine.lineHeight + 90);
			kLine.on("msg", this, onKlineMsg);
			init();
		}
		private function onKlineMsg(msg:String):void
		{
			infoTxt.text = msg;
		}
		public function init():void
		{
			//stockSelect.labels = "300383,000546,000725,002064,600139";
			var tLabel:String;
			tLabel = StockBasicInfo.I.stockCodeList.join(",");
			trace("tLabel",tLabel);
			stockSelect.labels = tLabel;
			stockSelect.selectedIndex = 0;
			stockSelect.selectHandler = new Handler(this, onSelect);
			
			playBtn.on(Event.MOUSE_DOWN, this, onPlayBtn);
			playInputBtn.on(Event.MOUSE_DOWN, this, onPlayInput);
			var stock:String;
			stock = "300383";
			kLine.setStock(stock);
		}
		override protected function changeSize():void 
		{
			super.changeSize();
			kLine.lineHeight = this.height - 100;
			kLine.lineWidth = this.width - 20;
			kLine.pos(0, kLine.lineHeight + 90);
		}
		private function onSelect():void
		{
			kLine.autoPlay = false;
			kLine.setStock(stockSelect.selectedLabel);
		}
		private function onPlayBtn():void
		{
			kLine.autoPlay = true;
			kLine.setStock(stockSelect.selectedLabel);
		}
		private function onPlayInput():void
		{
			kLine.autoPlay = false;
			kLine.setStock(stockInput.text);
		}
	}

}