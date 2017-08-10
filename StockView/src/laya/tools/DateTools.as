package laya.tools 
{
	/**
	 * ...
	 * @author ww
	 */
	public class DateTools 
	{
		
		public function DateTools() 
		{
			
		}
		public static function getDate(time:Number=0):Date
		{
			var d:Date = new Date();
			if (time > 0)
			{
				d.setTime(time);
			}
			return d;
		}
		public static function getDateEx(addCount:int=-1):Date
		{
			var d:Date;
			d = getDate();
			d.setDate(d.getDate() + addCount);
			return d;
		}
		public static function getDateArr(d:Date):Array
		{
			return [d.getFullYear(),d.getMonth()+1,d.getDate()];
		}
		public static function getDateStr(d:Date=null,sign:String=""):String
		{
			if (!d) d = getDate();
			var arr:Array;
			arr = getDateArr(d);
			if (arr[1] < 10) arr[1] = "0" + arr[1];
			if (arr[2] < 10) arr[2] = "0" + arr[2];
			return arr.join(sign);
		}
		public static function getTimeStr(time:Number = -1, sign:String):String
		{
			return getDateStr(getDate(time),sign);
		}
	}

}