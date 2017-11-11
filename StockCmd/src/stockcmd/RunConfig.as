package stockcmd 
{
	/**
	 * ...
	 * @author ww
	 */
	public class RunConfig 
	{
		
		public function RunConfig() 
		{
			
		}
		public static var filePath:String = "res/stockdata";
		public static var minUnderDay:int = 3;
		public static var outFile:String = "lastBuys.json";
		public static var type:String = "RankWorker";
		public static var paramFile:String = "param.json";
		public static var tempCache:String = "";
		
	}

}