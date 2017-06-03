package stock.views 
{
	import laya.display.Sprite;
	import laya.math.DataUtils;
	import laya.stock.analysers.AnalyserBase;
	import laya.ui.Box;
	
	/**
	 * ...
	 * @author ww
	 */
	public class DrawBoard extends Sprite 
	{
		
		public var lineHeight:Number = 400;
		public var lineWidth:Number = 800;

		public function setDataSize(xMax:Number, yMax:Number):void
		{
			xRate = lineWidth / xMax;
			yRate = lineHeight / yMax;
		}
		
		public function fresh():void
		{
			
		}
		
		public var yRate:Number;
		public var xRate:Number;
		public function getAdptYV(v:Number):Number
		{
			return -DataUtils.mParseFloat(v) * yRate;
		}
		public function getAdptXV(v:Number):Number
		{
			return DataUtils.mParseFloat(v) * xRate;
		}
		
	}

}