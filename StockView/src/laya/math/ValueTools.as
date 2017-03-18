package laya.math 
{
	/**
	 * ...
	 * @author ww
	 */
	public class ValueTools 
	{
		
		public function ValueTools() 
		{
			
		}
		public static function mParseFloat(v:*):Number
		{
			var tV:Number;
			tV = parseFloat(v);
			if (tV.toString() == "NaN") return 0;
			return tV;
		}
	}

}