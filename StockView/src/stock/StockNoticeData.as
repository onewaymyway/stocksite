package stock 
{
	import laya.events.Event;
	import laya.math.structs.ListDic;
	import laya.maths.MathUtil;
	import laya.net.Loader;
	import laya.stock.StockTools;
	import laya.utils.Handler;
	/**
	 * ww
	 * @author ...
	 */
	public class StockNoticeData extends CSVParser 
	{
		private var _myLoader:Loader;
		public var noticeData:ListDic;
		private var _complete:Handler;
		public function StockNoticeData() 
		{
			super();
			_myLoader = new Loader();
		}
		public function load(stock:String,complete:Handler):void
		{
			this._complete = complete;
			_myLoader.once(Event.COMPLETE, this, dataLoaded);
			_myLoader.load(StockTools.getStockNoticePath(stock), Loader.TEXT);
		}
		private function dataLoaded(data:String):void
		{
			if (!data) return;
			this.init(data);
			if (_complete)
			{
				_complete.run();
				_complete = null;
			}
		}
		override public function init(csvStr:String):void 
		{
			super.init(csvStr);
			dataList.sort(MathUtil.sortByKey("date", false, false));
			noticeData = ListDic.createByList(dataList, "date");
		}
	}

}