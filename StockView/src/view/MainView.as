package view 
{
	import laya.display.Sprite;
	import laya.utils.Handler;
	import ui.MainViewUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class MainView extends MainViewUI 
	{
		
		public function MainView() 
		{
			init();
		}
		public var views:Array;
		public function init():void
		{
			views = [stockListView,kLineView];
			typeSelect.selectHandler = new Handler(this,updateSelect);
			updateSelect();
			stockListView.init();
		}
		
		private function updateSelect():void
		{
			var i:int, len:int;
			len = views.length;
			var tV:Sprite;
			for (i = 0; i < len; i++)
			{
				tV = views[i];
				if (i != typeSelect.selectedIndex)
				{
					tV.visible = false;
				}else
				{
					tV.visible = true;
				}
			}
		}
	}

}