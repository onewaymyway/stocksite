package nodetools.devices
{
	/**
	 * ...
	 * @author ww
	 */
	public class FileTools
	{
		
		public function FileTools()
		{
			
		}
		public static var win:*;
		public static var fs:*;
		public static var path:*;
		public static var shell:*;
		public static var tempApp:*;
		public static function init():void
		{
			
			fs = Device.require("fs");
			path=Device.require("path");
			shell =Device.requireRemote("shell");
			tempApp = Device.remote.app.getDataPath();
			
		}
		public static function init2():void
		{
			
			fs = Device.require("fs");
			path=Device.require("path");
			
		}
		public static function getSep():String
		{
			return path.sep;
		}
		/**
		 * 获取当前系统的绝对路径 
		 * @param path
		 * @return 
		 * 
		 */
		public static function getAbsPath(path:String):String
		{

			return path;
		}
		/**
		 * 判断路径是否是绝对路径 
		 * @param path
		 * @return 
		 * 
		 */
		public static function isAbsPath(path:String):Boolean
		{
			if(!path) return false;
			if(path.indexOf(":")>0) return true;
			if(path.substr(0,1)=="/") return true;
			return false;
		}
		/**获得绝对路径*/
		public static function getPath(basePath:String, relativePath:String):String
		{
			return path.join(basePath, relativePath);
		}
		
		/**获得相对路径*/
		public static function getRelativePath(basePath:String, targetPath:String):String
		{
			return path.relative(basePath, targetPath);
		}
		
		public static function get appPath():String
		{
			var rst:String;
			var dirName:String;
			__JS__("dirName=__dirname;");
			rst=path.resolve(dirName, "../");
			return rst;
			var aPath:String;
			aPath = Browser.window.location.href;
			aPath = aPath.replace("file:///", "");
			aPath = aPath.replace("/h5/index.html", "");
			aPath=aPath.split("index.")[0];
//			trace("aPath:",aPath);
			aPath=decodeURI(aPath);
			//			trace(UrlDecode("%E6%88%91"));
			return aPath;
		}
		
		
		/**获得App目录路径*/
		public static function getAppPath(path:String):String
		{
			return getPath(appPath, path);
		}
		
		/**获得APP相对路径*/
		public static function getAppRelativePath(path:String):String
		{
			return getRelativePath(appPath, path);
		}
		
		public static function get workPath():String
		{
			return "workPath";
		}
		
		/**获得工作目录路径*/
		public static function getWorkPath(path:String):String
		{
			return getPath(workPath, path);
		}
		
		/**获得工作目录相对路径*/
		public static function getWorkRelativePath(path:String):String
		{
			return getRelativePath(workPath, path);
		}
		public static function getFileDir(path:String):String
		{
			if (!path) return path;
			if(FileTools.isDirectory(path)) return path;
			return FileTools.path.dirname(path);
//			if (path.indexOf(".") >= 0)
//			{
//				var lasti:int;
//				lasti = path.lastIndexOf("\\");
//				return path.substring(0, lasti);
//			}else
//			{
//				return path;
//			}
		}
		public static function getParent(path:String):String
		{
			if (!path) return path;
			var lasti:int;
			lasti = path.lastIndexOf(FileTools.path.sep);
			return path.substring(0, lasti);
		}
		/**获得文件名称（不带扩展名）*/
		public static function getFileName(path:String):String
		{
			return FileTools.path.basename(path).split(".")[0];
		}
		/**
		 * 获取带扩展名的文件名 
		 * @param path
		 * @return 
		 * 
		*/
		public static function getFileNameWithExtension(path:String):String
		{
			if (path == null)
				return null;
			var a:Array = path.split(FileTools.path.sep);
			var file:String = a[a.length - 1];
			return file;
		}
		/**
		 * 获取扩展名 
		 * @param path
		 * @return 
		 * 
		 */
		public static function getExtensionName(path:String):String
		{
			if (path == null)
				return null;
			var a:Array = path.split(".");
			var file:String = a[a.length - 1];
			return file;
		}
		
		/**创建目录*/
		public static function createDirectory(path:String):void
		{
			if (Boolean(path))
			{
				ensurePath(path);
				if (!fs.existsSync(path))
				{
					fs.mkdirSync(path);
				}
			}
		}
		public static function ensurePath(pathStr:String):void
		{
			//trace("ensure f:"+path);
			mkdirsSync(pathStr,null);
			return;
			if (pathStr == null) return;
			var sep:String;
			sep=path.sep;
			var a:Array = pathStr.split(sep);
			var i:int, len:int;
			var tPath:String;
			tPath = a[0];
			len = a.length - 1;
			for (i = 1; i < len; i++)
			{
				tPath += sep+a[i];
				//trace("tPath:"+tPath);
				if (!exist(tPath))
				{
					//trace("ensure:"+tPath);
					createDirectory(tPath);
				}
			}
		}
		
		public static function mkdirsSync(dirpath:String, mode:*):Boolean 
		{
			if (!fs.existsSync(dirpath)) {
				var pathtmp:String;
				var pathParts:Array = dirpath.split(path.sep);
				pathParts.pop();
				var onWindows:Boolean = OSInfo.type.indexOf("Windows") > -1;
				if(!onWindows)
				{
					pathtmp ="/" + pathParts[1];
					pathParts.splice(0,2);
				}
				
				pathParts.forEach(function(dirname:String):* {
					
					if (pathtmp) {
						pathtmp = path.join(pathtmp, dirname);
					}
					else {
						pathtmp = dirname ;
					}
					if (!fs.existsSync(pathtmp)) {
						if (!fs.mkdirSync(pathtmp, mode)) {
							return false;
						}
					}
				});
			}
			return true;
		}
		/**创建文件*/
		public static function createFile(path:String, value:String):void
		{
			ensurePath(path);
			fs.writeFileSync(path, value);
		}
		public static function  toBuffer(ab:*):* 
		{
			var buffer:* = new Device.Buffer(ab.byteLength);
			var view:* = new Uint8Array(ab);
			for (var i:int = 0; i < buffer.length; ++i) {
				buffer[i] = view[i];
			}
			return buffer;
		}
		/**读取文件*/
		public static function readFile(path:String,encoding:String="utf8"):*
		{
			if (fs.existsSync(path))
			{
				var rst:String;
				rst=fs.readFileSync(path, encoding);
				//trace(rst.charCodeAt(0),rst.charCodeAt(1),rst.charCodeAt(2));
				if((rst is String)&&rst.charCodeAt(0)==65279&&encoding=="utf8")
				{
					rst=rst.substr(1);
				}
				return rst;
			} 
			return null;
		}
		public static function appendFile(path:String,data:String):void
		{
			fs.appendFileSync(path,data);
		}
		public static function moveToTrash(path:String):void
		{
			if (exist(path))
			{
				if (shell)
				{
					shell.moveItemToTrash(path);
				}else
				{
					removeE(path,false);
				}
				
			}
				
		}
		/**删除文件(到回收站)*/
		public static function removeFile(path:String, toTrash:Boolean = true):void
		{
			if (toTrash)
			{
				moveToTrash(path);
				return;
			}
			if (Boolean(path))
			{
				fs.unlinkSync(path)
			}
		}
		
		public static function removeE(path:String, toTrash:Boolean = true):void
		{
			if (!exist(path))
				return;
			if (isDirectory(path))
			{
				removeDir(path,toTrash);
			}
			else
			{
				removeFile(path,toTrash);
			}
		}
		
		public static function removeDir(path:String, toTrash:Boolean = true ):void
		{
			if (toTrash)
			{
				moveToTrash(path);
				return;
			}
			
			
			var files:Array= [];
			
			if (fs.existsSync(path))
			{
				
				files = fs.readdirSync(path);
				
				files.forEach(function(file:String, index:int):void
				{
					
					var curPath:String = getPath(path, file);
					
					if (fs.statSync(curPath).isDirectory())
					{ // recurse
						
						removeDir(curPath);
						
					}
					else
					{ // delete file
						
						fs.unlinkSync(curPath);
						
					}
					
				});
				
				fs.rmdirSync(path);
				
			}
			
		}
		
		public static function exist(path:String):Boolean
		{
			if(!path) return false;
			return fs.existsSync(path);
		}
		
		public static function isDirectory(path:String):Boolean
		{
			var st:Object;
			try
			{
				st=fs.statSync(path);
			}catch(e:*)
			{
				return false;
			}
			
			if(!st) return false;
			return st.isDirectory();
		}
		
		public static function getStat(path:String):Object
		{
			return fs.statSync(path);
		}
		public static function getMTime(path:String):String
		{
			return getStat(path).mtime;
		}
		private static var watcherDic:Object = { };
		public static function watch(path:String, callBack:Function):*
		{
			//fs.watchFile(path, callBack);
			watcherDic[path] = fs.watch(path, callBack);
			return watcherDic[path];
		}
		public static function isDirWatched(path:String):Boolean
		{
			return watcherDic.hasOwnProperty(path);
		}
		public static function unwatch(path:String):void
		{
			if (watcherDic[path])
			{
				watcherDic[path].close();
				delete watcherDic[path];
			}
		}
		public static function copyE(from:String, to:String):void
		{
			if (!exist(from))
				return;
			if (isDirectory(from))
			{
				copyDir(from, to);
			}
			else
			{
				copyFile(from, to);
			}
		}
		
		/**复制文件*/
		public static function copyFile(from:String, to:String):void
		{
			createFile(to, readFile(from,null));
		}
		
		public static function copyDir(from:String, to:String):void
		{
			var files:Array = [];
			
			if (fs.existsSync(from))
			{
				createDirectory(to);
				files = fs.readdirSync(from);
				
				files.forEach(function(file:String, index:int):void
				{
					
					var curPath:String = getPath(from, file);
					var tPath:String = getPath(to, file);
					if (fs.statSync(curPath).isDirectory())
					{ // recurse
						
						copyDir(curPath, tPath);
						
					}
					else
					{ // delete file
						
						copyFile(curPath, tPath);
					}
					
				});
				
			}
		}
		

		
		/*
		
		递归处理文件,文件夹
		
		path 路径
		floor 层数
		handleFile 文件,文件夹处理函数
		
		*/
		
		public static function walk(path:String, floor:int, handleFile:Function,self:Boolean=false):void
		{
			if(self)
				handleFile(path, floor);
			floor++;
			var files:Array = fs.readdirSync(path);
			
			files.forEach(function(item:String):void
			{
				var tmpPath:String = getPath(path, item);
				if (tmpPath.indexOf(".svn") > -1)
					return;
				var stats:* = fs.statSync(tmpPath);
				if (stats.isDirectory())
				{
					walk(tmpPath, floor, handleFile);
				}
				else
				{
					handleFile(tmpPath, floor);
				}
				
			});
			
		}
		
		/**获取页面列表*/
		public static function getFileList(path:String):Array
		{
			
			var arr:Array = [];
			if(!FileTools.exist(path)) return arr;
			walk(path, 0, findFiles);
			function findFiles(spath:String, floor:int):void
			{
				
				arr.push(spath);
			}
			return arr;
		}
		
		public static function getFileDesO(path:String):Object
		{
			if (!exist(path))
				return null;
			var rst:Object = {};
			rst.label = getFileName(path);
			rst.path=path;
			if (isDirectory(path))
			{
				rst.files = [];
				rst.dirs = [];
				rst.childs = [];
				rst.isDirectory = true;
			}else
			{
				rst.isDirectory = false;
			}
			
			return rst;
		}

		public static function getDirChildDirs(p:String):Array{
			var files:Array=FileTools.getDirFiles(p);
			var i:int,len:int;
			var rst:Array;
			rst=[];
			len=files.length;
			for(i=0;i<len;i++){
				files[i]=path.join(p,files[i]);
				if(FileTools.isDirectory(files[i])){
					rst.push(files[i]);
				}
			}
			return rst;
		}
		public static function getDirFiles(path:String):Array
		{
			var rst:Array;
			rst=fs.readdirSync(path);
			//			trace("gerDirFiles:",rst.toString());
			rst.sort(folderFirst);
			//			trace("after sort gerDirFiles:",rst.toString());
			return rst;
		}
		public static function folderFirst(pathA:String,pathB:String):int
		{
			var isFolderA:Boolean;
			isFolderA=pathA.indexOf(".")<0;
			var isFolderB:Boolean;
			isFolderB=pathB.indexOf(".")<0;
			var right:int=-1;
			if(isFolderA)
			{
				if(!isFolderB)
				{
					return right;
				}
				return pathA<pathB?right:-right;
			}
			if(isFolderB)
			{
				return -right;
			}
			return pathA<pathB?right:-right;
		}
		public static function getFileTreeArr(path:String):Array	
		{
			var tTreeO:Object=getFileTreeO(path);
			var rst:Array=[];
			getTreeArr(tTreeO,rst,false);
			return rst;
			
		}
		private static function getTreeArr(treeO:Object,arr:Array,add:Boolean=true):void
		{
			if(add)
				arr.push(treeO);
			var tArr:Array=treeO.childs;
			var i:int,len:int=tArr.length;
			for(i=0;i<len;i++)
			{
				if(!add)
				{
					tArr[i].nodeParent=null;
				}
				if(tArr[i].isDirectory)
				{
					getTreeArr(tArr[i],arr);
				}else
				{
					arr.push(tArr[i]);
				}
			}
		}
		
		
		public static function getFileTreeO(path:String):Object
		{
			var rst:Object = getFileDesO(path);
			
			if (fs.existsSync(path))
			{
				
				var files:Array = getDirFiles(path);
				var tO:Object;
				files.forEach(function(file:String, index:int):void
				{
					
					var curPath:String = getPath(path, file);
					
					if (fs.statSync(curPath).isDirectory())
					{ // recurse
						
						tO = getFileTreeO(curPath);
						tO.nodeParent = rst;
						tO.hasChild = tO.childs.length > 0;
						rst.dirs.push(tO);
						
					}
					else
					{ // delete file
						tO = getFileDesO(curPath);
						tO.nodeParent = rst;
						tO.hasChild = false;
						rst.files.push(tO);
						
					}
					tO.label = file;
					rst.childs.push(tO);
					
				});
				rst.hasChild = rst.childs.length > 0;
				
			}
			return rst;
			
		}
		
		public static function isPathSame(a:String,b:String):Boolean
		{
			if(a.toLocaleLowerCase()==b.toLocaleLowerCase()) return true;
			return false;
	    }
		/**重命名*/
		public static function rename(oldPath:String, newPath:String):void
		{
			if (!exist(oldPath))
				return;
			if(isPathSame(oldPath,newPath))
			{
				Alert.show("在移动文件到同一个位置！！");
				return;
			}
			copyE(oldPath,newPath);
			
			moveToTrash(oldPath);
			return;
			fs.renameSync(oldPath, newPath);
		}
		public static function openItem(path:String):void
		{
//			shell.showItemInFolder(path);
			
			shell.openItem(path);
		}
		public static function showItemInFolder(path:String):void
		{
			shell.showItemInFolder(path);
			
			//			shell.openItem(path);
		}
		
		public static function getFolder(path:String):String
		{
			path=FileManager.adptToCommonUrl(path);
			var idx:int;
			idx=path.lastIndexOf(".");
			if(idx>=0)
			{
				idx=path.lastIndexOf("/",idx);
				if(idx>=0)
				{
					path=path.substr(0,idx);
				}
			}
			return path;
		}
	}
	
}