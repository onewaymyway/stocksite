package view {
	import laya.events.Event;
	import laya.tools.WebTools;
	import laya.ui.Box;
	import laya.ui.Image;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import stock.StockBasicInfo;
	import ui.StockViewUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class StockView extends StockViewUI {
		
		public function StockView() {
		
		}
		
		public function init():void {
			stockList.renderHandler = new Handler(this, stockRender);
			stockList.array = StockBasicInfo.I.stockList;
			stockList.mouseHandler = new Handler(this, onMouseList);
			stockList.scrollBar.touchScrollEnable = true;
		}
		
		public function stockRender(cell:Box, index:int):void {
			var item:Object = cell.dataSource;
			var img:Image;
			img = cell.getChildByName("img");
			img.skin = "https://onewaymyway.github.io/stockdata/smallpics/" + item.code + ".png";
		
		}
		
		public function openUrl(path:String):void {
			Browser.window.open(path, "_blank");
		}
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
				tData = stockList.array[index];
				if (!tData)
					return;
				trace(tData);
				WebTools.openStockDetail(tData.code);
					//openUrl("http://stockhtm.finance.qq.com/sstock/ggcx/"+tData.code+".shtml");
			}
		}
	}

}