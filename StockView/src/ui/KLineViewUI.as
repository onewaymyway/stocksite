/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class KLineViewUI extends View {
		public var stockSelect:ComboBox;
		public var playBtn:Button;

		public static var uiView:Object ={"type":"View","props":{"width":445,"height":400},"child":[{"type":"ComboBox","props":{"y":9,"x":8,"var":"stockSelect","skin":"comp/combobox.png","labels":"000233,600322"}},{"type":"Button","props":{"y":9,"x":114,"var":"playBtn","skin":"comp/button.png","label":"play"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}