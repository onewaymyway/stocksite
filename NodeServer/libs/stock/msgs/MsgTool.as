package  
{
	/**
	 * ...
	 * @author ww
	 */
	public class MsgTool 
	{
		
		public function MsgTool() 
		{
			
		}
		public static function createMsg(type:String, data:Object=null):Object
		{
			var rst:Object;
			rst = { };
			rst.type = type;
			rst.data = data;
			return rst;
		}
	}

}