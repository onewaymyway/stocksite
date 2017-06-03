/**Created by the LayaAirIDE,do not modify.*/
package ui.realtime {
	import laya.ui.*;
	import laya.display.*; 

	public class StockRealTimeItemUI extends View {
		public var txt:Label;
		public var delBtn:Button;
		public var showLine:CheckBox;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":402,"height":25},"child":[{"type":"Box","props":{"width":402,"height":25},"child":[{"type":"Label","props":{"wordWrap":true,"var":"txt","top":0,"text":"this is a list","skin":"comp/label.png","right":0,"name":"label","left":0,"fontSize":14,"color":"#efe82f","bottom":0,"borderColor":"#fb125d"}}]},{"type":"Button","props":{"y":0,"x":328,"var":"delBtn","skin":"comp/button.png","label":"删除","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"CheckBox","props":{"y":5,"x":281,"var":"showLine","skin":"comp/checkbox.png","label":"分时","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}