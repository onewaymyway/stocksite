package  
{
	import laya.net.Loader;
	import laya.utils.Handler;
	import stock.PathConfig;
	import stock.StockBasicInfo;
	import view.StockView;
	/**
	 * ...
	 * @author ww
	 */
	public class StockMain 
	{
		
		public function StockMain() 
		{
			Laya.init(1000, 900);
			Laya.stage.scaleMode = "full";
			var loads:Array;
			loads = [];
			loads.push( { url:PathConfig.stockBasic, type:Loader.TEXT } );
			loads.push({ url:"res/atlas/comp.json", type:Loader.ATLAS });
			Laya.loader.load(loads, new Handler(this, begin), null);
		}
		private function begin():void
		{
			StockBasicInfo.I.init(Loader.getRes(PathConfig.stockBasic));
			trace(StockBasicInfo.I.stockList);
			var view:StockView;
			view = new StockView();
			view.init();
			view.left = view.right = view.top = view.bottom = 10;
			Laya.stage.addChild(view);
		}
	}

}