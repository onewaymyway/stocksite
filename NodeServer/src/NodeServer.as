package {
	import nodetools.devices.NodeJSTools;
	import nodetools.server.WSServer;
	import stockserver.StockServer;
	
	/**
	 * ...
	 * @author ww
	 */
	public class NodeServer {
		
		public function NodeServer() {
			Laya.init();
			test();
		}
		
		private function test():void {
			var config:Object;
			config = {};
			config.perMessageDeflate = false;
			config.port = 9909;
			var mServer:WSServer;
			mServer = new StockServer();
			mServer.run(config);
		}
	}

}