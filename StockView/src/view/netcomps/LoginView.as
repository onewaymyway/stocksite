package view.netcomps 
{
	import laya.events.Event;
	import laya.net.LocalStorage;
	import laya.uicomps.MessageManager;
	import stock.StockSocket;
	import ui.netcomps.LoginViewUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class LoginView extends LoginViewUI 
	{
		
		public function LoginView() 
		{
			pwdInput.asPassword = true;
			this.visible = false;
			MainSocket.I.serverStr = "ws://orzooo.com:9909";
			//MainSocket.I.serverStr = "wss://orzooo.com:9909";
			MainSocket.I.connect();
			MainSocket.I.socket.on(StockSocket.Logined, this, onLogin);
			MainSocket.I.socket.on(StockSocket.Welcome, this, onConnected);
			loginBtn.on(Event.MOUSE_DOWN, this, onLoginBtn);
			logoutBtn.on(Event.MOUSE_DOWN, this, onLogOut);
		}
		
		private function onLogOut():void
		{
			MainSocket.I.socket.isLogined = false;
			MainSocket.I.socket.md5Pwd = "";
			pwdInput.text = "";
			saveLoginData();
			updateUIState();
			MessageManager.I.show("logout success");
		}
		
		public var DataSign:String = "loginInfo";
		private function onConnected():void
		{
			MessageManager.I.show("Connect to server success");
			this.visible = true;
			tryLogin();
		}
		
		private function tryLogin():void
		{	
			var data:Object;
			data = LocalStorage.getJSON(DataSign);
			if (data && data.user && data.pwd)
			{
				MessageManager.I.show("try login");
				MainSocket.I.socket.loginRaw(data.user, data.pwd);
			}
		}
		private function onLoginBtn():void
		{
			MessageManager.I.show("try login");
			MainSocket.I.socket.login(userNameInput.text, pwdInput.text);
		}
		
		private function onLogin():void
		{
			if (MainSocket.I.socket.isLogined)
			{
				saveLoginData();
			}
			updateUIState();
		}
		
		private function saveLoginData():void
		{
			var userData:Object;
				userData = { };
				userData.user = MainSocket.I.socket.userName;
				userData.pwd = MainSocket.I.socket.md5Pwd;
				LocalStorage.setJSON(DataSign, userData);
		}
		
		private function updateUIState():void
		{
			if (MainSocket.I.socket.isLogined)
			{
				MessageManager.I.show("login success");
				loginedBox.visible = true;
				loginBox.visible = false;
				usernameTxt.text = MainSocket.I.socket.userName;
			} else
			{
				MessageManager.I.show("login fail");
				loginedBox.visible = false;
				loginBox.visible = true;
			}
		}
	}

}