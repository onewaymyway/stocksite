/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 
	import view.StockView;
	import view.KLineView;
	import view.SelectStockView;

	public class MainViewUI extends View {
		public var typeSelect:Tab;
		public var stockListView:StockView;
		public var kLineView:KLineView;
		public var selectView:SelectStockView;

		public static var uiView:Object ={"type":"View","props":{"width":445,"height":400},"child":[{"type":"Tab","props":{"y":4,"x":4,"var":"typeSelect","skin":"comp/tab.png","selectedIndex":0,"labels":"股票列表,K线动画,选股"}},{"type":"StockView","props":{"var":"stockListView","top":40,"runtime":"view.StockView","right":10,"left":10,"bottom":10}},{"type":"KLineView","props":{"var":"kLineView","top":40,"runtime":"view.KLineView","right":10,"left":10,"bottom":10}},{"type":"SelectStockView","props":{"var":"selectView","top":40,"runtime":"view.SelectStockView","right":10,"left":10,"bottom":10}}]};
		override protected function createChildren():void {
			View.regComponent("view.StockView",StockView);
			View.regComponent("view.KLineView",KLineView);
			View.regComponent("view.SelectStockView",SelectStockView);
			super.createChildren();
			createView(uiView);
		}
	}
}