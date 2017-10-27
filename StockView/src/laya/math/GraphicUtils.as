package laya.math 
{
	/**
	 * ...
	 * @author ww
	 */
	public class GraphicUtils 
	{
		
		public function GraphicUtils() 
		{
			
		}
		public static function pointOfLine(px:Number, py:Number, x0:Number, y0:Number, x1:Number, y1:Number):int
		{
			var y:Number;
			y = y0 + (px - x0)*(y1 - y0) / (x1 - x0);
			return y - py;
		}
		
		public static function addGridLineToResult(result:Object, lineStr:String):void
		{
			
		}
	}

}