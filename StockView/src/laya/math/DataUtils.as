package laya.math 
{
	/**
	 * ...
	 * @author ww
	 */
	public class DataUtils 
	{
		
		public function DataUtils() 
		{
			
		}
		public static function mParseFloat(v:*):Number
		{
			var rst:Number;
			rst = parseFloat(v);
			if (isNaN(rst)) return 0;
			return rst;
		}
		public static function getKeyMax(datas:Array, key:String):Number
		{
			var i:int, len:int;
			len = datas.length;
			var tV:Number;
			tV = mParseFloat(datas[0][key]);
			for (i = 0; i < len; i++)
			{
				if (mParseFloat(datas[i][key]) > tV)
				{
					tV = mParseFloat(datas[i][key]);
				}
			}
			return tV;
		}
		public static function getKeyMaxI(datas:Array, key:String):Number
		{
			var i:int, len:int;
			len = datas.length;
			var tV:Number;
			tV = mParseFloat(datas[0][key]);
			var tI:Number = 0;
			for (i = 0; i < len; i++)
			{
				if (mParseFloat(datas[i][key]) > tV)
				{
					tV = mParseFloat(datas[i][key]);
					tI = i;
				}
			}
			return tI;
		}
		
		public static function getKeyMin(datas:Array, key:String):Number
		{
			var i:int, len:int;
			len = datas.length;
			var tV:Number;
			tV = mParseFloat(datas[0][key]);
			for (i = 0; i < len; i++)
			{
				if (mParseFloat(datas[i][key]) < tV)
				{
					tV = mParseFloat(datas[i][key]);
				}
			}
			return tV;
		}
		public static function getKeyMinI(datas:Array, key:String):Number
		{
			var i:int, len:int;
			len = datas.length;
			var tV:Number;
			tV = mParseFloat(datas[0][key]);
			var tI:Number = 0;
			for (i = 0; i < len; i++)
			{
				if (mParseFloat(datas[i][key]) < tV)
				{
					tV = mParseFloat(datas[i][key]);
					tI = i;
				}
			}
			return tI;
		}
		public static function getMaxInfo(datas:Array):Array
		{
			var rst:Array;
			rst = [];
			var i:int, len:int;
			len = datas.length;
			for (i = 0; i < len; i++)
			{
				rst.push(getIMaxInfo(i, datas));
			}
			return rst;
		}
		public static function getIMaxInfo(index:int,datas:Array):Object
		{
			var i:int, len:int;
			len = datas.length;
			var mValue:Number;
			mValue = datas[index]["high"];
			var rst:Object;
			rst = { };
			
			i = index;
			while (i > 0 && datas[i - 1]["high"] < mValue) i--;
			if (i==0)
			{
				i = -99;
			}
			rst["highL"] = index - i;
			
			i = index;
			while (i < len - 1 && datas[i + 1]["high"] < mValue) i++;
			if (i==len-1)
			{
				i = len+99;
			}
			rst["highR"] = i - index;
			
			rst["high"] = Math.min(rst["highL"], rst["highR"]);
			rst["highM"] = Math.max(rst["highL"],rst["highR"]);
			
			mValue = datas[index]["low"];
			i = index;
			while (i > 0 && datas[i - 1]["low"] > mValue) i--;
			if (i==0)
			{
				i = -99;
			}
			rst["lowL"] = index - i;
			
			i = index;
			while (i < len - 1 && datas[i + 1]["low"] > mValue) i++;
			if (i==len-1)
			{
				i = len+99;
			}
			rst["lowR"] = i - index;
			rst["low"] = Math.min(rst["lowL"], rst["lowR"]);
			rst["lowM"] = Math.max(rst["lowL"], rst["lowR"]);
			
			return rst;
		}
	}

}