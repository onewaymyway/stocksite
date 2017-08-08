package view.netcomps 
{
	import laya.events.Event;
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
			MainSocket.I.connect();
			MainSocket.I.socket.on(StockSocket.Logined, this, onLogin);
			MainSocket.I.socket.on(StockSocket.Welcome, this, onConnected);
			loginBtn.on(Event.MOUSE_DOWN, this, onLoginBtn);
		}
		
		private function onConnected():void
		{
			this.visible = true;
		}
		private function onLoginBtn():void
		{
			MainSocket.I.socket.login(userNameInput.text, pwdInput.text);
		}
		
		private function onLogin():void
		{
			updateUIState();
		}
		
		private function updateUIState():void
		{
			if (MainSocket.I.socket.isLogined)
			{
				usernameTxt.visible = true;
				loginBox.visible = false;
				usernameTxt.text = MainSocket.I.socket.userName;
			} else
			{
				usernameTxt.visible = false;
				loginBox.visible = true;
			}
		}
	}

}