package  
{
	import laya.maths.MathUtil;
	import laya.net.Loader;
	import laya.utils.Handler;
	import stock.PathConfig;
	import stock.StockBasicInfo;
	import stock.views.KLine;
	import view.KLineView;
	import view.MainView;
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
			Laya.loader.load(loads, new Handler(this, start), null);
		}
		private function start():void
		{
			//begin();
			//testKLine();
			//testKlineView();
			StockBasicInfo.I.init(Loader.getRes(PathConfig.stockBasic));
			trace(StockBasicInfo.I.stockList);
			//StockBasicInfo.I.stockList.sort(MathUtil.sortByKey("totals", false, true));
			testMainView();
		}
		private function begin():void
		{
			
			var view:StockView;
			view = new StockView();
			view.init();
			view.left = view.right = view.top = view.bottom = 10;
			Laya.stage.addChild(view);
			
			
		}
		private function testKLine():void
		{
			var kLine:KLine;
			kLine = new KLine();
			var stock:String;
			stock = "300383";
			//stock = "000546";
			//stock = "000725";
			stock = "002064";
			//stock = "600139";
			kLine.setStock(stock);
			kLine.pos(200, 500);
			//kLine.scaleX = 0.5;
			Laya.stage.addChild(kLine);
		}
		private function testKlineView():void
		{
			var kView:KLineView;
			kView = new KLineView();
			Laya.stage.addChild(kView);
		}
		private function testMainView():void
		{
			var mainView:MainView;
			mainView = new MainView();
			mainView.left = mainView.right = mainView.top = mainView.bottom = 10;
			Laya.stage.addChild(mainView);
		}
	}

}