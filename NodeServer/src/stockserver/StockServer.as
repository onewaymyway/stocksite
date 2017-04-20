package stockserver 
{
	import nodetools.server.WSServer;
	
	/**
	 * ...
	 * @author ww
	 */
	public class StockServer extends WSServer 
	{
		
		public function StockServer() 
		{
			super();
			clientClz = StockClient;
		}
		
	}

}