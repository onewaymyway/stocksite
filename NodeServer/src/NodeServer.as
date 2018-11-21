package
{
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
	public class NodeServer
	{
		
		public function NodeServer()
		{
			Laya.init();
			Device.init();
			SystemSetting.isCMDVer = true;
			OSInfo.init();
			//CMDShell.init();
			//Device.init();
			//初始化文件系统
			FileTools.init2();
			SystemSetting.appPath = NodeJSTools.getMyPath();
			UserSystem.UserPath = FileManager.getAppPath("user/");
			test();
		}
		
		private function readFile(file:String):*
		{
			return FileTools.fs.readFileSync(file);
		}
		
		private function test():void
		{
			
			var https = Device.require('https');
			var sslConfig:Object = {};
			sslConfig.key = readFile("ca/ssl.key");
			sslConfig.cert = readFile("ca/ssl.crt");
			trace(sslConfig);
			
			var server:* = https.createServer(sslConfig, function(req:*, res:*):void
			{//要是单纯的https连接的话就会返回这个东西
				res.writeHead(403);//403即可
				res.end("This is a  WebSockets server!\n");
			}).listen(9919);
			var config:Object;
			config = {ssl_key: 'ca/ssl.key', ssl_cert: 'ca/ssl.crt'};
			config = {};
			config.perMessageDeflate = false;
			//config.port = 9909;
			config.server = server;
			
			var mServer:WSServer;
			mServer = new StockServer();
			mServer.run(config);
			//UserSystem.I.createUser("deathnote","deathnotestock");
		}
	}

}