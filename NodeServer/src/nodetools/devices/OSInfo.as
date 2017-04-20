package nodetools.devices 
{
	/**
	 * ...
	 * @author ww
	 */
	public class OSInfo 
	{
		
		public function OSInfo() 
		{
			
		}
		public static var os:*;
		public static var platform:String;
		public static var homedir:String;
		public static var tempdir:String;
		public static var type:String;
		public static var process:*;
		public static var env:*;
		public static function init():void
		{
			os = Device.require("os");
			//trace("os:",os);
			//homedir = os.homedir();
			platform = os.platform();
			tempdir = os.tmpdir();
			type = os.type();
			var tProcess:*;
			__JS__("tProcess = process;");
			process = tProcess;
			env = process.env;
			//trace("env:",env);
			//trace("homdir:", homedir);
			//trace("platform:", platform);
			//trace("tempdir:", tempdir);
			trace("type:",type);
		}
	}

}