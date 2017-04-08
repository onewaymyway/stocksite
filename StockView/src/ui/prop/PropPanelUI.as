/**Created by the LayaAirIDE,do not modify.*/
package ui.prop {
	import laya.ui.*;
	import laya.display.*; 

	public class PropPanelUI extends View {
		public var title:Label;
		public var okBtn:Button;
		public var propBox:Box;

		public static var uiView:Object ={"type":"View","props":{"width":230,"height":400},"child":[{"type":"Label","props":{"y":18,"x":18,"width":80,"var":"title","text":"属性设置","height":20,"color":"#e72b28"}},{"type":"Button","props":{"y":13,"x":100,"var":"okBtn","skin":"comp/button.png","label":"应用设置","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Box","props":{"y":45,"x":13,"width":190,"var":"propBox","height":237}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}