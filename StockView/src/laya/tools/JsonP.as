package laya.tools 
{
	import laya.utils.Browser;
	import laya.utils.Handler;
	/**
	 * ...
	 * @author ww
	 */
	public class JsonP 
	{
		
		public function JsonP() 
		{
			
		}
		public static function getData(url:String, complete:Handler):void
		{
			var scp:*= Browser.createElement("script");
			Browser.document.body.appendChild(scp);
			scp.type = "text/javascript";
			scp.src = url;
			scp.onload = function()
			{
				scp.src = "";
				Browser.removeElement(scp);
				complete.run();
			}
		}
	}

}