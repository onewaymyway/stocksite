package laya.stock.models 
{
	/**
	 * ...
	 * @author ww
	 */
	public class OrdedList 
	{
		public var dataList:Array=[];
		public var sign:String = "low";
		
		public function OrdedList() 
		{
			
		}
		public function reset():void
		{
			dataList.length = 0;
		}
		public function add(data:Object):Boolean
		{
			if (dataList.length == 0)
			{
				dataList.push(data);
				return true;
			}
			if (isOK(getLastPrice() ,getDataPrice(data)))
			{
				dataList.push(data);
				return true;
			}
			return false;
		}
		public function isOK(left:Number, right:Number):Boolean
		{
			return left > right;
		}
		public function getDataPrice(data:Object):Number
		{
			return data[sign];
		}
		public function getDataKey(data:Object, key:String):Number
		{
			return data[key];
		}
		public function getLastPrice():Number
		{
			if (dataList.length == 0)
			{
				return -1;
			}
			return getDataPrice(dataList[dataList.length - 1]);
		}
		
		public function getFirstPrice():Number
		{
			if (dataList.length == 0)
			{
				return -1;
			}
			return getDataPrice(dataList[0]);
		}
		
		public function getPriceLen():Number
		{
			if (dataList.length < 2) return 0;
			return Math.abs(getFirstPrice()-getLastPrice());
		}
		
		public function getIndexLen():int
		{
			if (dataList.length < 2) return 0;
			return Math.abs(dataList[0]["index"]-dataList[dataList.length - 1]["index"]);
		}
		
		public function getLen():int
		{
			return dataList.length;
		}
	}

}