package  
{
	import stock.StockSocket;
	/**
	 * ...
	 * @author ww
	 */
	public class StockClient 
	{
		
		public function StockClient() 
		{
			Laya.init(1000, 900);
			test();
		}
		public function test():void
		{
			var sk:StockSocket;
			sk = new StockSocket();
			sk.connect("ws://127.0.0.1:9909");
		}
	}

}