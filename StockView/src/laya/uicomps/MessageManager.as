package laya.uicomps {
	
	import laya.display.Sprite;
	import laya.maths.Rectangle;
	import laya.ui.Box;
	import laya.ui.Label;
	import laya.utils.Browser;
	import laya.utils.Ease;
	import laya.utils.Tween;
	
	/**消息管理器
	 */
	public class MessageManager extends Sprite {
		private static var _instance:MessageManager;
		
		public static function get I():MessageManager {
			return _instance ? _instance : _instance = new MessageManager();
		}
		
		private var _vbox:Box = new Box();
		
		public function MessageManager() {
			addChild(_vbox);
			this.setBounds(new Rectangle(0, 0, 150, 150));
			Laya.stage.addChild(this);
//			mouseEnabled = mouseChildren = false;
		}
		private var preTime:int = 0;
		
		public function show(msg:String, color:String = "#ff0000", time:int = 1000):void {
			var label:Label = new Label();
			label.fontSize = 14;
			label.text = msg;
			label.y = 100;
			label.height = 30;
			
			var delayTime:int;
			var nowTime:int;
			var startTime:int;
			nowTime = Browser.now();
			startTime = Math.max(preTime + 500, nowTime);
			delayTime = startTime - nowTime;
			preTime = startTime;
			Laya.timer.once(delayTime, this, showLabel, [label, time], false);
		
		}
		
		private function showLabel(label:Label, time:int):void {
			this.pos(Laya.stage.width * 0.5 - 100, 20);
			_vbox.addChild(label);
			Tween.to(label, {y: -20}, time, Ease.cubicOut, null);
			Laya.timer.once(time, this, clear, [label], false);
		}
		
		private function clear(label:Label):void {
			label.removeSelf();
		}
	}
}