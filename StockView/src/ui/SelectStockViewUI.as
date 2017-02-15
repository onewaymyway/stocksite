/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class SelectStockViewUI extends View {
		public var list:List;

		public static var uiView:Object ={"type":"View","props":{"width":445,"height":400},"child":[{"type":"List","props":{"y":14,"x":20,"width":181,"var":"list","vScrollBarSkin":"comp/vscroll.png","repeatX":1,"height":299},"child":[{"type":"Box","props":{"y":0,"x":0,"width":112,"name":"render","height":30},"child":[{"type":"Label","props":{"y":5,"x":2,"width":78,"text":"this is a list","skin":"comp/label.png","name":"label","height":20,"fontSize":14,"color":"#83e726"}}]}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}