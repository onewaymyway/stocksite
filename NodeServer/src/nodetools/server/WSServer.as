package nodetools.server {
	import nodetools.devices.NodeJSTools;
	
	/**
	 * ...
	 * @author ww
	 */
	public class WSServer {
		
		public function WSServer() {
		
		}
		public var serverO:*;
		public var clients:Array = [];
		public var clientClz:Class;
		public function run(config:Object):void {
			var WebSocket:* = NodeJSTools.require("ws");
			var _self:WSServer;
			_self = this;
			var serverO = new WebSocket.Server(config);
			serverO.on('connection', function connection(ws) {
					_self.onConnection(ws);
				});
		}
		
		protected function createClient():WSClient
		{
			if (clientClz) return new clientClz();
			return new WSClient();
		}
		
		private function onConnection(ws:*) {
			var tClient:WSClient = createClient();
			tClient.init(ws,this);
			clients.push(tClient);			
		}
		public function removeClient(client:WSClient):void
		{
			var i:int, len:int;
			len = clients.length;
			for (i = 0; i < len; i++)
			{
				if (clients[i] == client)
				{
					clients.splice(i,1);
					break;
				}
			}
		}
		public function sendToAll(data:*, but:WSClient):void
		{
			var i:int, len:int;
			len = clients.length;
			var tClient:WSClient;
			for (i = 0; i < len; i++)
			{
				tClient = clients[i];
				if (tClient != but)
				{
					tClient.send(data);
				}
			}
		}
	}

}