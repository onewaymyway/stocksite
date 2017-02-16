package view 
{
	import laya.debug.tools.Notice;
	import laya.events.Event;
	import laya.math.DataUtils;
	import laya.stock.analysers.KLineAnalyser;
	import laya.tools.WebTools;
	import laya.utils.Handler;
	import msgs.MsgConst;
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
		public var kLineAnalyser:KLineAnalyser;
		public function KLineView() 
		{
			kLineAnalyser = new KLineAnalyser();
			kLineAnalyser.leftLimit = 15;
			kLineAnalyser.rightLimit = 20;
			kLine = new KLine();
			kLine.analysers = [kLineAnalyser];
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
		public function showStockKline(stock:String):void
		{
			stockInput.text = stock;
			onPlayInput();
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
			
			detailBtn.on(Event.MOUSE_DOWN, this, onDetail);
			preBtn.on(Event.MOUSE_DOWN, this, onPre);
			nextBtn.on(Event.MOUSE_DOWN, this, onNext);
		}
		override protected function changeSize():void 
		{
			super.changeSize();
			kLine.lineHeight = this.height - 100;
			kLine.lineWidth = this.width - 20;
			kLine.pos(0, kLine.lineHeight + 90);
		}
		private function onDetail():void
		{
			WebTools.openStockDetail(kLine.tStock);
		}
		private function onSelect():void
		{
			//kLine.autoPlay = enableAnimation.selected;
			showKline(stockSelect.selectedLabel);
		}
		private function onPlayBtn():void
		{
			//kLine.autoPlay = enableAnimation.selected;
			showKline(stockSelect.selectedLabel);
		}
		private function onPlayInput():void
		{
			//kLine.autoPlay = enableAnimation.selected;
			showKline(stockInput.text);
		}
		public function showKline(stock:String):void
		{
			kLineAnalyser.leftLimit = DataUtils.mParseFloat(leftInput.text);
			kLineAnalyser.rightLimit = DataUtils.mParseFloat(rightInput.text);
			kLine.autoPlay = enableAnimation.selected;
			kLine.setStock(stock);
		}
		private function onPre():void
		{
			Notice.notify(MsgConst.Show_Pre_Select);
		}
		private function onNext():void
		{
			Notice.notify(MsgConst.Show_Next_Select);
		}
	}

}