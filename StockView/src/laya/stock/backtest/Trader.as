package laya.stock.backtest 
{
	import laya.stock.backtest.sellers.SellerBase;
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class Trader 
	{
		
		public function Trader() 
		{
			
		}
		public function reset():void
		{
			staticInfoList = [];
		}
		
		public function getStaticInfo():Object
		{
			return BackTestInfo.getStaticInfoOfBuyList(staticInfoList);
		}
		public var stockData:StockData;
		public function setStockData(stockData:StockData):void
		{
			this.stockData = stockData;
		}
		
		public function runTest():void
		{
		}
		public function runLastBuy():void
		{
			
		}
		public function runAllBuy():void
		{
			
		}
		public function buyAt(index:int):void
		{
			
		}
		public var seller:SellerBase;
		public var staticInfoList:Array;
		public function buyStaticAt(index:int,maxDay:int=20,seller:SellerBase):void
		{
			var dataList:Array;
			dataList = stockData.dataList;
			var curInfo:Object;
			curInfo = dataList[index];
			if (!curInfo) return;
			staticInfoList.push(BackTestInfo.getStaticInfo(dataList,index,maxDay,seller,stockData.stockName));
		}
	}

}