package {
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.DTrace;
	import laya.math.DataUtils;
	import laya.maths.MathUtil;
	import laya.stock.analysers.AnalyserBase;
	import laya.stock.analysers.KLineAnalyser;
	import laya.stock.analysers.lines.PositionLine;
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
	import stockcmd.GreatKLineWorker;
	import stockcmd.RankWorker;
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
			//setTimeout(work, 1000);
			DTrace.timeEnd("StockCmdTool");
		}
		
		private function regWorkers():void
		{
			RankWorker;
			GreatKLineWorker;
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
		
		public var scriptPath:String;
		private function parseCMD(args:Array):void {
			scriptPath = args[1];
			if (args[2]) {
				RunConfig.filePath = args[2];
			}
			
			NodeJSTools.parseArgToObj(args, 3, RunConfig);
		}
		
		public function work():void {
			var clz:*= ClassTool.createObjByName(RunConfig.type);
			//var clz:*=ClassTool.createObjByName("GreatKLineWorker");
			clz.work();
		}
		
		
	}

}