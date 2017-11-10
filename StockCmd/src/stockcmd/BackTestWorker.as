package stockcmd {
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.JsonTool;
	import laya.math.ValueTools;
	import laya.stock.backtest.Trader;
	import laya.stock.backtest.traders.AverageTrader;
	import nodetools.devices.FileManager;
	import stock.StockData;
	
	/**
	 * ...
	 * @author ww
	 */
	public class BackTestWorker extends RunWorkerBase {
		
		public function BackTestWorker() {
		
		}
		public var tTrader:Trader;
		
		override public function workInits():void {
			if (FileManager.exists(RunConfig.paramFile)) {
				try {
					var configO:Object;
					configO = FileManager.readJSONFile(RunConfig.paramFile);
					if (configO && configO.trader) {
						var traderO:Object;
						traderO = configO.trader;
						tTrader = ValueTools.createObjectByConfig(traderO);
					}
					trace("createByConfig success");
				}
				catch (e:*) {
					trace("createByConfig Fail");
					trace(e.message,e.stack);
				}
				
			}
			if (!tTrader) {
				tTrader = new AverageTrader();
			}
			
			tTrader.reset();
		}
		
		override public function doAnalyse(stockData:StockData):void {
			tTrader.setStockData(stockData);
			tTrader.runTest();
		}
		
		override public function workEnd():void {
			var rstO:Object;
			rstO = tTrader.getStaticInfo();
			//JsonTool.getJsonString(rstO, false);
			FileManager.createTxtFile(RunConfig.outFile, JsonTool.getJsonString(rstO, false, "\n"));
			//FileManager.createJSONFile(RunConfig.outFile, rstO);
		}
	}

}