package wrap
{
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
	
	/**
	 * ...
	 * @author ww
	 */
	public class FileSelect
	{
		private var _target:Sprite;
		private var _input:Object;
		public var autoClear:Boolean=true;
		public function FileSelect(target:Node, accept:String, changeHandler:Handler = null)
		{
			_changeHandler = changeHandler;
			_target = target as Sprite;	
			_input = Browser.createElement("input");
			_input.type = "file";
			_input.accept = accept;
			_myChangeH = Utils.bind(onChange, this);
			_input.addEventListener("change", _myChangeH);
			var canvas:* = Render.canvas;
			_clickH=function(e:*):void {
				if (!_target.displayedInStage) return;
				var bounds:Rectangle;
				bounds = _target.getSelfBounds();
				if (bounds.contains(_target.mouseX, _target.mouseY))
				{
					if (autoClear)
					{
						_input.value = "";
					}
					_input.click();
				}
			}
			canvas.addEventListener('click', _clickH);
		}
		private var _myChangeH:Function;
		private var _changeHandler:Handler;
		private var _clickH:Function;
		

		
		private function onChange(e:*):void
		{
			trace("change from fileSelect:", e);
			if (_changeHandler)
			{
				_changeHandler.runWith(e);
			}
		}
		
		public function dispose():void
		{
			if (_target)
			{
				//_target.off(Event.MOUSE_DOWN, this, click);
				_target = null;
			}
			if (_input)
			{
				_input.removeEventListener("change", _myChangeH);
				_myChangeH = null;
				_input = null;
			}
			if (_clickH)
			{
				var canvas:* = Render.canvas.source;
				canvas.removeEventListener('click', _clickH);
				_clickH = null;
			}
			_changeHandler = null;
		}
	}

}