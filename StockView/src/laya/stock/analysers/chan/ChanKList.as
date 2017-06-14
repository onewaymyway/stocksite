package laya.stock.analysers.chan 
{
	import laya.math.DataUtils;
	/**
	 * ...
	 * @author ww
	 */
	public class ChanKList 
	{
		
		public function ChanKList() 
		{
			
		}
		public static const GoUp:String = "up";
		public static const GoDown:String = "down";
		public static const None:String = "none";
		public static const Top:String = "top";
		public static const Bottom:String = "bottom";
		public var tState:String=None;
		public var dataList:Array;
		public function setDataList(dataList:Array):void
		{
			this.dataList = dataList;
			var i:int, len:int;
			len = dataList.length;
			var tData:Object;
			for (i = 0; i < len; i++)
			{
				tData = dataList[i];
				tData.cIndex = i;
				addData(dataList[i]);
			}
		}
		public function findTopBottoms():Array
		{
			var i:int, len:int;
			len = kList.length-1;
			var changePoints:Array;
			changePoints = [];
			var tType:String;
			for (i = 1; i < len; i++)
			{
				var tI:int;
				tI = getIndex(kList[i].topO);
				if (tI > 49 && tI < 52)
				{
					//debugger;
				}
				tType = DataUtils.getKLineType(kList, i, "top", "bottom");
				
				
				if (tType != DataUtils.K_Unknow)
				{
					changePoints.push([tType,kList[i]]);
				}
			}
			return changePoints;
		}
		public static function getIndex(dataO:Object):int
		{
			return dataO.cIndex;
		}
		public var kList:Array=[];
		public function addData(dataO:Object):void
		{
			var tK:ChanKBar;
			tK = ChanKBar.createByKO(dataO);
			tryAddK(tK);
		}
		public function tryAddK(tK:ChanKBar):void
		{
			if (kList.length < 1)
			{
				tK.state = None;
				kList.push(tK);
			}else
			{
				addK(tK);
			}
		}
		public function addK(newK:ChanKBar):void
		{
			var lastK:ChanKBar;
			lastK = kList[kList.length - 1];
			var tRelation:String;
			tRelation = ChanKBar.getRelativeType(lastK, newK);
			switch(tRelation)
			{
				case ChanKBar.GoDown:
					kList.push(newK);
					tState = GoDown;
					newK.state = tState;
					break;
				case ChanKBar.GoUp:
					kList.push(newK);
					tState = GoUp;
					newK.state = tState;
					break;
				case ChanKBar.In:
					tryMerge(newK);
					break;
				case ChanKBar.Cover:
					tryMerge(newK);
					break;
			}
		}
		
		public function tryMerge(newK:ChanKBar):void
		{
			var lastK:ChanKBar;
			lastK = kList.pop();
			lastK.merge(newK, tState);
			tryAddK(lastK);
		}
	}

}