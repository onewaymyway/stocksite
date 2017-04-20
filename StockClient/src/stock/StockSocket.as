package stock 
{
	import laya.events.Event;
	import laya.net.Socket;
	import laya.utils.Byte;
	/**
	 * ...
	 * @author ww
	 */
	public class StockSocket 
	{
		private var socket:Socket;
		public function StockSocket() 
		{
			
		}
		public function connect(serverStr:String):void
		{
			socket = new Socket("127.0.0.1", 0, Byte);
			socket.disableInput = true;
			socket.connectByUrl("ws://127.0.0.1:9909");
			socket.on(Event.OPEN, this, onConnect);
			socket.on(Event.MESSAGE, this, onMessage);
			socket.on(Event.ERROR, this, onErr);
			socket.on(Event.CLOSE, this,onClose);
		}
		private function onConnect():void 
		{
			trace('socket connect');
			sendJson({"type":"hello"});
		}
		private function onMessage(msg:String):void 
		{
			trace('socket onMessage');
			trace("Msg:"+msg);
	        
		}
		private var msgID:int = 0;
		private function send(msg:String):void
		{
			msgID++;
			msg = msg + msgID;
			trace("try send:"+msg);
			socket.send(msg);
		}
		public function sendJson(obj:Object):void
		{
			if (!obj) return;
			socket.send(JSON.stringify(obj));
		}
		private function closeLater():void
		{
			socket.close();
			trace("after close");
		}
		private function onErr(e:*):void 
		{
			trace('socket onErr',e);
		}
		private function onClose():void 
		{
			trace('socket onClose');
			//Laya.timer.once(1000, this, closeLater);
		}
	}

}