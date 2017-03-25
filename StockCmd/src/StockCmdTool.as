package {
	import laya.debug.tools.DTrace;
	import laya.math.DataUtils;
	import laya.maths.MathUtil;
	import laya.stock.analysers.KLineAnalyser;
	import laya.stock.analysers.lines.PositionLine;
	import laya.stock.StockTools;
	import laya.utils.Browser;
	import nodetools.devices.Device;
	import nodetools.devices.FileManager;
	import nodetools.devices.FileTools;
	import nodetools.devices.NodeJSTools;
	import nodetools.devices.OSInfo;
	import nodetools.devices.SystemSetting;
	import stockcmd.RunConfig;
	
	/**
	 * ...
	 * @author ww
	 */
	public class StockCmdTool {
		
		public function StockCmdTool() {
			init();
			parseCMD(NodeJSTools.getArgv());
			DTrace.timeStart("StockCmdTool");
			work();
			DTrace.timeEnd("StockCmdTool");
		}
		
		private function init():void {
			Device.init();
			SystemSetting.isCMDVer = true;
			OSInfo.init();
			//CMDShell.init();
			//Device.init();
			//初始化文件系统
			FileTools.init2();
		}
		
		private function parseCMD(args:Array):void {
			scriptPath = args[1];
			if (args[2]) {
				RunConfig.filePath = args[2];
			}
			
			NodeJSTools.parseArgToObj(args, 3, RunConfig);
		}
		
		public function work():void {
			if (!FileTools.exist(RunConfig.filePath)) {
				trace("file not found:", RunConfig.filePath);
				return;
			}
			if (FileTools.isDirectory(RunConfig.filePath)) {
				workDir(RunConfig.filePath);
			}
			else {
				analyserAFile(RunConfig.filePath);
			}
		}
		
		public function test():void {
			//analyserAFile("res/stockdata/000546.csv");
			//workDir("res/stockdata/");
			workDir("D:/stockdata.git/trunk/trunk/stockdatas/");
		}
		public var dirInfos:Array = [];
		
		private function initAnalysers():void {
			moData = {};
			
			var types:Array;
			types = [];
			
			var tData:Object;
			var tAnalyserInfos:Array;
			
			analyser = new KLineAnalyser();
			
			tData = {};
			tData.label = "kline";
			tData.sortParams = ["kLineO.lastDate", true, false];
			tData.dataKey = "kLineO";
			tAnalyserInfos = [];
			tAnalyserInfos.push(analyser.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			
			tData.tip = "股票:当前盈利:最高盈利\n7天最大盈利,15天最大盈利,30天最大盈利,45天最大盈利\n买入日期";
			tData.tpl = "{#code#}:{#changePercent#}%:{#highPercent#}%\n{#high7#}%,{#high15#}%,{#high30#}%,{#high45#}%\n{#lastDate#}";
			types.push(tData);
			
			posAnalyser = new PositionLine();
			posAnalyser.dayCount = 130;
			
			tData = {};
			tData.label = "exp";
			tData.sortParams = ["expO.exp", true, true];
			tData.dataKey = "expO";
			tData.tpl = "{#code#}:exp:{#exp#}\nwin:{#win#}\nlose{#lose#}";
			tAnalyserInfos = [];
			tAnalyserInfos.push(posAnalyser.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			tData.tip = "n天期望模型";
			types.push(tData);
			
			tData = {};
			tData.label = "win";
			tData.sortParams = ["expO.win", true, true];
			tData.dataKey = "expO";
			tData.tpl = "{#code#}:exp:{#exp#}\nwin:{#win#}\nlose{#lose#}";
			tAnalyserInfos = [];
			tAnalyserInfos.push(posAnalyser.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			tData.tip = "n天期望模型";
			types.push(tData);
			
			moData.types = types;
		}
		public var moData:Object;
		
		public function workDir(path:String):void {
			dirInfos = [];
			var fileList:Array;
			initAnalysers();
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
		public var analyser:KLineAnalyser;
		public var posAnalyser:PositionLine;
		
		public function analyserAFile(path:String, rst:Array = null):void {
			trace("work:", path);
			var data:String;
			data = FileManager.readTxtFile(path);
			
			analyser.initByStrData(data);
			//trace("analyser:", analyser);
			var tData:Object;
			tData = {};
			tData.code = FileManager.getFileName(path);
			tData.basic = {code: tData.code};
			var kLineO:Object;
			kLineO = {};
			tData.kLineO = kLineO;
			kLineO.code = tData.code;
			kLineO.lastDate = "0";
			
			var winLose:Array;
			winLose = DataUtils.getWinLoseInfo(analyser.disDataList, posAnalyser.dayCount, analyser.disDataList.length - 1);
			
			var expO:Object = {};
			tData.expO = expO;
			expO.code = tData.code;
			expO.lose = StockTools.getGoodPercent(winLose[0]);
			expO.win = StockTools.getGoodPercent(winLose[1]);
			expO.exp = StockTools.getGoodPercent(winLose[2]);
			rst.push(tData);
			
			var lastUnder:Object;
			lastUnder = analyser.getLastUnderLine(RunConfig.minUnderDay);
			//trace("lastUnder", lastUnder);
			if (!lastUnder)
				return;
			var lastStock:Object;
			lastStock = analyser.getDataByI(lastUnder[2]);
			//trace("lastStock:", lastStock);
			if (rst) {
				if (lastStock) {
					kLineO.lastDate = lastStock["date"];
					kLineO.data = lastStock;
					StockTools.getBuyStaticInfos(lastUnder[2], analyser.disDataList, kLineO);
				}
			}
		}
	}

}