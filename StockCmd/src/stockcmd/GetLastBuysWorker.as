package stockcmd 
{
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.JsonTool;
	import laya.math.ValueTools;
	import laya.stock.backtest.BackTestInfo;
	import laya.stock.backtest.Trader;
	import laya.stock.backtest.traders.AverageTrader;
	import nodetools.devices.FileManager;
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class GetLastBuysWorker extends RunWorkerBase
	{
		
		public function GetLastBuysWorker() 
		{
			
		}
		
		public var tTrader:Trader;
		public var tplStr:String;
		public var curConfigO:Object;
		override public function workInits():void {
			trace("isConfigExist:",RunConfig.paramFile,FileManager.exists(RunConfig.paramFile));
			if (FileManager.exists(RunConfig.paramFile)) {
				try {
					var configO:Object;
					configO = FileManager.readJSONFile(RunConfig.paramFile);
					trace("paramFile:", RunConfig.paramFile);
					configO = configO.param;
					if (configO && configO.trader) {
						var traderO:Object;
						traderO = configO.trader;
						tTrader = ValueTools.createObjectByConfig(traderO);
						tplStr = configO.tpl;
						
						curConfigO = configO;
						trace("setCurConfigO",curConfigO);
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
				trace("useDefaultTrader");
			}
			
			tTrader.reset();
		}
		
		override public function doAnalyse(stockData:StockData):void {
			tTrader.setStockData(stockData);
			tTrader.runLastBuy();
		}
		
		override public function workEnd():void {
			var rstO:Object;
			rstO = { };
			var tList:Array;
			tList = tTrader.staticInfoList;
			var i:int, len:int;
			len = tList.length;
			var tData:Object;
			var mList:Array;
			var curData:BackTestInfo;
			mList = [];
			for (i = 0; i < len; i++)
			{
				curData = tList[i];
				if (curData.dataO)
				{
					tData = curData.dataO;
				}else
				{
					tData = { };
				}
				
				tData.code = curData.stock;
				tData.date = curData.date;
				tData.buyPrice = curData.buy;
				if (curData.sellDay)
				{
					tData.sell = curData.sellDay;
					tData.sellPrice = curData.sell;
					tData.sellRate = curData.sellRate;
					tData.sellReason = curData.sellReason;
				}else
				{
					tData.sell = 0;
					tData.sellRate = 0;
					tData.sellPrice = tData.buyPrice;
					tData.sellReason = "None";
				}
				mList.push(tData);
			}
			rstO.list = mList;
			if (tplStr)
			{
				rstO.tpl = tplStr;
			}
			if (!curConfigO)
			{
				trace("configO==null");
			}
			if (curConfigO&&curConfigO.rankInfos)
			{
				rstO.rankInfos = curConfigO.rankInfos;
			}
			mList.sort(ValueTools.sortByKeyEX("date",true,false));
			//JsonTool.getJsonString(rstO, false);
			FileManager.createTxtFile(RunConfig.outFile, JsonTool.getJsonString(rstO, false, "\n"));
			//FileManager.createJSONFile(RunConfig.outFile, rstO);
		}
	}

}