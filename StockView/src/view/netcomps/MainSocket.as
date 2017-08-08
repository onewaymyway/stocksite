package view.netcomps 
{
	import stock.StockSocket;
	/**
	 * ...
	 * @author ww
	 */
	public class MainSocket 
	{
		public static var I:MainSocket = new MainSocket();
		public var socket:StockSocket;
		public function MainSocket() 
		{
			socket = new StockSocket();
		}
		public var serverStr:String = "ws://127.0.0.1:9909";
		public function connect():void
		{
			socket.connect(serverStr);
		}
		
	}

}