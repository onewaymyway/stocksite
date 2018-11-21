package  
{
	import laya.debug.DebugTool;
	import laya.debug.tools.DebugTxt;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.events.MultiTouchManager;
	import laya.maths.MathUtil;
	import laya.maths.Point;
	import laya.net.Loader;
	import laya.stock.StockTools;
	import laya.tools.SohuDData;
	import laya.tools.StockJsonP;
	import laya.ui.Box;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
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
			//StockTools.DebugMode();
			Laya.stage.scaleMode = "full";
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
			//Stat.show();
			var loads:Array;
			loads = [];
			loads.push( { url:PathConfig.stockBasic, type:Loader.TEXT } );
			loads.push({ url:"res/atlas/comp.json", type:Loader.ATLAS });
			Laya.loader.load(loads, new Handler(this, start), null);
			//DebugTool.init();
		}
		private function start():void
		{
			//begin();
			//testKLine();
			//testKlineView();
			StockBasicInfo.I.init(Loader.getRes(PathConfig.stockBasic));
			//trace(StockBasicInfo.I.stockList);
			//StockBasicInfo.I.stockList.sort(MathUtil.sortByKey("totals", false, true));
			testMainView();
			//testStockInfo();
			//SohuDData.getData("601918",null);
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
		public var stockMainBox:Box;
		
		private function onStageResize1(box:Box):void
		{
			box.width = Laya.stage.width /scaleRate;
			box.height = Laya.stage.height / scaleRate;
			onStageResize();
			
		}
		public static var scaleRate:Number = 2;
		
		private var container:Sprite;
		private function testMainView():void
		{
			stockMainBox = new Box();
			
			Laya.stage.on(Event.RESIZE, this, onStageResize);
			var mainView:MainView;
			mainView = new MainView();
			mainView.left = mainView.right = mainView.top = mainView.bottom = 10;
			stockMainBox.addChild(mainView);
			
			
			if (Browser.pixelRatio > 1)
			{
				var box:Box;
				box = new Box();
				container = box;
				box.scale(scaleRate, scaleRate);
				Laya.stage.addChild(box);
				Laya.stage.on(Event.RESIZE, this, onStageResize1, [box]);
				onStageResize1(box);
			}else
			{
				container = Laya.stage;
			}
			container.addChild(stockMainBox);
			onStageResize();
			MultiTouchManager.I.on(MultiTouchManager.Scale, this, onScaleEvent);
			//DebugTxt.init();
		}
		//private var curPoint:Sprite;
		private function onScaleEvent(scale:Number, centerPoint:Point):void
		{
			//alert(scale+":" + centerPoint.x + "," + centerPoint.y);
			//if (!curPoint)
			//{
				//curPoint = new Sprite();
				//curPoint.graphics.drawCircle(0, 0, 20, "#ff0000");
				//stockMainBox.addChild(curPoint);
				//curPoint.zOrder = 9999;
			//}
			//stockMainBox.globalToLocal(centerPoint);
			//curPoint.pos(centerPoint.x, centerPoint.y);
			//return;
			stockMainBox.globalToLocal(centerPoint);
			if (scale > 1.5)
			{
				
				stockMainBox.scaleX = stockMainBox.scaleY = 2;
				
				stockMainBox.pivot(centerPoint.x, centerPoint.y);
				stockMainBox.pos(centerPoint.x, centerPoint.y);
				//curPoint.pos(centerPoint.x, centerPoint.y);
			}else if (scale < 0.6)
			{
				stockMainBox.pivot(0, 0);
				stockMainBox.pos(0, 0);
				stockMainBox.scaleX = stockMainBox.scaleY = 1;
				//curPoint.pos(centerPoint.x, centerPoint.y);
			}
		}
		private function onStageResize():void
		{
			stockMainBox.size(container.width,container.height);
		}
		private function testStockInfo():void
		{
			StockJsonP.I.addStock("sh601003");
			StockJsonP.I.freshData();
		}
	}

}