package stockcmd 
{
	import nodetools.devices.FileManager;
	import nodetools.devices.FileTools;
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class RunWorkerBase 
	{
		
		public function RunWorkerBase() 
		{
			
		}
		
		public function work():void {
			if (!FileTools.exist(RunConfig.filePath)) {
				trace("file not found:", RunConfig.filePath);
				return;
			}
			workInits();
			if (FileTools.isDirectory(RunConfig.filePath)) {
				workDir(RunConfig.filePath);
			}
			else {
				analyserAFile(RunConfig.filePath);
			}
			workEnd();
		}
		public function workInits():void
		{
			
		}
		public function workEnd():void
		{
			
		}
		public function workDir(path:String):void {
			dirInfos = [];
			var fileList:Array;
			
			fileList = FileTools.getFileList(path);
			var i:int, len:int;
			len = fileList.length;
			for (i = 0; i < len; i++) {
				//trace("file:", fileList[i]);
				analyserAFile(fileList[i]);
			}
		}
		
		public function analyserAFile(path:String):void {
			trace("work:", path);
			var data:String;
			data = FileManager.readTxtFile(path);
			
			var tStockName:String;
			tStockName = FileManager.getFileName(path);
			var stockData:StockData;
			stockData = new StockData();
			stockData.init(data);
			doAnalyse(stockData);
		}
		
		public function doAnalyse(stockData:StockData):void
		{
			
		}
	}

}