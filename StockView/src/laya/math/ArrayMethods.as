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
		public static function removeItem(arr:Array, item:*):void
		{
			var i:int;
			for (i = arr.length - 1; i >= 0; i--)
			{
				if (arr[i] == item)
				{
					arr.splice(i, 1);
				}
			}
		}
		public static function getItemValues(arr:Array, key:String):Array
		{
			var i:int, len:int;
			len = arr.length;
			var rst:Array;
			rst = [];
			for (i = 0; i < len; i++)
			{
				rst.push(arr[i][key]);
			}
			return rst;
		}
		public static function findFirstLowThen(v:int, arr:Array, startPos:int,step:int=1):int
		{
			return 0;
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
		
		public static function isUps(dataList:Array,key:String, start:int, end:int):Boolean
		{
			var i:int, len:int;
			for (i = start + 1; i <= end; i++ )
			{
				if (dataList[i][key] < dataList[i - 1][key]) return false;
			}
			return true;
		}
		
		public static function isDowns(dataList:Array,key:String, start:int, end:int):Boolean
		{
			var i:int, len:int;
			for (i = start + 1; i <= end; i++ )
			{
				if (dataList[i][key] > dataList[i - 1][key]) return false;
			}
			return true;
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
				if (dataList[tIndex] > tV) return false;
				
			}
			return true;
		}
		
		public static function getMax(dataList:Array, key:String, start:int = 0, end:int = -1):Number
		{
			var rst:Number;
			rst = dataList[start][key];
			var i:int, len:int;
			len = dataList.length;
			if (end >= 0)
			{
				len = Math.min(end+1, len);
			}
			var tValue:Number;
			for (i = start; i < len; i++)
			{
				tValue = dataList[i][key];
				if (tValue > rst) rst = tValue;
			}
			return rst;
		}
		
		public static function getMin(dataList:Array, key:String, start:int = 0, end:int = -1):Number
		{
			var rst:Number;
			rst = dataList[start][key];
			var i:int, len:int;
			len = dataList.length;
			if (end >= 0)
			{
				len = Math.min(end+1, len);
			}
			var tValue:Number;
			for (i = start; i < len; i++)
			{
				tValue = dataList[i][key];
				if (tValue < rst) rst = tValue;
			}
			return rst;
		}
		public static function count(dataList:Array, key:String, judgeFun:Function):int
		{
			var i:int, len:int;
			len = dataList.length;
			var rst:int = 0;
			for (i = 0; i < len; i++)
			{
				if (judgeFun(dataList[i][key]))
				{
					rst++;
				}
			}
			return rst;
		}
		public static function sumKey(dataList:Array,key:String,start:int=0,end:int=-1):Number
		{
			var rst:Number;
			rst = 0;
			var i:int, len:int;
			len = dataList.length;
			if (end >= 0)
			{
				len = Math.min(end+1, len);
			}	
			for (i = start; i < len; i++)
			{
				rst += dataList[i][key];
			}
			return rst;
		}
		
		public static function averageKey(dataList:Array, key:String, start:int = 0, end:int = -1):Number
		{
			var rst:Number;
			rst = 0;
			var i:int, len:int;
			len = dataList.length;
			if (end >= 0)
			{
				len = Math.min(end+1, len);
			}	
			for (i = start; i < len; i++)
			{
				rst += dataList[i][key];
			}
			return rst/(len-start);
		}
		public static function averageFun(dataList:Array,fun:Function, start:int = 0, end:int = -1):Number
		{
			var rst:Number;
			rst = 0;
			var i:int, len:int;
			len = dataList.length;
			if (end >= 0)
			{
				len = Math.min(end+1, len);
			}	
			for (i = start; i < len; i++)
			{
				rst += fun(dataList[i]);
			}
			return rst/(len-start);
		}
		
		
	}

}