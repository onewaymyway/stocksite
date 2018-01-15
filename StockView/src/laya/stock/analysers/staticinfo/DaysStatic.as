package laya.stock.analysers.staticinfo 
{
	import laya.math.DataUtils;
	import laya.stock.analysers.AnalyserBase;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DaysStatic extends AnalyserBase 
	{
		
		public function DaysStatic() 
		{
			super();
			
		}
		
		override public function analyseWork():void 
		{
			super.analyseWork();
		}
		
		override public function addToConfigTypes(types:Array):void 
		{
			
			
		}
		
		override public function addToShowData(showData:Object):void 
		{
			
			showData["upstops"] = DataUtils.getContinueUpStops(disDataList);
			
		}
		
	}

}