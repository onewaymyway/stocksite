package stock {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Socket;
	import laya.uicomps.MessageManager;
	import laya.utils.Byte;
	import stock.tools.SMD5;
	
	/**
	 * ...
	 * @author ww
	 */
	public class StockSocket extends EventDispatcher {
		private var socket:Socket;
		public var userName:String;
		public var md5Pwd:String;
		public var isLogined:Boolean;
		private var _serverStr:String;
		public static const DataFromServer:String = "DataFromServer";
		public static const Logined:String = "Logined";
		public static const OnServerMsg:String = "OnServerMsg";
		public static const Welcome:String = "Welcome";
		
		public function StockSocket() {
			socket = new Socket("127.0.0.1", 0, Byte);
			socket.disableInput = true;
			
			socket.on(Event.OPEN, this, onConnect);
			socket.on(Event.MESSAGE, this, onMessage);
			socket.on(Event.ERROR, this, onErr);
			socket.on(Event.CLOSE, this, onClose);
		}
		
		public function connect(serverStr:String):void {
			_serverStr = serverStr;
			socket.connectByUrl(serverStr);
		}
		
		private function onConnect():void {
			trace('socket connect');
			sendJson({"type": "hello"});
		}
		
		private function onMessage(msg:String):void {
			trace('socket onMessage');
			trace("Msg:" + msg);
			var dataO:Object;
			dataO = JSON.parse(msg);
			var mData:Object;
			switch (dataO.type) {
				case StockMsg.Welcome: 
					//login("deathnote", "deathnotestock");
					event(Welcome);
					break;
				case StockMsg.Login: 
					isLogined = dataO.rst;
					event(Logined);
					//saveUserData("stocks", [123, 234]);
					break;
				case StockMsg.SaveMyStocks: 
					//getUserData("stocks");
					MessageManager.I.show("saveMessage success");
					break;
				case StockMsg.GetStocks: 
					event(DataFromServer, dataO);
					event(dataO.sign, dataO);
					break;
			}
			event(OnServerMsg, dataO);
		}
		
		public function login(user:String, pwd:String):void {
			loginRaw(user, SMD5.md5(pwd, user, null));
		}
		
		public function loginRaw(user:String, pwd:String):void
		{
			var mData:Object;
			mData = {};
			mData.type = StockMsg.Login;
			mData.user = user;
			md5Pwd = pwd;
			mData.pwd = pwd;
			userName = user;
			sendJson(mData);
		}
		public function saveUserData(sign:String, data:*):void {
			MessageManager.I.show("try saveUserData:"+sign);
			var mData:Object;
			mData = {};
			mData.type = StockMsg.SaveMyStocks;
			mData.sign = sign;
			mData.data = data;
			sendJson(mData);
		}
		
		public function getUserData(sign:String):void {
			MessageManager.I.show("try getUserData:" + sign);
			var mData:Object;
			mData = {};
			mData.type = StockMsg.GetStocks;
			mData.sign = sign;
			sendJson(mData);
		}
		
		private var msgID:int = 0;
		
		private function send(msg:String):void {
			msgID++;
			msg = msg + msgID;
			trace("try send:" + msg);
			socket.send(msg);
		}
		
		public function sendJson(obj:Object):void {
			if (!obj)
				return;
			socket.send(JSON.stringify(obj));
		}
		
		private function closeLater():void {
			socket.close();
			trace("after close");
		}
		
		private function onErr(e:*):void {
			trace('socket onErr', e);
		}
		
		private function onClose():void {
			trace('socket onClose');
			//Laya.timer.once(1000, this, closeLater);
		}
	}

}