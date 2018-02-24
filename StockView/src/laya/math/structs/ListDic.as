package laya.math.structs 
{
	/**
	 * ...
	 * @author ww
	 */
	public class ListDic 
	{
		
		public function ListDic() 
		{
			
		}
		public static function createByList(dataList:Array, key:String):ListDic
		{
			var listDic:ListDic;
			listDic = new ListDic();
			listDic.fromList(dataList, key);
			return listDic;
		}
		public var dataO:Object;
		public function fromList(dataList:Array, key:String):void
		{
			dataO = {};
			var i:int, len:int;
			len = dataList.length;
			var tData:Object;
			var tKey:String;
			
			for (i = 0; i < len; i++)
			{
				tData = dataList[i];
				tKey = tData[key];
				if (!dataO[tKey])
				{
					dataO[tKey] = [];
				}
				dataO[tKey].push(tData);
			}
		}
		
		public function getData(key:String):*
		{
			if (!dataO) return null;
			return dataO[key];
		}
	}

}