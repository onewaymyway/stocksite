package nodetools.devices 
{
	/**
	 * ...
	 * @author ww
	 */
	public class CSVTools 
	{
		
		public function CSVTools() 
		{
			
		}
		public static function objListToCsv(list:Array):String
		{
			var i:int, len:int;
			len = list.length;
			var keys:Array;
			keys = getKeysFromObj(list[0]);
			var tVArr:Array;
			var rstList:Array;
			rstList = [];
			rstList.push(keys.join(","));
			tVArr = [];
			tVArr.length = keys.length;
			var tData:Object;
			var j:int, jLen:int;
			jLen = keys.length;
			trace("keys",keys);
			trace("dataLen:",list.length);
			for (i = 0; i < len; i++)
			{
				tData = list[i];
				for (j = 0; j < jLen; j++)
				{
					tVArr[j] = tData[keys[j]];
				}
				rstList.push(tVArr.join(","));
			}
			return rstList.join("\n");
			
		}
		private static function getKeysFromObj(obj:Object):Array
		{
			var key:String;
			var keys:Array;
			keys = [];
			for (key in obj)
			{
				keys.push(key);
			}
			keys.sort();
			return keys;
		}
	}

}