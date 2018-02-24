package laya.stock 
{
	import laya.debug.tools.Notice;
	import laya.utils.Handler;
	import msgs.MsgConst;
	import stock.StockNoticeData;
	/**
	 * ...
	 * @author ww
	 */
	public class StockNoticeManager 
	{
		public static var I:StockNoticeManager = new StockNoticeManager();
		private static var _stockDic:Object = {};
		public static var noticeTypes:Array = [];
		public function StockNoticeManager() 
		{
			
		}
		public function loadStockNotice(stock:String):void
		{
			stock = StockTools.getPureStock(stock);
			if (_stockDic[stock]) return;
			//Laya.loader.load(
			var noticeData:StockNoticeData;
			noticeData = new StockNoticeData();
			noticeData.load(stock, Handler.create(this, onNoticeLoaded, [noticeData,stock]));
		}
		public function getStockNotice(stock:String):StockNoticeData
		{
			return _stockDic[stock];
		}
		private function onNoticeLoaded(noticeData:StockNoticeData,stock:String):void
		{
			_stockDic[stock] = noticeData;
			Notice.notify(MsgConst.Stock_NoticeLoaded, [stock]);
			Notice.notify(MsgConst.Fresh_KLineView);
		}
	}

}