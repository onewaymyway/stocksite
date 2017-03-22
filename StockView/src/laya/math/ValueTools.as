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
		public static function makeNumArr(arr:Array):Array
		{
			var i:int, len:int;
			len = arr.length;
			for (i = 0; i < len; i++)
			{
				arr[i] = mParseFloat(arr[i]);
			}
			return arr;
		}
	}

}