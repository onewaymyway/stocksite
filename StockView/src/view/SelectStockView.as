package view {
	import laya.debug.tools.Notice;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.ui.Box;
	import laya.ui.Label;
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
		
		public function init():void {
			list.renderHandler = new Handler(this, stockRender);
			list.array = [];
			list.mouseHandler = new Handler(this, onMouseList);
			list.scrollBar.touchScrollEnable = false;
			
			Laya.loader.load(dataUrl, new Handler(this, dataLoaded), null, Loader.JSON);
			
			Notice.listen(MsgConst.Show_Next_Select, this, next);
			Notice.listen(MsgConst.Show_Pre_Select, this, pre);
		}
		
		private function dataLoaded():void {
			var data:Array;
			data = Loader.getRes(dataUrl);
			trace("lastInfo:", data);
			list.array = data;
		}
		
		
		public function stockRender(cell:Box, index:int):void {
			var item:Object = cell.dataSource;
			var label:Label;
			label = cell.getChildByName("label");
			label.text = item.path+":"+Math.floor(item.changePercent*100)+"%"+":"+Math.floor(item.highPercent*100)+"%"  + "\n" + item.lastDate;
		}
		public var tI:int = 0;
		
		public function onMouseList(e:Event, index:int):void {
			if (e.type == Event.MOUSE_DOWN) {
				var tData:Object;
				tData = list.array[index];
				tI = index;
				if (!tData)
					return;
				trace(tData);
				Notice.notify(MsgConst.Show_Stock_KLine, tData.path);
			}
		}
		
		public function next():void {
			tI++;
			showI(tI);
		}
		public function pre():void
		{
			tI--;
			showI(tI);
		}
		public function showI(i:int):void
		{
			var index:int;
			index = i;
			if (index < 0) index = list.array.length - 1;
			index = index % list.array.length;
			var tData:Object;
			tData = list.array[index];
			tI = index;
			if (!tData)
				return;
			trace(tData);
			Notice.notify(MsgConst.Show_Stock_KLine, tData.path);
		}
	}

}