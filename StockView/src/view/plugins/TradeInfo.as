package view.plugins 
{
	import laya.uicomps.MessageManager;
	/**
	 * ...
	 * @author ww
	 */
	public class TradeInfo 
	{
		
		public function TradeInfo() 
		{
			reset();
		}
		public static const INIT_MONEY:Number = 100000;
		public var money:Number;
		public var stockCount:int;
		public var stockMoney:Number;
		public var tStockPrice:Number;
		public var totalWin:Number;
		public function reset():void
		{
			money = INIT_MONEY;
			stockCount = 0;
			stockMoney = 0;
			tStockPrice = 0;
			totalWin = 0;
		}
		
		public function sellAll():void
		{
			sellStock(tStockPrice, stockCount);
		}
		
		public function buyStock(price:Number, count:Number):void
		{
			var dStockMoney:Number;
			dStockMoney = price * count;
			if (money < dStockMoney)
			{
				MessageManager.I.show("资金不足");
				return;
			}
			stockCount += count;
			stockMoney += dStockMoney;
			money -= dStockMoney;
		}
		
		public function sellStock(price:Number, count:Number):void
		{
			if (stockCount < count)
			{
				MessageManager.I.show("股票不足");
				return;
			}
			var dStockMoney:Number;
			dStockMoney = price * count;
			stockCount -= count;
			stockMoney -= dStockMoney;
			money += dStockMoney;
			if (stockCount == 0)
			{
				stockMoney = 0;
			}
		}
		
		public function get stockWinRate():Number
		{
			if (stockCount <= 0) return 0;
			return tStockPrice / stockPrice-1;
		}
		
		public function get stockWinOfTotal():Number
		{
			return total-INIT_MONEY;
		}
		
		public function get stockWinRateOfTotal():Number
		{
			return stockWinOfTotal / INIT_MONEY;
		}
		
		public function get stockWin():Number
		{
			if (stockCount <= 0) return 0;
			return Math.floor((tStockPrice-stockPrice) * stockCount);
		}
		
		public function get stockPrice():Number
		{
			if (stockCount <= 0) return 0;
			return stockMoney / stockCount;
		}
		
		public function get curStockMoney():Number
		{
			return Math.floor(tStockPrice * stockCount);
		}
		public function get total():Number
		{
			return Math.floor(money + curStockMoney);
		}
		
		public function get position():Number
		{
			return curStockMoney / total;
		}
	}

}