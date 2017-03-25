package laya.math 
{
	/**
	 * ...
	 * @author ww
	 */
	public class ArrayMethods 
	{
		
		public function ArrayMethods() 
		{
			
		}
		public static function findFirstLowThen(v:int, arr:Array, startPos:int,step:int=1):int
		{
			
		}
		public static function findPos(v:int, arr:Array,key:String=null):Array
		{
			if (arr.length == 0) return [];
			var i:int, len:int;
			len = arr.length-1;
			var tV:int;
			i = 0;
			while (i < len&&getObjKeyV(arr[i],key)<v)
			{
				i++;
			}
			tV = getObjKeyV(arr[i], key);
			if (tV == v) return [i];
			if (tV < v) return [i, -1];
			if (tV > v)
			{
				return [i-1,i];
			}
			return [];
		}
		public static function getObjKeyV(obj:*, key:String = null):*
		{
			if (!key) return obj;
			return obj[key];
		}
		public static function isHighThenBefore(dataList:Array, index:int, count:int):Boolean
		{
			if (index <= 0) return false;
			var tV:Number;
			tV = dataList[index];
			var tI:int;
			var i:int, len:int;
			len = count;
			var tIndex:int;
			for (i = 1; i <= len; i++)
			{
				tIndex = index - i;
				if (tIndex <= 0) return false;
				if (dataList[tIndex] > tv) return false;
				
			}
			return true;
		}
	}

}