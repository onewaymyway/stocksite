package {
	import laya.debug.tools.DTrace;
	import laya.maths.MathUtil;
	import laya.stock.analysers.KLineAnalyser;
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
		public function work():void
		{
			if (!FileTools.exist(RunConfig.filePath))
			{
				trace("file not found:",RunConfig.filePath);
				return;
			}
			if (FileTools.isDirectory(RunConfig.filePath))
			{
				workDir(RunConfig.filePath);
			}else
			{
				analyserAFile(RunConfig.filePath);
			}
		}
		public function test():void {
			//analyserAFile("res/stockdata/000546.csv");
			//workDir("res/stockdata/");
			workDir("D:/stockdata.git/trunk/trunk/stockdatas/");
		}
		public var dirInfos:Array = [];
		public function workDir(path:String):void {
			dirInfos = [];
			var fileList:Array;
			fileList = FileTools.getFileList(path);
			var i:int, len:int;
			len = fileList.length;
			for (i = 0; i < len; i++) {
				//trace("file:", fileList[i]);
				analyserAFile(fileList[i],dirInfos);
			}
			//trace("okFiles:", dirInfos);
			dirInfos.sort(MathUtil.sortByKey("lastDate", true, false));
			FileManager.createJSONFile(RunConfig.outFile, dirInfos);
		}
		public var analyser:KLineAnalyser;
		
		public function analyserAFile(path:String,rst:Array=null):void {
			trace("work:",path);
			var data:String;
			data = FileManager.readTxtFile(path);
			if (!analyser) {
				analyser = new KLineAnalyser();
			}
			
			analyser.initByStrData(data);
			//trace("analyser:", analyser);
			var lastUnder:Object;
			lastUnder = analyser.getLastUnderLine(RunConfig.minUnderDay);
			//trace("lastUnder", lastUnder);
			if (!lastUnder)
				return;
			var lastStock:Object;
			lastStock = analyser.getDataByI(lastUnder[2]);
			//trace("lastStock:", lastStock);
			if (rst)
			{
				if (lastStock)
				{
					var tData:Object;
					tData = { };
					tData.path = FileManager.getFileName(path);
					tData.data = lastStock;
					tData.lastDate = lastStock["date"];
					//var tPrice:Number;
					//tPrice = analyser.dataList[analyser.dataList.length - 1]["high"];
					//var buyPrice:Number;
					//buyPrice = lastStock["high"];
					//tData.changePercent = (tPrice-buyPrice) / buyPrice;
					StockTools.getBuyStaticInfos(lastUnder[2], analyser.disDataList, tData);
					rst.push(tData);
				}
			}
		}
	}

}