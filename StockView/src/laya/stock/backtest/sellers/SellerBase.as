package laya.stock.backtest.sellers 
{
	/**
	 * ...
	 * @author ww
	 */
	public class SellerBase 
	{
		public var dataList:Array;
		public var startIndex:int; 
		public var buyPrice:Number;
		public var sellDay:int;
		public var sellReason:String = "";
		public function SellerBase() 
		{
			
		}
		public function sell(dataList:Array,startIndex:int,buyPrice:Number):Number
		{
			this.dataList = dataList;
			this.startIndex = startIndex;
			this.buyPrice = buyPrice;
			sellDay = 0;
			return doSell();
		}
		
		public function doSell():Number
		{
			return buyPrice;
		}
	}

}