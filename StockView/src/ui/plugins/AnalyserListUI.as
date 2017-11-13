/**Created by the LayaAirIDE,do not modify.*/
package ui.plugins {
	import laya.ui.*;
	import laya.display.*; 

	public class AnalyserListUI extends View {
		public var list:List;
		public var showSelect:CheckBox;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":160,"height":212},"child":[{"type":"List","props":{"y":19,"x":0,"width":160,"var":"list","vScrollBarSkin":"comp/vscroll.png","height":193},"child":[{"type":"Box","props":{"y":0,"x":0,"width":148,"renderType":"render","height":17},"child":[{"type":"Label","props":{"width":80,"text":"limittxt","name":"nameTxt","height":17,"color":"#e0211d"}},{"type":"CheckBox","props":{"x":92,"skin":"comp/checkbox.png","name":"ifShow","label":"启用","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}}]}]},{"type":"CheckBox","props":{"y":0,"x":2,"var":"showSelect","skin":"comp/checkbox.png","selected":true,"label":"显示插件列表","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}