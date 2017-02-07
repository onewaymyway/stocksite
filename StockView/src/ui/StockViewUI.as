/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class StockViewUI extends View {
		public var stockList:List;

		public static var uiView:Object ={"type":"View","props":{"width":445,"height":400},"child":[{"type":"List","props":{"y":20,"x":20,"width":405,"var":"stockList","vScrollBarSkin":"comp/vscroll.png","top":20,"right":20,"left":20,"height":360,"bottom":20},"child":[{"type":"Box","props":{"width":120,"renderType":"render","height":80},"child":[{"type":"Image","props":{"width":100,"skin":"comp/image.png","name":"img","height":75}}]}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}