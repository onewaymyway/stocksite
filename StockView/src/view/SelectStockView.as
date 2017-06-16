package view {
	import laya.debug.tools.Notice;
	import laya.events.Event;
	import laya.math.ValueTools;
	import laya.maths.MathUtil;
	import laya.net.Loader;
	import laya.stock.StockTools;
	import laya.tools.StockJsonP;
	import laya.ui.Box;
	import laya.ui.Label;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import msgs.MsgConst;
	import ui.SelectStockViewUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class SelectStockView extends SelectStockViewUI {
		
		public function SelectStockView() {
			init();
		}
		public var dataUrl:String = "last.json";
		public var tType:String = "kline";
		private var stockDataGetter:StockJsonP;
		public static const SelectStockDataChange:String = "SelectStockDataChange";
		public function init():void {
			list.renderHandler = new Handler(this, stockRender);
			list.array = [];
			list.mouseHandler = new Handler(this, onMouseList);
			list.scrollBar.touchScrollEnable = true;
			
			Laya.loader.load(dataUrl, new Handler(this, dataLoaded), null, Loader.JSON);
			
			Notice.listen(MsgConst.Show_Next_Select, this, next);
			Notice.listen(MsgConst.Show_Pre_Select, this, pre);
			tip.text = "股票:当前盈利:最高盈利\n7天最大盈利,15天最大盈利,30天最大盈利,45天最大盈利\n买入日期";
			typeSelect.on(Event.CHANGE, this, onTypeChange);
			stockDataGetter = new StockJsonP();
			stockDataGetter.completeNotice = SelectStockDataChange;
			Notice.listen(SelectStockDataChange, this, onStockDataChange);
			autoFresh.on(Event.CHANGE, this, onAutoFreshChange);
			this.on(Event.DISPLAY, this, onAutoFreshChange);
			this.on(Event.UNDISPLAY, this, onAutoFreshChange);
		}
		
		private function onAutoFreshChange():void
		{
			if (autoFresh.selected&&this.displayedInStage)
			{
				stockDataGetter.startFresh();
			}else
			{
				stockDataGetter.stopFresh();
			}
		}
		private function onStockDataChange():void
		{
			reRenderCells();
		}
		
	
		
		private function onTypeChange():void {
			tType = typeSelect.selectedLabel;
			refreshData();
		}
		private var configO:Object;
		private var tDatas:Array;
		
		private function dataLoaded():void {
			var data:Array;
			configO = Loader.getRes(dataUrl);
			tDatas = configO["stocks"];
			initByConfigO();
			refreshData();
		}
		private var typeDic:Object = {};
		
		private function initByConfigO():void {
			var types:Array;
			types = configO["types"];
			if (!types)
				return;
			typeDic = {};
			var typesStr:Array;
			typesStr = [];
			var tTypeO:Object;
			var i:int, len:int;
			len = types.length;
			for (i = 0; i < len; i++) {
				tTypeO = types[i];
				typesStr.push(tTypeO.label);
				typeDic[tTypeO.label] = tTypeO;
			}
			typeSelect.labels = typesStr.join(",");
			typeSelect.selectedIndex = 0;
			tType = typeSelect.selectedLabel;
		}
		public var tDataKey:String = null;
		public static var DefalutTpl:String = "{#code#}";
		public var tTpl:String;
		private function refreshData():void {
			if (!tDatas)
				return;
			if (typeDic[tType]) {
				tDataKey = typeDic[tType].dataKey;
				tip.text = typeDic[tType].tip;
				tTpl=typeDic[tType].tpl;
				//tDatas.sort(MathUtil.sortByKey.apply(null, typeDic[tType]["sortParams"]));
				tDatas.sort(ValueTools.sortByKeyEX.apply(null, typeDic[tType]["sortParams"]));
			}
			else {
				tDataKey = null;
				tip.text = "股票列表";
				tDatas.sort(MathUtil.sortByKey("code", true, false));
			}
			list.array = tDatas;
		}
		public static var signList:Array = ["high7", "high15", "high30", "high45"];
		
		public function getStockChanges(stockO:Object):Array {
			var i:int, len:int;
			len = signList.length;
			var rst:Array;
			rst = [];
			var tSign:String;
			for (i = 0; i < len; i++) {
				tSign = signList[i];
				rst.push(Math.floor(stockO[tSign] * 100) + "%")
			}
			return rst;
		}
		
		public function stockRender(cell:Box, index:int):void {
			callLater(resetStocks);
			var item:Object = cell.dataSource;
			var label:Label;
			label = cell.getChildByName("label");
			var dataO:Object;
			dataO = ValueTools.getFlatKeyValue(item, tDataKey);
			if (!tTpl) tTpl = DefalutTpl;
			label.text = ValueTools.getTplStr(tTpl, dataO);
			renderStockRealTimeInfo(cell);
			
			//label.text = dataO.code + ":" + Math.floor(dataO.changePercent * 100) + "%" + ":" + Math.floor(dataO.highPercent * 100) + "%" + "\n" + getStockChanges(dataO).join(",") + "\n" + dataO.lastDate;
		}
		private function renderStockRealTimeInfo(cell:Box):void
		{
			var item:Object = cell.dataSource;	
			var label:Label;
			label = cell.getChildByName("info");
			if (!item)
			{
				label.text = "";
				return;
			}
			var stockData:Object;
			stockData=StockJsonP.getStockData(item.code)
			if (stockData)
			{
				label.text = ""+StockTools.getGoodPercent((stockData.price-stockData.close) / stockData.close) + "%";
			}else
			{
				label.text = "";
			}
		}
		
		private function reRenderCells():void
		{
			var cells:Array;
			cells = list.cells;
			if (!cells) return;
			var i:int, len:int;
			len = cells.length;
			var tCell:Object;
			for (i = 0; i < len; i++)
			{
				tCell = cells[i];
				if (tCell.dataSource && tCell.dataSource.code)
				{
					renderStockRealTimeInfo(tCell);
				}
			}
		}
		private function resetStocks():void
		{
			var cells:Array;
			cells = list.cells;
			if (!cells) return;
			var i:int, len:int;
			len = cells.length;
			stockDataGetter.reset();
			var tCell:Object;
			for (i = 0; i < len; i++)
			{
				tCell = cells[i];
				if (tCell.dataSource && tCell.dataSource.code)
				{
					var adptCode:String;
					adptCode = StockJsonP.getAdptStockStr(tCell.dataSource.code);
					stockDataGetter.addStock(adptCode);
				}
			}
		}
		
		public var tI:int = 0;
		private var preTime:Number = 0;
		
		public function onMouseList(e:Event, index:int):void {
			
			if (e.type == Event.MOUSE_UP) {
				var tTime:Number = Browser.now();
				if (tTime - preTime > 500)
				{
					preTime = tTime;
					return;
				}
					
				preTime = tTime;
				var tData:Object;
				tData = list.array[index];
				tI = index;
				if (!tData)
					return;
				trace(tData);
				setUpAnalyserData();
				Notice.notify(MsgConst.Show_Stock_KLine, tData.code);
			}
		}
		
		public function setUpAnalyserData():void {
			if (typeDic[tType]) {
				var analyserInfos:Array;
				analyserInfos = typeDic[tType]["analyserInfo"];
				if (!analyserInfos)
					return;
				var i:int, len:int;
				len = analyserInfos.length;
				for (i = 0; i < len; i++) {
					Notice.notify(MsgConst.Set_Analyser_Prop, analyserInfos[i]);
				}
				
			}
		}
		
		public function next():void {
			tI++;
			showI(tI);
		}
		
		public function pre():void {
			tI--;
			showI(tI);
		}
		
		public function showI(i:int):void {
			var index:int;
			index = i;
			if (index < 0)
				index = list.array.length - 1;
			index = index % list.array.length;
			var tData:Object;
			tData = list.array[index];
			tI = index;
			if (!tData)
				return;
			trace(tData);
			Notice.notify(MsgConst.Show_Stock_KLine, tData.code);
		}
	}

}