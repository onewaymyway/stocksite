package stock 
{
	import laya.math.DataUtils;
	import laya.maths.MathUtil;
	/**
	 * ...
	 * @author ww
	 */
	public class StockData extends CSVParser 
	{
		
		public function StockData() 
		{
			super();
			numKeys= ["open","high","close","low","volume","amount"];
		}
		override public function init(csvStr:String):void 
		{
			super.init(csvStr);
			dataList.sort(MathUtil.sortByKey("date",false,false));
		}
		
	}

}