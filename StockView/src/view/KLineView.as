package view {
	import laya.debug.tools.Notice;
	import laya.events.Event;
	import laya.events.Keyboard;
	import laya.math.DataUtils;
	import laya.math.ValueTools;
	import laya.stock.analysers.AnalyserBase;
	import laya.stock.analysers.AverageLineAnalyser;
	import laya.stock.analysers.bars.VolumeBar;
	import laya.stock.analysers.BottomAnalyser;
	import laya.stock.analysers.BreakAnalyser;
	import laya.stock.analysers.ChanAnalyser;
	import laya.stock.analysers.DistAnalyser;
	import laya.stock.analysers.KLineAnalyser;
	import laya.stock.analysers.lines.AverageLine;
	import laya.stock.analysers.lines.PositionLine;
	import laya.stock.analysers.lines.StrongLine;
	import laya.stock.analysers.lines.WinRateLine;
	import laya.tools.StockJsonP;
	import laya.tools.WebTools;
	import laya.uicomps.MessageManager;
	import laya.utils.Handler;
	import msgs.MsgConst;
	import stock.prop.PropPanel;
	import stock.StockBasicInfo;
	import stock.views.KLine;
	import ui.KLineViewUI;
	import view.plugins.TradeTest;
	
	/**
	 * ...
	 * @author ww
	 */
	public class KLineView extends KLineViewUI {
		public var kLine:KLine;
		public var tAnalyser:AnalyserBase;
		
		public function KLineView() {
			kLine = new KLine();
			kLine.on(MsgConst.Stock_Data_Inited, this, onStockInited);
			dayScroll.on(Event.CHANGE, this, onDayScrollChange);
			maxDayEnable.on(Event.CHANGE, this, onPlayInput);
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
			analyserClassList.push(StrongLine);
			analyserClassList.push(AverageLineAnalyser);
			analyserClassList.push(DistAnalyser);
			
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
			
			addToStockBtn.on(Event.MOUSE_DOWN, this, onAddToStock);
			markBtn.on(Event.MOUSE_DOWN, this, onMarkBtn);
			this.on(Event.KEY_DOWN, this, onKeyDown);
		
			
			tradeSelect.selected = false;
			tradeSelect.on(Event.CHANGE, this, updateTradeVisible);
			updateTradeVisible();
			
			kLine.on(KLine.KlineShowed, this, onKlineShowed);
			
			tradeTest.on(TradeTest.NEXT_DAY, this, onNextDay);
			tradeTest.on(TradeTest.ANOTHER, this, onAnotherTradeTest);
		}
		
		private function onNextDay():void
		{
			dayScroll.value = dayScroll.value + 1;
		}
		
		private function onAnotherTradeTest():void
		{
			Notice.notify(MsgConst.Show_Stock_KLine, StockBasicInfo.I.getRandomStock());
		}
		private function onKlineShowed():void
		{
			tradeTest.setDataList(kLine.disDataList,kLine.tStock);
		}
		private function updateTradeVisible():void
		{
			tradeTest.visible = tradeSelect.selected;
			TradeTestManager.isTradeTestOn = tradeSelect.selected;
			if (tradeSelect.selected)
			{
				if (!maxDayEnable.selected)
				{
					maxDayEnable.selected = true;
				}
			}
		}
		private function onKeyDown(e:Event):void
		{
			switch(e.keyCode)
			{
				case Keyboard.DOWN:
					onNext();
					break;
				case Keyboard.UP:
					onPre();
					break;
				case Keyboard.LEFT:
					dayScroll.value = dayScroll.value - 1;
					break;
				case Keyboard.RIGHT:
					dayScroll.value = dayScroll.value + 1;
					break;
			}
		}
		private function onMarkBtn():void
		{
			Notice.notify(MsgConst.Add_MyStock, kLine.tStock );
			addToStockBtn.label = "删自选";
			Laya.timer.once(1000, this, markLater, [kLine.tStock]);
		}
		private function markLater(stock:String):void
		{
			Notice.notify(MsgConst.Mark_MyStock, stock);
		}
		
		private function onAddToStock():void
		{
			if (addToStockBtn.label == "加自选")
			{
				Notice.notify(MsgConst.Add_MyStock, kLine.tStock );
				MessageManager.I.show("add stock:" + kLine.tStock);
				addToStockBtn.label = "删自选";
			}else
			{
				Notice.notify(MsgConst.Remove_MyStock, kLine.tStock );
				MessageManager.I.show("remove stock:" + kLine.tStock);
				addToStockBtn.label = "加自选";
			}
			
		}
		private var preMouseX:Number;
		private var isLongPress:Boolean = false;
		private var isMyMouseDown:Boolean = false;
		private function onMMouseDown(e:Event):void {
			Laya.stage.focus = this;
			isMyMouseDown = false;
			if (e.target != this) return;
			isMyMouseDown = true;
			preMouseX = Laya.stage.mouseX;
			isLongPress = false;
			Laya.timer.once(800, this, longDown);
		}
		private function longDown():void
		{
			if (!maxDayEnable.selected) return;
			isLongPress = true;
			var dX:Number;
			dX = Laya.stage.mouseX - preMouseX;
			var tD:int;
			if (dX > 80) {
				tDayD = 1;
			}
			else if (dX < -80) {
				tDayD = -1;
			}
			Laya.timer.frameLoop(2, this, loopChangeDay);
		}
		private var tDayD:int = 0;
		private function loopChangeDay():void
		{
			dayScroll.value = dayScroll.value + tDayD;
		}
		private function onMMouseUp():void {
			if (!isMyMouseDown) return;
			Laya.timer.clear(this, longDown);
			Laya.timer.clear(this, loopChangeDay);
			if (isLongPress) return;
			var dX:Number;
			dX = Laya.stage.mouseX - preMouseX;
			if (dX > 100) {
				onNext();
			}
			else if (dX < -100) {
				onPre();
			}
			else {
				if (clickControlEnable) {
					
					if (Laya.stage.mouseX > Laya.stage.width * 0.5) {
						dayScroll.value = dayScroll.value + 1;
					}else
					{
						if (TradeTestManager.isTradeTestOn) return;
						dayScroll.value = dayScroll.value - 1;
					}
				}
				
			}
		}
		
		public function onSetAnalyserProps(analyserName:String, paramsO:Object):void {
			analyserList.setAnalyserParams(analyserName, paramsO);
			propPanel.refresh();
		}
		
		public function refreshKLine(freshRealTimeData:Boolean=true):void {
			showKline(kLine.tStock,freshRealTimeData);
		}
		
		private function showAnalyserProp(desArr:Array, dataO:Object):void {
			propPanel.visible = true;
			propPanel.initByData(desArr, dataO);
		}
		
		private function analysersChanged(analysers:Array):void {
			kLine.analysers = analysers;
			refreshKLine();
		}
		private var isFirstStockComing:Boolean = true;
		private var _preStock:String;
		
		public function showStockKline(stock:String):void {
			isFirstStockComing = true;
			stockInput.text = stock;
			tradeTest.tradeInfo.sellAll();
			onPlayInput();
			if (StockListManager.hasStock(stock))
			{
				addToStockBtn.label = "删自选";
			}else
			{
				addToStockBtn.label = "加自选";
			}
		}
		
		public function getDayCount():int {
			return ValueTools.mParseFloat(dayCountInput.text);
		}
		
		private function onStockInited():void {
			if (kLine.tStock == _preStock)
				return;
			_preStock = kLine.tStock;
			var max:Number;
			var dayCount:int;
			dayCount = getDayCount();
			max = kLine.dataList.length - dayCount;
			if (max < 0)
				max = 0;
			if (TradeTestManager.isTradeTestOn)
			{
				var tValue:int;
				tValue = Math.floor(Math.random() * max);
				dayScroll.setScroll(0, max, tValue);
			}else
			{
				dayScroll.setScroll(0, max, max);
			}
			
			if (maxDayEnable.selected) {
				kLine.start = Math.floor(dayScroll.value);
			}
			else {
				kLine.start = 0;
			}
		}
		
		private function onKlineMsg(msg:String):void {
			infoTxt.text = msg;
		}
		
		public function init():void {
			//stockSelect.labels = "300383,000546,000725,002064,600139";
			var tLabel:String;
			tLabel = StockBasicInfo.I.stockCodeList.join(",");
			//trace("tLabel", tLabel);
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
		
		private function onDayScrollChange():void {
			if (maxDayEnable) {
				onPlayInput();
			}
		}
		
		override protected function changeSize():void {
			super.changeSize();
			kLine.lineHeight = this.height - 100;
			kLine.lineWidth = this.width - 20;
			kLine.pos(0, kLine.lineHeight + 90);
		}
		
		private function onDetail():void {
			WebTools.openStockDetail(kLine.tStock);
		}
		
		private function onSelect():void {
			//kLine.autoPlay = enableAnimation.selected;
			showKline(stockSelect.selectedLabel);
		}
		
		private function onPlayBtn():void {
			//kLine.autoPlay = enableAnimation.selected;
			showKline(stockSelect.selectedLabel);
		}
		
		private function onPlayInput():void {
			//kLine.autoPlay = enableAnimation.selected;
			showKline(stockInput.text);
		}
		
		public function showKline(stock:String,freshRealTimeData:Boolean=true):void {
			kLine.autoPlay = enableAnimation.selected;
			if (freshRealTimeData)
			{
				StockJsonP.getStockData2(stock, Handler.create(this, refreshKLine, [false]));
			}
			if (maxDayEnable.selected) {
				kLine.maxShowCount = ValueTools.mParseFloat(dayCountInput.text);
				kLine.start = Math.floor(dayScroll.value);
			}
			else {
				kLine.maxShowCount = -1;
				kLine.start = 0;
				if (TradeTestManager.isTradeTestOn)
				{
					kLine.maxShowCount=Math.floor(dayScroll.value)+ValueTools.mParseFloat(dayCountInput.text);
				}
			}
			kLine.setStock(stock);
		}
		
		private function onPre():void {
			//Notice.notify(MsgConst.Show_Pre_Select);
			StockListManager.pre();
		}
		
		private function onNext():void {
			StockListManager.next();
			//Notice.notify(MsgConst.Show_Next_Select);
		}
	}

}