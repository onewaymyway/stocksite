package nodetools.devices {
	import laya.debug.tools.StringTool;
	
	/**文件管理类
	 * @author yung
	 */
	public class FileManager {
		
		/**
		 * 获得绝对路径
		 * @param basePath 根路径
		 * @param relativePath 相对路径
		 * @return 绝对路径
		 * 
		 */
		public static function getPath(basePath:String, relativePath:String):String {
			return FileTools.getPath(basePath, relativePath);
		}
		
		/**
		 * 获得相对路径
		 * @param basePath 根路径
		 * @param targetPath 绝对路径
		 * @return 相对路径
		 * 
		 */
		public static function getRelativePath(basePath:String, targetPath:String):String {
			return adptToCommonUrl(FileTools.getRelativePath(basePath, targetPath));
		}
		
		/**获得App目录路径*/
		public static function getAppPath(path:String):String {
			return getPath(SystemSetting.appPath, path);
		}
		public static function getDataPath(path:String):String
		{
//			Device.appPath;
//			trace("getDataPath:",getPath(Device.dataPath, path));
			return getPath(Device.dataPath, path);
		}
		/**获得APP相对路径*/
		public static function getAppRelativePath(path:String):String {
			return getRelativePath(SystemSetting.appPath, path);
		}
		
		/**获得工作目录路径*/
		public static function getWorkPath(path:String):String {
			return getPath(SystemSetting.workPath, path);
		}
		
		
		/**获得工作目录相对路径*/
		public static function getWorkRelativePath(path:String):String {
			return adptToCommonUrl(getRelativePath(SystemSetting.workPath, path));
		}
		
		public static function getResRelativePath(path:String):String
		{
			return adptToCommonUrl(""+getRelativePath(SystemSetting.assetsPath, path));
		}
		public static function adptToCommonUrl(url:String):String
		{
			return StringTool.getReplace(url,"\\\\","/");
		}
		public static function adptToLocalUrl(url:String):String
		{
			return FileTools.path.normalize(url);
		}
		public static function getResPath(path:String):String
		{
			return getPath(SystemSetting.assetsPath, path);
		}
		public static function getPagePath(path:String):String
		{
			return getPath(SystemSetting.pagesPath,path);
		}
		/**获得文件名称*/
		public static function getFileName(path:String):String {
			return FileTools.path.basename(path).split(".")[0];
		}
		
		
		/**
		 * 创建目录 
		 * @param path 目录路径
		 * 
		 */
		public static function createDirectory(path:String):void {
			try {
				FileTools.createDirectory(path);
			} catch (e:Error) {
				Sys.alert("Create folder failed:" + path);
			}
		}
		
		/**
		 * 创建文本文件 
		 * @param path 文件路径
		 * @param value 文件内容
		 * 
		 */
		public static function createTxtFile(path:String, value:String):void {
			try {
				FileTools.createFile(path, value);
			} catch (e:Error) {
				Sys.alert("Create file failed:" + path);
			}
		}
		
		/**
		 * 创建json文件 
		 * @param path 文件路径
		 * @param value json对象
		 * 
		 */
		public static function createJSONFile(path:String, value:Object):void {
			try {
				FileTools.createFile(path, JSON.stringify(value));
			} catch (e:Error) {
				Sys.alert("Create file failed:" + path);
			}
		}
		
		/**创建文件*/
		public static function createBytesFile(path:String, bytes:*):void {
			try {
				FileTools.createFile(path, bytes);
			} catch (e:Error) {
				Sys.alert("Create file failed:" + path);
			}
		}
		
		/**
		 * 删除文件(到回收站)
		 * @param path 文件路径
		 * 
		 */
		public static function removeFile(path:String):void {
			FileTools.removeE(path);
		}
		
		/**
		 * 复制文件
		 * @param from 源文件
		 * @param to 目标路径
		 * 
		 */
		public static function copyFile(from:String, to:String):void {
			try {
				FileTools.copyE(from, to);
			} catch (e:Error) {
				Sys.alert("Copy file failed:(from:" + from + " to:" + to + ")");
				trace("Copy file failed:(from:" + from + " to:" + to + ")");
			}
		}
		
		/**
		 * 读取文本文件
		 * @param path 文件路径
		 * @param errorAlert 出错是否弹出提示
		 * @return 文件内容
		 * 
		 */
		public static function readTxtFile(path:String, errorAlert:Boolean = true):String {
			try {
				return FileTools.readFile(path);
			} catch (e:Error) {
				if (errorAlert) Sys.alert("Read file failed:" + path);
			}
			return null;
		}
		
		/**
		 * 读取JSON文件
		 * @param path 文件路径
		 * @param errorAlert 出错是否弹出提示
		 * @return json对象
		 * 
		 */
		public static function readJSONFile(path:String, errorAlert:Boolean = true):Object {
			try {
				var str:String = FileManager.readTxtFile(path);
				return JSON.parse(str);
			} catch (e:*) {
				if (errorAlert) Sys.alert("Read file failed:" + path);
				debugger;
			}
			return null;
		}
		
		/**读取二进制文件*/
		public static function readByteFile(path:String, errorAlert:Boolean = true):* {
			try {
				return FileTools.readFile(path);
			} catch (e:Error) {
				if (errorAlert) Sys.alert("Read file failed:" + path);
			}
			return null;
		}
		
		/**
		 * 获取文件夹下的文件列表 
		 * @param path 文件夹路径
		 * @return 文件列表
		 * 
		 */
		public static function getFileList(path:String):Array {
			return FileTools.getFileList(path);
		}
		
		/**
		 * 判断文件是否存在 
		 * @param path 文件路径
		 * @return 是否存在
		 * 
		 */
		public static function exists(path:String):Boolean
		{
			return FileTools.exist(path);
		}
		/**获取页面列表*/
		public static function getFileTree(path:String, hasExtension:Boolean = false):XML {
			var xml:XML = findFiles(path);
			function findFiles(path:String):XML {
				var node:*;
				if (FileTools.exist(path)) {
					var fileName:String = FileTools.getFileName(path);
					node = new XMLElement("<item label='" + fileName + "' path='" + path + "' isDirectory='true'/>");
					var a:Array = FileTools.getDirFiles(path);
					for each (var f:String in a) {
						f = FileTools.getPath(path, f);
						if (FileTools.isDirectory(f) && f.indexOf(".svn") == -1) {
							node.appendChild(findFiles(f));
						}
					}
					for each (f in a) {
						f = FileTools.getPath(path, f);
						if (FileTools.isDirectory(f) == false) {
							if (fileName.indexOf("$") == -1 && fileName.indexOf("@") == -1) {
								node.appendChild(new XMLElement("<item label='" + fileName + "' path='" + f + "' isDirectory='false'/>"));
							}
						}
					}
				}
				return node;
			}
			return xml
		}
		
		/**重命名*/
		public static function rename(oldPath:String, newPath:String):void {
			try {
				FileTools.rename(oldPath, newPath);
			} catch (e:Error) {
				Sys.alert("Rename file failed:(from:" + oldPath + " to:" + newPath + ")");
			}
		}
	}
}