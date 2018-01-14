package stockcmd 
{
	import laya.debug.tools.DTrace;
	import laya.math.DataUtils;
	import laya.maths.MathUtil;
	import laya.stock.analysers.AnalyserBase;
	import laya.stock.analysers.AverageLineAnalyser;
	import laya.stock.analysers.ChanAnalyser;
	import laya.stock.analysers.KLineAnalyser;
	import laya.stock.analysers.lines.PositionLine;
	import laya.stock.analysers.staticinfo.DaysStatic;
	import laya.stock.analysers.staticinfo.PositionStatic;
	import laya.stock.StockTools;
	import laya.structs.RankInfo;
	import laya.utils.Browser;
	import nodetools.devices.Device;
	import nodetools.devices.FileManager;
	import nodetools.devices.FileTools;
	import nodetools.devices.NodeJSTools;
	import nodetools.devices.OSInfo;
	import nodetools.devices.SystemSetting;
	import stock.StockData;
	import stockcmd.RunConfig;
	/**
	 * ...
	 * @author ww
	 */
	public class RankWorker 
	{
		
		public function RankWorker() 
		{
			
		}
		
		public function work():void {
			if (!FileTools.exist(RunConfig.filePath)) {
				trace("file not found:", RunConfig.filePath);
				return;
			}
			initAnalysers();
			if (FileTools.isDirectory(RunConfig.filePath)) {
				workDir(RunConfig.filePath);
			}
			else {
				analyserAFile(RunConfig.filePath);
			}
		}
		
		public var dirInfos:Array = [];
		
		
		private function initAnalysers():void {
			moData = {};
			var analyser:KLineAnalyser;
			var posAnalyser:PositionLine;
			var posAnalyser300:PositionLine;
			
			var types:Array;
			types = [];
			analysers = [];
			
			var tData:RankInfo;
			var tAnalyserInfos:Array;
			
			analyser = new KLineAnalyser();
			analyser.buyMinUnder = RunConfig.minUnderDay;
			analysers.push(analyser);
			
			
			
			posAnalyser = new PositionLine();
			posAnalyser.dayCount = "130";
			analysers.push(posAnalyser);
			
			posAnalyser = new PositionLine();
			posAnalyser.dayCount = "90";
			analysers.push(posAnalyser);
			
			posAnalyser300 = new PositionLine();
			posAnalyser300.dayCount = "300";
			analysers.push(posAnalyser300);
			
			var posAnalyser60:PositionLine = new PositionLine();
			posAnalyser60.dayCount = "60";
			posAnalyser60.minBuyExp = 0.2;
			posAnalyser60.minBuyLose = -0.02;
			posAnalyser60.maxBuyLose = -0.1;
			analysers.push(posAnalyser60);
			
			var posAnalyser30:PositionLine = new PositionLine();
			posAnalyser30.dayCount = "30";
			posAnalyser30.minBuyExp = 0.15;
			posAnalyser30.minBuyLose = -0.02;
			posAnalyser30.maxBuyLose = -0.1;
			analysers.push(posAnalyser30);
			
			analysers.push(new ChanAnalyser());
			
			analysers.push(new PositionStatic());
			
			analysers.push(new AverageLineAnalyser());
			analysers.push(new DaysStatic());
			var i:int, len:int;
			len = analysers.length;
			var tAnalyser:AnalyserBase;
			for (i = 0; i < len; i++) {
				tAnalyser = analysers[i];
				tAnalyser.addToConfigTypes(types);
			}
			
			moData.types = types;
		}
		public var moData:Object;
		
		public function workDir(path:String):void {
			dirInfos = [];
			var fileList:Array;
			
			fileList = FileTools.getFileList(path);
			var i:int, len:int;
			len = fileList.length;
			for (i = 0; i < len; i++) {
				//trace("file:", fileList[i]);
				analyserAFile(fileList[i], dirInfos);
			}
			//trace("okFiles:", dirInfos);
			//dirInfos.sort(MathUtil.sortByKey("lastDate", true, false));
			
			moData.stocks = dirInfos;
			
			FileManager.createJSONFile(RunConfig.outFile, moData);
		}
		
		public var analysers:Array;
		
		public function analyserAFile(path:String, rst:Array = null):void {
			trace("work:", path);
			var data:String;
			data = FileManager.readTxtFile(path);
			
			var stockData:StockData;
			stockData = new StockData();
			stockData.init(data);
			if (stockData.dataList.length < 2) return;
			
			var tData:Object;
			tData = {};
			tData.code = FileManager.getFileName(path);
			tData.basic = {code: tData.code};
			
			var i:int, len:int;
			len = analysers.length;
			var tAnalyser:AnalyserBase;
			for (i = 0; i < len; i++) {
				tAnalyser = analysers[i];
				//tAnalyser.initByStrData(data);
				tAnalyser.analyser(stockData,0,-1,true);
				tAnalyser.addToShowData(tData);
			}
			
			rst.push(tData);
		
		}
	}

}