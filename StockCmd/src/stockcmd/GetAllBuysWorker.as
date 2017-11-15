package stockcmd 
{
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class GetAllBuysWorker extends GetLastBuysWorker
	{
		
		public function GetAllBuysWorker() 
		{
			
		}
		
		override public function doAnalyse(stockData:StockData):void 
		{
			tTrader.setStockData(stockData);
			tTrader.runAllBuy();
		}
	}

}