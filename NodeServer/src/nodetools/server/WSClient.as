package nodetools.server 
{
	import laya.server.core.Utils;
	/**
	 * ...
	 * @author ww
	 */
	public class WSClient 
	{
		public var socketO:*;
		public var serverO:WSServer;
		public var funDic:Object = { };
		public function WSClient() 
		{
			funDic["message"] = Utils.bind(onMessage, this);
			funDic["close"] = Utils.bind(onClose, this);
			//funDic["open"] = Utils.bind(onOpen, this);
		}
		public function init(wsocket:*,server:*):void
		{
			this.serverO = server;
			var _this:WSClient;
			_this = this;
			socketO = wsocket;
			var key:String;
			for (key in funDic)
			{
				socketO.on(key, funDic[key]);
			}
			onOpen();
		}
		
		public function send(data:*):void
		{
			socketO.send(data);
		}
		public function sendJson(data:Object):void
		{
			send(JSON.stringify(data));
		}
		public function onMessage(message:*):void
		{
			trace("onMessage");
			trace('received: %s', message);
		}
		
		public function onClose(code:Number,reason:String):void
		{
			serverO.removeClient(this);
		}
		
		public function onOpen():void
		{
			trace("onOpen");
			send("hihi new client");
		}
		
	}

}