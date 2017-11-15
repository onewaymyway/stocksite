package laya.math {
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.ObjectTools;
	import laya.utils.Utils;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ValueTools {
		
		public function ValueTools() {
		
		}
		
		public static function mParseFloat(v:*):Number {
			var tV:Number;
			tV = parseFloat(v);
			if (tV.toString() == "NaN")
				return 0;
			return tV;
		}
		
		public static function makeNumArr(arr:Array):Array {
			var i:int, len:int;
			len = arr.length;
			for (i = 0; i < len; i++) {
				arr[i] = mParseFloat(arr[i]);
			}
			return arr;
		}
		
		public static function insertConfig(tar:Object, configO:Object):void
		{
			if (!configO) return;
			var key:String;
			for (key in configO)
			{
				tar[key] = configO[key];
			}
		}
		
		public static function createObjectArrs(dataList:Array):Array
		{
			var i:int, len:int;
			len = dataList.length;
			var rst:Array;
			rst = [];
			for (i = 0; i < len; i++)
			{
				rst.push(createObjectByConfig(dataList[i]));
			}
			return rst;
		}
		public static function createObjectByConfig(config:Object):*
		{
			if (config is Array)
			{
				return createObjectArrs(config as Array);
			}
			var Clz:String;
			Clz = config["Class"];
			var tRstO:Object;
			tRstO = ClassTool.createObjByName(Clz);
			if (!tRstO) return tRstO;
			insertConfig(tRstO, config["config"]);
			var values:Array;
			values = config["values"];
			if (values)
			{
				var i:int, len:int;
				var tValue:Array;
				len = values.length;
				for (i = 0; i < len; i++)
				{
					tValue = values[i];
					tRstO[tValue[0]] = createObjectByConfig(tValue[1]);
				}
			}
			return tRstO;
		}
		
		public static var tplArrDic:Object = { };
		public static function splitStpl(tplStr:String):Array
		{
			if (tplArrDic[tplStr]) return Utils.copyArray([],tplArrDic[tplStr]) ;
			var i:int, len:int;
			len = tplStr.length;
			var preI:int = 0;
			var tStr:String;
			var rst:Array;
			rst = [];
			for (i = 0; i < len; i++)
			{
				tStr = tplStr.charAt(i);
				if (tStr == "#")
				{
					if(i-1>=preI)
					rst.push(tplStr.substring(preI, i));
					preI = i + 1;
				}
				if (tStr == "{" || tStr == "}")
				{
					if(i-1>=preI)
					rst.push(tplStr.substring(preI, i));
					rst.push(tStr);
					preI = i + 1;
				}
				
			}
			if (i - 1 >= preI) rst.push(tplStr.substring(preI, i));
			tplArrDic[tplStr] = rst;
			return Utils.copyArray([],rst) ;
			//return rst;
		}
		public static function getTplStr(tplStr:String, data:Object):String {
			var i:int, len:int;
			var tps:Array;
			tps = splitStpl(tplStr);
			len = tps.length;
			var tStr:String;
			var tRst:String;
			var preOpen:Boolean = false;
			var nextEnd:Boolean = false;
			var nextStr:String;
			for (i = 0; i < len; i++) {
				tStr = tps[i];
				nextStr = tps[i + 1];
				if (nextStr== "}") {
					nextEnd = true;
				}
				else {
					nextEnd = false;
				}
				if (preOpen && nextEnd) {
				   	tps[i] = data[tStr];
					tps[i - 1] = "";
					tps[i + 1] = "";
				}
				if (tStr == "{") {
					preOpen = true;
				}
				else {
					preOpen = false;
				}
				
			}
			return tps.join("");
		}
		public static function getFlatKeyValueStr(obj:Object, key:String):String
		{
			var str:String;
			str = getFlatKeyValue(obj, key);
			if (!str) return "";
			return str;
		}
		
		public static function getFlatKeyValueNum(obj:Object, key:String):int
		{
			var str:String;
			str = getFlatKeyValue(obj, key);
			if (!str) return 0
			return str;
		}
		public static function getFlatKeyValue(obj:Object, key:String):* {
			if (!obj)
				return null;
			if (!key)
				return obj;
			var keys:Array;
			keys = key.split(".");
			var i:int, len:int;
			len = keys.length;
			var tV:*;
			tV = obj;
			for (i = 0; i < len; i++) {
				tV = tV[keys[i]];
				if (!tV)
					return tV;
			}
			return tV;
		}
		
		/**
		 * 一个用来确定数组元素排序顺序的比较函数。
		 * @param	a 待比较数字。
		 * @param	b 待比较数字。
		 * @return 如果a等于b 则值为0；如果b>a则值为1；如果b<则值为-1。
		 */
		public static function sortBigFirst(a:Number, b:Number):Number {
			if (a == b)
				return 0;
			return b > a ? 1 : -1;
		}
		
		/**
		 * 一个用来确定数组元素排序顺序的比较函数。
		 * @param	a 待比较数字。
		 * @param	b 待比较数字。
		 * @return 如果a等于b 则值为0；如果b>a则值为-1；如果b<则值为1。
		 */
		public static function sortSmallFirst(a:Number, b:Number):Number {
			if (a == b)
				return 0;
			return b > a ? -1 : 1;
		}
		
		/**
		 * 将指定的元素转为数字进行比较。
		 * @param	a 待比较元素。
		 * @param	b 待比较元素。
		 * @return b、a转化成数字的差值 (b-a)。
		 */
		public static function sortNumBigFirst(a:*, b:*):Number {
			return parseFloat(b) - parseFloat(a);
		}
		
		/**
		 * 将指定的元素转为数字进行比较。
		 * @param	a 待比较元素。
		 * @param	b 待比较元素。
		 * @return a、b转化成数字的差值 (a-b)。
		 */
		public static function sortNumSmallFirst(a:*, b:*):Number {
			return parseFloat(a) - parseFloat(b);
		}
		
		/**
		 * 返回根据对象指定的属性进行排序的比较函数。
		 * @param	key 排序要依据的元素属性名。
		 * @param	bigFirst 如果值为true，则按照由大到小的顺序进行排序，否则按照由小到大的顺序进行排序。
		 * @param	forceNum 如果值为true，则将排序的元素转为数字进行比较。
		 * @return 排序函数。
		 */
		public static function sortByKey(key:String, bigFirst:Boolean = false, forceNum:Boolean = true):Function {
			var _sortFun:Function;
			if (bigFirst) {
				_sortFun = forceNum ? sortNumBigFirst : sortBigFirst;
			}
			else {
				_sortFun = forceNum ? sortNumSmallFirst : sortSmallFirst;
			}
			return function(a:Object, b:Object):Number {
				return _sortFun(a[key], b[key]);
			}
		}
		
		/**
		 * 返回根据对象指定的属性进行排序的比较函数。
		 * @param	key 排序要依据的元素属性名。
		 * @param	bigFirst 如果值为true，则按照由大到小的顺序进行排序，否则按照由小到大的顺序进行排序。
		 * @param	forceNum 如果值为true，则将排序的元素转为数字进行比较。
		 * @return 排序函数。
		 */
		public static function sortByKeyEX(key:String, bigFirst:Boolean = false, forceNum:Boolean = true):Function {
			if (key.indexOf(".") < 0)
				return sortByKey(key, bigFirst, forceNum);
			var _sortFun:Function;
			if (bigFirst) {
				_sortFun = forceNum ? sortNumBigFirst : sortBigFirst;
			}
			else {
				_sortFun = forceNum ? sortNumSmallFirst : sortSmallFirst;
			}
			var getKeyFun:Function;
			getKeyFun = forceNum?getFlatKeyValueNum:getFlatKeyValueStr;
			return function(a:Object, b:Object):Number {
				return _sortFun(getKeyFun(a, key), getKeyFun(b, key));
			}
		}
	}

}