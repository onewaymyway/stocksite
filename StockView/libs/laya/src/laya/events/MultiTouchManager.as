package laya.events
{
	import laya.debug.tools.DebugTxt;
	import laya.maths.Point;
	import laya.utils.Pool;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MultiTouchManager extends EventDispatcher
	{
		public static const Scale:String = "Scale";
		public static const MultiStart:String = "MultiStart";
		
		public static var I:MultiTouchManager = new MultiTouchManager();
		
		public function MultiTouchManager()
		{
		
		}
		private var downDic:Object = {};
		private var curDic:Object = {};
		private var curDownCount:int = 0;
		public static const PointSign:String = "PointSign";
		
		private function clearDic(dic:Object):void
		{
			var key:String;
			var tPoint:Point;
			for (key in dic)
			{
				tPoint = dic[key];
				if (tPoint is Point)
				{
					tPoint.setTo(0, 0);
					Pool.recover(PointSign, tPoint);
					delete dic[key];
				}
			}
		}
		
		public function resetState():void
		{
			clearDic(downDic);
			clearDic(curDic);
			curDownCount = 0;
		}
		
		public function onMouseMove(touchID:int):void
		{
			if (!curDic[touchID]) return;
			setPointToStagePoint(curDic, touchID);
		}
		
		private function setPointToStagePoint(dic:Object, touchID:int):void
		{
			var tPoint:Point;
			tPoint = dic[touchID];
			if (!tPoint) return;
			tPoint.setTo(MouseManager.instance.mouseX, MouseManager.instance.mouseY);
		
		}
		public function isMultiDown():Boolean
		{
			return curDownCount > 1;
		}
		
		public function onMouseDown(touchID:int):void
		{
			if (!downDic[touchID])
			{
				downDic[touchID] = Pool.getItemByClass(PointSign, Point);
				curDownCount += 1;
			}
			setPointToStagePoint(downDic, touchID);
			if (!curDic[touchID])
			{
				curDic[touchID] = Pool.getItemByClass(PointSign, Point);
			}
			setPointToStagePoint(curDic, touchID);
			if (curDownCount > 1) this.event(MultiStart);
		}
		
		private static var _centerPoint:Point = new Point();
		public function checkMouseGesture():void
		{
			var key:String;
			var pointParis:Array;
			pointParis = [];
			for (key in downDic)
			{
				if (curDic[key])
				{
					pointParis.push([downDic[key], curDic[key]]);
				}
			}
			if (pointParis.length == 2)
			{
				var preDistance:Number;
				preDistance = getPointDistance(pointParis[0][0], pointParis[1][0]);
				var curDistance:Number;
				curDistance = getPointDistance(pointParis[0][1], pointParis[1][1]);
				var scaleValue:Number;
				scaleValue = curDistance / preDistance;
				_centerPoint.x = 0.5 * (pointParis[0][0].x + pointParis[1][0].x);
				_centerPoint.y = 0.5 * (pointParis[0][0].y + pointParis[1][0].y);
				if (Math.abs(curDistance - preDistance) > 50)
				{
					this.event(Scale, [scaleValue,_centerPoint]);
				}
			}
		}
		
		private function getPointDistance(pA:Point, pB:Point):void
		{
			return pA.distance(pB.x, pB.y);
		}
		
		public function onMouseUp(touchID:int):void
		{
			if (!curDic[touchID])
			{
				resetState();
				return;
			}
			DebugTxt.dTrace("onMouseUp:",curDownCount);
			if (curDownCount == 2)
			{
				checkMouseGesture();
			}
			resetState();
		}
	}

}