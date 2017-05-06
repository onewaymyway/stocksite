/**Created by the LayaAirIDE,do not modify.*/
package ui.realtime {
	import laya.ui.*;
	import laya.display.*; 
	import view.realtime.RealTimeItem;

	public class RealTimeUI extends View {
		public var list:List;
		public var autoFresh:CheckBox;
		public var freshBtn:Button;
		public var stockInput:TextInput;
		public var addBtn:Button;

		public static var uiView:Object ={"type":"View","props":{"width":445,"height":400},"child":[{"type":"List","props":{"y":10,"x":10,"var":"list","vScrollBarSkin":"comp/vscroll.png","top":30,"right":10,"repeatX":1,"left":10,"bottom":10},"child":[{"type":"StockRealTimeItem","props":{"y":0,"x":0,"runtime":"view.realtime.RealTimeItem","renderType":"render"}}]},{"type":"CheckBox","props":{"y":7,"x":7,"width":61,"var":"autoFresh","skin":"comp/checkbox.png","label":"自动刷新","height":19,"labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Button","props":{"y":3,"x":90,"var":"freshBtn","skin":"comp/button.png","label":"刷新","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"TextInput","props":{"y":5,"x":185,"width":90,"var":"stockInput","text":"002234","skin":"comp/textinput.png","height":22,"color":"#f1dede"}},{"type":"Button","props":{"y":4,"x":285,"var":"addBtn","skin":"comp/button.png","label":"添加","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}}]};
		override protected function createChildren():void {
			View.regComponent("view.realtime.RealTimeItem",RealTimeItem);
			super.createChildren();
			createView(uiView);
		}
	}
}