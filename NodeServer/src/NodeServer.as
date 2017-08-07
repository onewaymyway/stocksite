package {
	import nodetools.devices.Device;
	import nodetools.devices.FileManager;
	import nodetools.devices.FileTools;
	import nodetools.devices.NodeJSTools;
	import nodetools.devices.OSInfo;
	import nodetools.devices.SystemSetting;
	import nodetools.server.WSServer;
	import stockserver.StockServer;
	import stockserver.users.UserSystem;
	
	/**
	 * ...
	 * @author ww
	 */
	public class NodeServer {
		
		public function NodeServer() {
			Laya.init();
			Device.init();
			SystemSetting.isCMDVer = true;
			OSInfo.init();
			//CMDShell.init();
			//Device.init();
			//初始化文件系统
			FileTools.init2();
			SystemSetting.appPath=NodeJSTools.getMyPath();
			UserSystem.UserPath = FileManager.getAppPath("user/");
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
			//UserSystem.I.createUser("deathnote","deathnotestock");
		}
	}

}