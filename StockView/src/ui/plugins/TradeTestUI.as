/**Created by the LayaAirIDE,do not modify.*/
package ui.plugins {
	import laya.ui.*;
	import laya.display.*; 

	public class TradeTestUI extends View {
		public var buyBtn:Button;
		public var sellBtn:Button;
		public var tradeInfoTxt:Label;
		public var resetBtn:Button;
		public var anotherBtn:Button;
		public var countTxt:TextInput;
		public var nextDayBtn:Button;
		public var stockInfoTxt:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":271,"height":137},"child":[{"type":"Button","props":{"y":78,"x":113,"var":"buyBtn","skin":"comp/button.png","label":"买入","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Button","props":{"y":79,"x":195,"var":"sellBtn","skin":"comp/button.png","label":"卖出","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Label","props":{"y":0,"x":0,"width":139,"var":"tradeInfoTxt","text":"总金额:xxxx\\n股票:xxxx\\n总盈亏:xxxx\\n持仓盈亏:xxx","height":74,"color":"#f33713"}},{"type":"Button","props":{"y":111,"x":31,"var":"resetBtn","skin":"comp/button.png","label":"重置","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Button","props":{"y":112,"x":113,"var":"anotherBtn","skin":"comp/button.png","label":"随机开局","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"TextInput","props":{"y":79,"x":36,"width":66,"var":"countTxt","text":"300","skin":"comp/textinput.png","height":22,"color":"#f1dede"}},{"type":"Button","props":{"y":111,"x":195,"var":"nextDayBtn","skin":"comp/button.png","label":"下一天","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Label","props":{"y":84,"x":2,"text":"数量","color":"#ee1613"}},{"type":"Label","props":{"y":0,"x":165,"width":104,"var":"stockInfoTxt","text":"当前股价:xxx","height":74,"color":"#f33713"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}