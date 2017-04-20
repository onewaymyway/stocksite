package {
	import laya.server.core.Timer;
	/**
	 * 全局引用类
	 */
	public class Laya {
		
		/**时钟管理器*/
		public static var timer:Timer = new Timer();
		
		/**
		 * 初始化引擎
		 * @param	frameRate 时钟帧率
		 */
		public static function init(frameRate:int = 60):void {
			setInterval(function():void{timer._update()},1000 / frameRate);
		}
	}
}