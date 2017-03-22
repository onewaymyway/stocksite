package laya.stock.analysers.comps 
{
	import laya.math.DataUtils;
	/**
	 * ...
	 * @author ww
	 */
	public class GridLine 
	{
		
		public function GridLine() 
		{
			
		}
		public var datas:Array;
		public var color:String = "#ff0000";
		public function initData(startI:int, endI:int, values:Array):void
		{
			datas = DataUtils.createGridLineData(startI, endI, values);	
		}
		public function addToDrawCmd(cmds:Array):void
		{
			
		}
	}

}