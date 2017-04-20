package stockserver 
{
	import laya.server.core.Byte;
	import nodetools.server.WSClient;
	
	/**
	 * ...
	 * @author ww
	 */
	public class StockClient extends WSClient 
	{
		public var mServer:StockServer;
		public function StockClient() 
		{
			super();
			
		}
		override public function init(wsocket:*, server:*):void 
		{
			super.init(wsocket, server);
			mServer = server;
		}
		override public function onMessage(message:*):void 
		{
			trace("StockClient:onMessage", message);
			var byte:Byte;
			byte = new Byte(message);
			var str:String;
			str = byte.readUTFBytes();
			trace(str);
		}
		
		override public function onOpen():void 
		{
			send("this is wsserver");
		}
	}

}