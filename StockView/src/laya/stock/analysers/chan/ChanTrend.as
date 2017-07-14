package laya.stock.analysers.chan {
	
	/**
	 * ...
	 * @author ww
	 */
	public class ChanTrend {
		
		public function ChanTrend() {
		
		}
		
		public var typeList:Array;
		public var buyList:Array;
		public function initByData(dataList:Array):void {
			typeList = [];
			buyList = [];
			var i:int, len:int;
			len = dataList.length;
			var tData:Array;
			
			for (i = 0; i < len; i++) {
				addPoint(dataList[i]);
				tData = dataList[i];
				typeList.push([getTPosType(i, dataList), tData[0]]);
			}
			var tType:String;
			var preType:String;
			var tPointType:String;
			len = typeList.length;
			for (i = 0; i < len; i++)
			{
				tPointType = dataList[i][1];
				tType = typeList[i][0];
				if (tPointType=="low"&&preType == ChanKList.GoUp && tType == ChanKList.GoUp)
				{
					buyList.push(["buy",typeList[i][1]]);
				}
				preType = tType;
			}
		}
		
		public function addPoint(point:Array):void {
		
		}
		
		public function getTPosType(i:int, dataList:Array):String {
			if (i < 3)
				return ChanKList.None;
			var tData:Array;
			tData = dataList[i];
			var tType:String;
			tType = tData[1];
			var d0:Number;
			var d1:Number;
			d0 = getDValue(i - 3, i - 1, dataList);
			d1 = getDValue(i - 2, i, dataList);
			
			//低点
			if (d0 >= 0 && d1 >= 0) {
				return ChanKList.GoDown;
			}
			
			if (d0 <= 0 && d1 <= 0) {
				return ChanKList.GoUp;
			}
			
			if (d0 > 0 && d1 < 0)
			{
				return "0";
			}
			if (d0 < 0 && d1 > 0) {
				return "1";
			}
			
			return ChanKList.None;
		}
		
		public function getDValue(i:int, j:int, dataList:Array):Number {
			return dataList[i][2] - dataList[j][2];
		}
	}

}