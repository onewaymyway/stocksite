/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class KLineViewUI extends View {
		public var stockSelect:ComboBox;
		public var playBtn:Button;
		public var infoTxt:Label;
		public var stockInput:TextInput;
		public var playInputBtn:Button;
		public var enableAnimation:CheckBox;

		public static var uiView:Object ={"type":"View","props":{"width":445,"height":400},"child":[{"type":"ComboBox","props":{"y":9,"x":8,"var":"stockSelect","skin":"comp/combobox.png","scrollBarSkin":"comp/vscroll.png","labels":"000233,600322"}},{"type":"Button","props":{"y":9,"x":114,"var":"playBtn","skin":"comp/button.png","label":"play"}},{"type":"Label","props":{"y":13,"x":225,"width":147,"var":"infoTxt","text":"label","height":20,"color":"#5be330"}},{"type":"TextInput","props":{"y":43,"x":8,"width":90,"var":"stockInput","text":"002234","skin":"comp/textinput.png","height":22}},{"type":"Button","props":{"y":42,"x":114,"var":"playInputBtn","skin":"comp/button.png","label":"play"}},{"type":"CheckBox","props":{"y":45,"x":226,"var":"enableAnimation","skin":"comp/checkbox.png","selected":true,"label":"开启动画"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}