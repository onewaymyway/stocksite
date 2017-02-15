package nodetools.devices {

	/**
	 * 封装所有驱动级接口
	 * @author yung
	 */
	public class Device {
		
		public static var app:*;
		public static var appName:String = "LayaAir";
		public static var appPath:String;
		public static var dataPath:String;
		public static var tempPath:String;
		public static var workPath:String;
		public static var userHome:String;
		public static var extensionPath:String;
		
		public static var remote:*;
		public static var Buffer:Class;
		public static var electron:*;
		public static var win:*;
		public static function init():void {	
             Buffer=__JS__("Buffer");
		}
		public static function require(mod:String):*
		{
			//trace("require:",mod);
			var rst:*;
			__JS__("rst=require(mod)");
			return rst;
		}
		public static function requireRemote(mod:String):*
		{
			if (!remote) return require(mod);
			return remote.require(mod);
		}
	}
}