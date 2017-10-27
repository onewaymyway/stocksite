/**Created by the LayaAirIDE,do not modify.*/
package ui.netcomps {
	import laya.ui.*;
	import laya.display.*; 

	public class LoginViewUI extends View {
		public var loginBox:Box;
		public var userNameInput:TextInput;
		public var pwdInput:TextInput;
		public var loginBtn:Button;
		public var loginedBox:Box;
		public var logoutBtn:Button;
		public var usernameTxt:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":288,"height":26},"child":[{"type":"Box","props":{"y":2,"x":6,"var":"loginBox"},"child":[{"type":"TextInput","props":{"width":96,"var":"userNameInput","skin":"comp/input_24.png","prompt":"username","height":22,"color":"#f6e1e1"}},{"type":"TextInput","props":{"x":107,"width":96,"var":"pwdInput","skin":"comp/input_24.png","prompt":"pwd","height":22,"color":"#f6e1e1"}},{"type":"Button","props":{"x":212,"var":"loginBtn","skin":"comp/button.png","label":"login","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}}]},{"type":"Box","props":{"y":2,"x":8,"visible":false,"var":"loginedBox"},"child":[{"type":"Button","props":{"x":210,"var":"logoutBtn","skin":"comp/button.png","label":"logout","labelColors":"#efefef,#ffffff,#c5c5c5,#c5c5c5"}},{"type":"Label","props":{"width":141,"visible":true,"var":"usernameTxt","text":"username","height":20,"color":"#ffffff"}}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}