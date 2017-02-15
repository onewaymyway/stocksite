package nodetools.devices{
	
	/**
	 * 编辑器全局静态入口
	 * @author ww
	 */
	public class Sys {
		
		public static function mParseFloat(v:*):int
		{
			v = parseFloat(v);
			if (isNaN(v)) return 0;
			return v;
		}
		/**输出日志*/
		public static function log(... args):void {
			print("log", args, "#0080C0");
		}
		
		/**错误*/
		public static function error(... args):void {
			print("error", args, "#FF0000");
		}
		
		/**警告*/
		public static function warn(... args):void {
			print("warn", args, "#9B9B00");
		}
		
		/**插件*/
		public static function plugin(... args):void {
			print("plugin", args, "#007300");
		}
		
		private static function print(type:String, args:Array, color:String):void {
			var msg:String = "";
			for (var i:int = 0; i < args.length; i++) {
				msg += args[i] + " ";
			}
			trace("%c [" + type + "]" + msg, "color: " + color + "");
		}
		
		/**弹出警告框*/
		public static function alert(msg:String):void {

			trace(msg);

		}
		
		public static function lang(body:String, ...args):String {
			var i:int, len:int;
			len = args.length;
			for (i = 0; i < len; i++)
			{
				body = body.replace("{"+i+"}",args[i]);
			}
			return body;
		}
	}
}