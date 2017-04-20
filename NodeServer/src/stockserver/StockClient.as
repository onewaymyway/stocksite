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
			var data:Object;
			data = JSON.parse(message);
			trace(data);
			switch(data.type)
			{
				
			}
		}
		
		override public function onOpen():void 
		{
			sendJson(MsgTool.createMsg(StockMsg.Welcome));
		}
	}

}