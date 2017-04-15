/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 
	import view.plugins.AnalyserList;
	import stock.prop.PropPanel;

	public class KLineViewUI extends View {
		public var stockSelect:ComboBox;
		public var playBtn:Button;
		public var infoTxt:Label;
		public var stockInput:TextInput;
		public var playInputBtn:Button;
		public var enableAnimation:CheckBox;
		public var detailBtn:Button;
		public var preBtn:Button;
		public var nextBtn:Button;
		public var analyserList:AnalyserList;
		public var propPanel:PropPanel;
		public var dayScroll:HScrollBar;
		public var maxDayEnable:CheckBox;
		public var dayCountInput:TextInput;

		public static var uiView:Object ={"type":"View","props":{"width":800,"height":400},"child":[{"type":"ComboBox","props":{"y":9,"x":8,"var":"stockSelect","skin":"comp/combobox.png","scrollBarSkin":"comp/vscroll.png","labels":"000233,600322","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Button","props":{"y":9,"x":114,"var":"playBtn","skin":"comp/button.png","label":"play","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Label","props":{"y":13,"x":225,"width":147,"var":"infoTxt","text":"label","height":20,"color":"#ffffff"}},{"type":"TextInput","props":{"y":43,"x":8,"width":90,"var":"stockInput","text":"002234","skin":"comp/textinput.png","height":22,"color":"#f1dede"}},{"type":"Button","props":{"y":42,"x":114,"var":"playInputBtn","skin":"comp/button.png","label":"play","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"CheckBox","props":{"y":45,"x":226,"var":"enableAnimation","skin":"comp/checkbox.png","selected":true,"label":"开启动画","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Button","props":{"y":39,"x":301,"var":"detailBtn","skin":"comp/button.png","label":"详情","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Button","props":{"y":80,"x":11,"var":"preBtn","skin":"comp/button.png","label":"pre","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Button","props":{"y":80,"x":100,"var":"nextBtn","skin":"comp/button.png","label":"next","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"AnalyserList","props":{"var":"analyserList","top":10,"runtime":"view.plugins.AnalyserList","right":10}},{"type":"PropPanel","props":{"y":0,"var":"propPanel","runtime":"stock.prop.PropPanel","right":180}},{"type":"HScrollBar","props":{"y":101,"x":225,"width":166,"var":"dayScroll","skin":"comp/hscroll.png","height":13}},{"type":"CheckBox","props":{"y":76,"x":226,"var":"maxDayEnable","skin":"comp/checkbox.png","selected":false,"label":"天数限制","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"TextInput","props":{"y":73,"x":300,"width":90,"var":"dayCountInput","text":"180","skin":"comp/textinput.png","height":22,"color":"#f1dede"}}]};
		override protected function createChildren():void {
			View.regComponent("view.plugins.AnalyserList",AnalyserList);
			View.regComponent("stock.prop.PropPanel",PropPanel);
			super.createChildren();
			createView(uiView);
		}
	}
}