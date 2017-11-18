package laya.stock.backtest 
{
	import laya.math.ValueTools;
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
			getBuyInfos(false);
		}
		public function runLastBuy():void
		{
			getBuyInfos(true);
		}
		public function runAllBuy():void
		{
			getBuyInfos(false);
		}
		public function getBuyInfos(onlyLast:Boolean = false):void 
		{
			
		}
		public function buyAt(index:int):void
		{
			
		}
		public var seller:SellerBase;
		public var staticInfoList:Array;
		public function buyStaticAt(index:int,maxDay:int=20,seller:SellerBase=null,dataO:Object=null):Object
		{
			var dataList:Array;
			dataList = stockData.dataList;
			var curInfo:Object;
			curInfo = dataList[index];
			if (!curInfo) return null;
			var tData:Object;
			tData = BackTestInfo.getStaticInfo(dataList, index, maxDay, seller, stockData.stockName);
			if (dataO)
			{
				tData.dataO = dataO;
			}
			staticInfoList.push(tData);
			return tData;
		}
	}

}