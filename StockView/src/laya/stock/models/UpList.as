package laya.stock.models 
{
	/**
	 * ...
	 * @author ww
	 */
	public class UpList extends OrdedList
	{
		public function UpList()
		{
			
		}
		override public function isOK(left:Number, right:Number):Boolean 
		{
			return left < right;
		}
	}

}