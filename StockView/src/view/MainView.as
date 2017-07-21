package view 
{
	import laya.debug.tools.Notice;
	import laya.display.Sprite;
	import laya.utils.Handler;
	import msgs.MsgConst;
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
			views = [stockListView,kLineView,selectView,realTimeView,logoView];
			typeSelect.selectHandler = new Handler(this,updateSelect);
			updateSelect();
			stockListView.init();
			Notice.listen(MsgConst.Show_Stock_KLine, this, onShowStockKline);
		}
		
		private function onShowStockKline(stock:String):void
		{
			typeSelect.selectedIndex = 1;
			kLineView.showStockKline(stock);
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
					tV.removeSelf();
				}else
				{
					tV.visible = true;
					addChild(tV);
				}
			}
		}
	}

}