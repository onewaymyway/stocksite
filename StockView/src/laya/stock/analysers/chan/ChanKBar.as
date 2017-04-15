package laya.stock.analysers.chan 
{
	/**
	 * ...
	 * @author ww
	 */
	public class ChanKBar 
	{
		
		public function ChanKBar() 
		{
			
		}
		public var topO:Object;
		public var bottomO:Object;
		public var state:String;
		public function get top():Number
		{
			return topO["high"];
		}
		public function get bottom():Number
		{
			return bottomO["low"];
		}
		
		public function init(kO:Object):void
		{
			topO = kO;
			bottomO = kO;
		}
		public function merge(kO:ChanKBar,type:String):void
		{
			if (ChanKList.getIndex(kO.bottomO) == 79)
			{
				debugger;
			}
			switch(type)
			{
				case ChanKList.GoDown:
					
					mergeK(this, this, kO, false, true);
					break;
				case ChanKList.GoUp:
					
					mergeK(this, this, kO, true, false);
					break;
				case ChanKList.None:
					mergeK(this, this, kO, true, true);
					break;
			}
		}
		public static function mergeK(result:ChanKBar,kA:ChanKBar, kB:ChanKBar, maxTop:Boolean=true, minBottom:Boolean=true):void
		{
			if (kA.top > kB.top && maxTop)
			{
				result.topO = kA.topO;
			}else
			{
				result.topO = kB.topO;
			}
			if (kA.bottom < kB.bottom && minBottom)
			{
				result.bottomO = kA.bottomO;
			}else
			{
				result.bottomO = kB.bottomO;
			}
		}
		public static function createByKO(kO:Object):ChanKBar
		{
			var rst:ChanKBar;
			rst = new ChanKBar();
			rst.init(kO);
			return rst;
		}
		public static const GoUp:String = "up";
		public static const GoDown:String = "down";
		public static const In:String = "in";
		public static const Cover:String = "cover";
		public static function getRelativeType(chankBarA:ChanKBar, chankBarB:ChanKBar):String
		{
			if (chankBarA.top > chankBarB.top)
			{
				if (chankBarA.bottom > chankBarB.bottom)
				{
					return GoDown;
				}else
				{
					return Cover;
				}
			}else
		    if (chankBarA.top == chankBarB.top)
			{
				if (chankBarA.bottom > chankBarB.bottom)
				{
					return In;
				}else
				{
					return Cover;
				}
			}else
			{
				if (chankBarA.bottom >= chankBarB.bottom)
				{
					return In;
				}else
				{
					return GoUp;
				}
			}
		}
	}

}