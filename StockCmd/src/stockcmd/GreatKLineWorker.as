package stockcmd 
{
	import nodetools.devices.FileManager;
	import nodetools.devices.FileTools;
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class GreatKLineWorker 
	{
		
		public function GreatKLineWorker() 
		{
			
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
		
		private var dirInfos:Array;
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
			
		
		}
	}

}