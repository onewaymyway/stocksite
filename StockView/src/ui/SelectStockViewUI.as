/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class SelectStockViewUI extends View {
		public var list:List;

		public static var uiView:Object ={"type":"View","props":{"width":445,"height":400},"child":[{"type":"List","props":{"var":"list","vScrollBarSkin":"comp/vscroll.png","top":10,"right":10,"left":10,"bottom":10},"child":[{"type":"Box","props":{"y":0,"x":0,"width":168,"name":"render","height":61},"child":[{"type":"Label","props":{"wordWrap":true,"top":0,"text":"this is a list","skin":"comp/label.png","right":0,"name":"label","left":0,"fontSize":14,"color":"#83e726","bottom":0}}]}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}