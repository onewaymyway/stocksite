package laya.tools 
{
	import laya.utils.Browser;
	/**
	 * ...
	 * @author ww
	 */
	public class WebTools 
	{
		
		public function WebTools() 
		{
			
		}
		public static function openUrl(path:String):void
		{
			Browser.window.open(path, "_blank");
		}
		public static function openStockDetail(stock:String):void
		{
			openUrl("http://q.stock.sohu.com/cn/"+stock+"/");
			//openUrl("http://stockhtm.finance.qq.com/sstock/ggcx/"+stock+".shtml");
		}
	}

}