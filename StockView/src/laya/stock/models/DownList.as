package laya.stock.models 
{
	/**
	 * ...
	 * @author ww
	 */
	public class DownList extends OrdedList 
	{
		
		public function DownList() 
		{
			super();
			
		}
		override public function isOK(left:Number, right:Number):Boolean 
		{
			return left > right;
		}
	}

}