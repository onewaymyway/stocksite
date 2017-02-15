package nodetools.devices {
	
	/**系统配置
	 * @author ww
	 */
	public class SystemSetting {
		
		/**工作目录*/
		public static var workPath:String = "";
		/**编辑器目录*/
		public static var appPath:String = "";
		/**项目名称*/
		public static var projectName:String = "";
		/**项目地址*/
		public static var projectPath:String = "";
		/**页面存放地址*/
		public static var pagesPath:String = "";
		/**资源存放地址*/
		public static var assetsPath:String = "";
		/**资源样式地址*/
		public static var stylePath:String = "";
		/**页面样式地址*/
		public static var pageStylePath:String = "";
		/**临时资源地址*/
		public static var tempResPath:String = "";
		/**临时资源版本地址*/
		public static var tempVerPath:String = "";
		/**临时地址*/
		public static var tempPath:String = "";
		/**语言*/
		public static var lang:String = "";
		
		public static var ifShowRuleGrid:Boolean=true;
		public static var toCodeModeWhenPublicEnd:Boolean = false;
		
		public static var isCMDVer:Boolean = false;
		
		public static function setProject(path:String):void {
		
			if (FileTools.exist(path))
			{
				projectPath = path;
				projectName = FileTools.getFileName(path).replace(".laya","");
				workPath = FileTools.path.dirname(path);
				workPath= FileTools.path.dirname(workPath);
//				trace(workPath+"--------------------------------------");
//				SystemSetting.workPath=path.substr(0,path.lastIndexOf(window.path.sep));
				pagesPath = FileManager.getWorkPath("laya/pages");
				assetsPath = FileManager.getWorkPath("laya/assets");
				stylePath = FileManager.getWorkPath("laya/styles.xml");
				pageStylePath = FileManager.getWorkPath("laya/pageStyles.xml");
				tempPath = FileManager.getPath(FileTools.tempApp,"data/"+projectName)
//				SysLog.log("setProject path:"+path);
				FileManager.createDirectory(pagesPath);
				FileManager.createDirectory(assetsPath);
				FileManager.createDirectory(tempPath);
//				FileManager.createDirectory(tempResPath);
//				FileManager.createDirectory(tempVerPath);
	
				//Sys.stage.nativeWindow.title = projectName+" - Morn Builder";
			}

		}
	}
}