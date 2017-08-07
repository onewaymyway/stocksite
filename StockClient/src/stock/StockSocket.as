package stock {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Socket;
	import laya.utils.Byte;
	
	/**
	 * ...
	 * @author ww
	 */
	public class StockSocket extends EventDispatcher{
		private var socket:Socket;
		public var userName:String;
		public var isLogined:Boolean;
		public static const DataFromServer:String="DataFromServer";
		public function StockSocket() {
		
		}
		
		public function connect(serverStr:String):void {
			socket = new Socket("127.0.0.1", 0, Byte);
			socket.disableInput = true;
			socket.connectByUrl(serverStr);
			socket.on(Event.OPEN, this, onConnect);
			socket.on(Event.MESSAGE, this, onMessage);
			socket.on(Event.ERROR, this, onErr);
			socket.on(Event.CLOSE, this, onClose);
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
					login("deathnote","deathnotestock");
					break;
				case StockMsg.Login: 
					isLogined = dataO.rst;
					saveUserData("stocks", [123,234]);
					break;
				case StockMsg.SaveMyStocks:
					getUserData("stocks");
					break;
				case StockMsg.GetStocks:
					event(DataFromServer, dataO );
					break;
			}
		}
		
		public function login(user:String, pwd:String):void {
			var mData:Object;
			mData = {};
			mData.type = StockMsg.Login;
			mData.user = user;
			mData.pwd = pwd;
			userName = user;
			sendJson(mData);
		}
		
		public function saveUserData(sign:String, data:*):void
		{
			var mData:Object;
			mData = {};
			mData.type = StockMsg.SaveMyStocks;
			mData.sign = sign;
			mData.data = data;
			sendJson(mData);
		}
		
		public function getUserData(sign:String):void
		{
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