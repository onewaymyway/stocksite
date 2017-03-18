package stock.prop 
{
	import laya.ui.Box;
	import laya.ui.Panel;
	
	/**
	 * ...
	 * @author ww
	 */
	public class PropPanel extends Panel 
	{
		
		public function PropPanel() 
		{
			super();
			propBox = new Box();
		}
		public var propBox:Box;
		public function initByData(propDes:Array, propO:Object):void
		{
			
		}
		private function createBox(propDes:Array):void
		{
			
		}
	}

}