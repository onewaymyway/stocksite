package view 
{
	import laya.debug.tools.Notice;
	import laya.events.Event;
	import laya.math.DataUtils;
	import laya.stock.analysers.AnalyserBase;
	import laya.stock.analysers.bars.VolumeBar;
	import laya.stock.analysers.BottomAnalyser;
	import laya.stock.analysers.BreakAnalyser;
	import laya.stock.analysers.ChanAnalyser;
	import laya.stock.analysers.KLineAnalyser;
	import laya.stock.analysers.lines.AverageLine;
	import laya.stock.analysers.lines.PositionLine;
	import laya.stock.analysers.lines.WinRateLine;
	import laya.tools.WebTools;
	import laya.utils.Handler;
	import msgs.MsgConst;
	import stock.prop.PropPanel;
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
		public var tAnalyser:AnalyserBase;
		public function KLineView() 
		{
			kLine = new KLine();
			kLine.analysers = [];
			var analyserClassList:Array;
			analyserClassList = [];
			analyserClassList.push(KLineAnalyser);
			analyserClassList.push(BreakAnalyser);
			analyserClassList.push(BottomAnalyser);
			analyserClassList.push(AverageLine);
			analyserClassList.push(VolumeBar);
			analyserClassList.push(WinRateLine);
			analyserClassList.push(PositionLine);
			analyserClassList.push(ChanAnalyser);
			
			analyserList.initAnalysers(analyserClassList);
			addChild(kLine);
			var stock:String;
			stock = "300383";
			//stock = "000546";
			//stock = "000725";
			stock = "002064";
			//stock = "600139";
			//kLine.maxShowCount = 180;
			kLine.pos(0, kLine.lineHeight + 90);
			kLine.on("msg", this, onKlineMsg);
			init();
			propPanel.visible = false;
			Notice.listen(MsgConst.AnalyserListChange, this, analysersChanged);
			Notice.listen(MsgConst.Show_Analyser_Prop, this, showAnalyserProp);
			Notice.listen(MsgConst.Set_Analyser_Prop, this, onSetAnalyserProps);
			propPanel.on(PropPanel.MakeChange, this, refreshKLine);
			this.on(Event.MOUSE_DOWN, this, onMMouseDown);
			this.on(Event.MOUSE_UP, this, onMMouseUp);
			enableAnimation.selected = false;
		 
		}
		private var preMouseX:Number;
		private function onMMouseDown():void
		{
			preMouseX = Laya.stage.mouseX;
		}
		private function onMMouseUp():void
		{
			var dX:Number;
			dX = Laya.stage.mouseX - preMouseX;
			if (dX > 100)
			{
				onNext();
			}else if(dX<-100)
			{
				onPre();
			}
		}
		public function onSetAnalyserProps(analyserName:String,paramsO:Object):void
		{
			analyserList.setAnalyserParams(analyserName, paramsO);
			propPanel.refresh();
		}
		public function refreshKLine():void
		{
			showKline(kLine.tStock);
		}
		private function showAnalyserProp(desArr:Array, dataO:Object):void
		{
			propPanel.visible = true;
			propPanel.initByData(desArr, dataO);
		}
		private function analysersChanged(analysers:Array):void
		{
			kLine.analysers = analysers;
			refreshKLine();
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