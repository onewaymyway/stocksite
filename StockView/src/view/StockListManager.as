package view {
	import laya.debug.tools.Notice;
	import laya.stock.StockTools;
	import laya.tools.DateTools;
	import laya.tools.StockJsonP;
	import msgs.MsgConst;
	
	/**
	 * ...
	 * @author ww
	 */
	public class StockListManager {
		
		public function StockListManager() {
		
		}
		private static var _tI:int = 0;
		private static var _tStockList:Array;
		
		public static function setStockList(stockList:Array, tI:int):void {
			_tI = tI;
			_tStockList = stockList;
		}
		
		public static function next():void {
			_tI++;
			showI(_tI);
		}
		
		public static function pre():void {
			_tI--;
			showI(_tI);
		}
		
		public static function showI(i:int):void {
			if (!_tStockList)
				return;
			var index:int;
			index = i;
			if (index < 0)
				index = _tStockList.length - 1;
			index = index % _tStockList.length;
			var tData:Object;
			tData = _tStockList[index];
			_tI = index;
			if (!tData)
				return;
			
			trace(tData);
			Notice.notify(MsgConst.Show_Stock_KLine, [getStockCode(tData),tData]);
		}
		
		public static function getStockCode(data:*):void {
			if (!data)
				return "601918";
			var tStockStr:String;
			if (data is String) {
				tStockStr = data;
			}
			else {
				tStockStr = data.code;
			}
			return StockJsonP.getPureStock(tStockStr);
		}
		
		private static var _myStockList:Array;
		
		public static function setMyStockList(arr:Array):void
		{
			_myStockList = arr;
		}
		
		public static function hasStock(stock:String):Boolean
		{
			if(!_myStockList) return false;
			stock = StockTools.getAdptStockStr(stock);
			var i:int, len:int;
			len = _myStockList.length;
			for (i = 0; i < len; i++)
			{
				var tStockData:Object;
				tStockData = _myStockList[i];
				if (StockTools.getAdptStockCode(tStockData) == stock)
				{
					return true;
				}
			}
			return false;
		}
		public static function getStockLastMark(stock:String):String
		{
			if (!_myStockList) return null;
			stock = StockTools.getAdptStockStr(stock);
			var i:int, len:int;
			len = _myStockList.length;
			for (i = 0; i < len; i++)
			{
				var tStockData:Object;
				tStockData = _myStockList[i];
				if (StockTools.getAdptStockCode(tStockData) == stock)
				{
					if (tStockData.markTime)
					{
						return DateTools.getTimeStr(tStockData.markTime, "-");
					}
				}
			}
			return null;
		}
	}

}