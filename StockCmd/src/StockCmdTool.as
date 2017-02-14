package {
	import laya.ide.config.SystemSetting;
	import laya.ide.devices.Device;
	import laya.ide.devices.FileTools;
	import laya.ide.devices.OSInfo;
	import laya.ide.managers.FileManager;
	import laya.stock.analysers.KLineAnalyser;
	import laya.utils.Browser;
	
	/**
	 * ...
	 * @author ww
	 */
	public class StockCmdTool {
		
		public function StockCmdTool() {
			init();
			test();
		}
		
		private function init():void {
			Device.Buffer = __JS__("Buffer");
			SystemSetting.isCMDVer = true;
			OSInfo.init();
			Browser.userAgent = OSInfo.type;
			//CMDShell.init();
			//Device.init();
			//初始化文件系统
			FileTools.init2();
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
			trace("okFiles:", dirInfos);
			FileManager.createJSONFile("lastBuys.json", dirInfos);
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
			trace("analyser:", analyser);
			var lastUnder:Object;
			lastUnder = analyser.getLastUnderLine(3);
			trace("lastUnder", lastUnder);
			if (!lastUnder)
				return;
			var lastStock:Object;
			lastStock = analyser.getDataByI(lastUnder[2]);
			trace("lastStock:", lastStock);
			if (rst)
			{
				if (lastStock)
				{
					var tData:Object;
					tData = { };
					tData.path = path;
					tData.data = lastStock;
					tData.lastDate = lastStock["date"];
					rst.push(tData);
				}
			}
		}
	}

}