/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class SelectStockViewUI extends View {
		public var list:List;
		public var tip:Label;
		public var typeSelect:ComboBox;

		public static var uiView:Object ={"type":"View","props":{"width":445,"height":400},"child":[{"type":"List","props":{"var":"list","vScrollBarSkin":"comp/vscroll.png","top":30,"right":10,"left":10,"bottom":10},"child":[{"type":"Box","props":{"y":0,"x":0,"width":168,"name":"render","height":61},"child":[{"type":"Label","props":{"wordWrap":true,"top":0,"text":"this is a list","skin":"comp/label.png","right":0,"name":"label","left":0,"fontSize":14,"color":"#83e726","bottom":0}}]}]},{"type":"Label","props":{"y":-41,"width":271,"var":"tip","text":"股票代码:当前盈利:最高盈利","right":40,"height":42,"color":"#f33713"}},{"type":"ComboBox","props":{"y":3,"var":"typeSelect","skin":"comp/combobox.png","selectedIndex":0,"right":20,"labels":"KLine,Position"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}