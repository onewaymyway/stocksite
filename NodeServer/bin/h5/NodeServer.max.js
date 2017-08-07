var window = window || global;
var document = document || (window.document = {});
/***********************************/
/*http://www.layabox.com 2017/01/16*/
/***********************************/
var Laya=window.Laya=(function(window,document){
	var Laya={
		__internals:[],
		__packages:{},
		__classmap:{'Object':Object,'Function':Function,'Array':Array,'String':String},
		__sysClass:{'object':'Object','array':'Array','string':'String','dictionary':'Dictionary'},
		__propun:{writable: true,enumerable: false,configurable: true},
		__presubstr:String.prototype.substr,
		__substr:function(ofs,sz){return arguments.length==1?Laya.__presubstr.call(this,ofs):Laya.__presubstr.call(this,ofs,sz>0?sz:(this.length+sz));},
		__init:function(_classs){_classs.forEach(function(o){o.__init$ && o.__init$();});},
		__isClass:function(o){return o && (o.__isclass || o==Object || o==String || o==Array);},
		__newvec:function(sz,value){
			var d=[];
			d.length=sz;
			for(var i=0;i<sz;i++) d[i]=value;
			return d;
		},
		__extend:function(d,b){
			for (var p in b){
				if (!b.hasOwnProperty(p)) continue;
				var gs=Object.getOwnPropertyDescriptor(b, p);
				var g = gs.get, s = gs.set; 
				if ( g || s ) {
					if ( g && s)
						Object.defineProperty(d,p,gs);
					else{
						g && Object.defineProperty(d, p, g);
						s && Object.defineProperty(d, p, s);
					}
				}
				else d[p] = b[p];
			}
			function __() { Laya.un(this,'constructor',d); }__.prototype=b.prototype;d.prototype=new __();Laya.un(d.prototype,'__imps',Laya.__copy({},b.prototype.__imps));
		},
		__copy:function(dec,src){
			if(!src) return null;
			dec=dec||{};
			for(var i in src) dec[i]=src[i];
			return dec;
		},
		__package:function(name,o){
			if(Laya.__packages[name]) return;
			Laya.__packages[name]=true;
			var p=window,strs=name.split('.');
			if(strs.length>1){
				for(var i=0,sz=strs.length-1;i<sz;i++){
					var c=p[strs[i]];
					p=c?c:(p[strs[i]]={});
				}
			}
			p[strs[strs.length-1]] || (p[strs[strs.length-1]]=o||{});
		},
		__hasOwnProperty:function(name,o){
			o=o ||this;
		    function classHas(name,o){
				if(Object.hasOwnProperty.call(o.prototype,name)) return true;
				var s=o.prototype.__super;
				return s==null?null:classHas(name,s);
			}
			return (Object.hasOwnProperty.call(o,name)) || classHas(name,o.__class);
		},
		__typeof:function(o,value){
			if(!o || !value) return false;
			if(value===String) return (typeof o==='string');
			if(value===Number) return (typeof o==='number');
			if(value.__interface__) value=value.__interface__;
			else if(typeof value!='string')  return (o instanceof value);
			return (o.__imps && o.__imps[value]) || (o.__class==value);
		},
		__as:function(value,type){
			return (this.__typeof(value,type))?value:null;
		},		
		interface:function(name,_super){
			Laya.__package(name,{});
			var ins=Laya.__internals;
			var a=ins[name]=ins[name] || {self:name};
			if(_super)
			{
				var supers=_super.split(',');
				a.extend=[];
				for(var i=0;i<supers.length;i++){
					var nm=supers[i];
					ins[nm]=ins[nm] || {self:nm};
					a.extend.push(ins[nm]);
				}
			}
			var o=window,words=name.split('.');
			for(var i=0;i<words.length-1;i++) o=o[words[i]];
			o[words[words.length-1]]={__interface__:name};
		},
		class:function(o,fullName,_super,miniName){
			_super && Laya.__extend(o,_super);
			if(fullName){
				Laya.__package(fullName,o);
				Laya.__classmap[fullName]=o;
				if(fullName.indexOf('.')>0){
					if(fullName.indexOf('laya.')==0){
						var paths=fullName.split('.');
						miniName=miniName || paths[paths.length-1];
						if(Laya[miniName]) console.log("Warning!,this class["+miniName+"] already exist:",Laya[miniName]);
						Laya[miniName]=o;
					}
				}
				else {
					if(fullName=="Main")
						window.Main=o;
					else{
						if(Laya[fullName]){
							console.log("Error!,this class["+fullName+"] already exist:",Laya[fullName]);
						}
						Laya[fullName]=o;
					}
				}
			}
			var un=Laya.un,p=o.prototype;
			un(p,'hasOwnProperty',Laya.__hasOwnProperty);
			un(p,'__class',o);
			un(p,'__super',_super);
			un(p,'__className',fullName);
			un(o,'__super',_super);
			un(o,'__className',fullName);
			un(o,'__isclass',true);
			un(o,'super',function(o){this.__super.call(o);});
		},
		imps:function(dec,src){
			if(!src) return null;
			var d=dec.__imps|| Laya.un(dec,'__imps',{});
			function __(name){
				var c,exs;
				if(! (c=Laya.__internals[name]) ) return;
				d[name]=true;
				if(!(exs=c.extend)) return;
				for(var i=0;i<exs.length;i++){
					__(exs[i].self);
				}
			}
			for(var i in src) __(i);
		},
		getset:function(isStatic,o,name,getfn,setfn){
			if(!isStatic){
				getfn && Laya.un(o,'_$get_'+name,getfn);
				setfn && Laya.un(o,'_$set_'+name,setfn);
			}
			else{
				getfn && (o['_$GET_'+name]=getfn);
				setfn && (o['_$SET_'+name]=setfn);
			}
			if(getfn && setfn) 
				Object.defineProperty(o,name,{get:getfn,set:setfn,enumerable:false});
			else{
				getfn && Object.defineProperty(o,name,{get:getfn,enumerable:false});
				setfn && Object.defineProperty(o,name,{set:setfn,enumerable:false});
			}
		},
		static:function(_class,def){
				for(var i=0,sz=def.length;i<sz;i+=2){
					if(def[i]=='length') 
						_class.length=def[i+1].call(_class);
					else{
						function tmp(){
							var name=def[i];
							var getfn=def[i+1];
							Object.defineProperty(_class,name,{
								get:function(){delete this[name];return this[name]=getfn.call(this);},
								set:function(v){delete this[name];this[name]=v;},enumerable: true,configurable: true});
						}
						tmp();
					}
				}
		},		
		un:function(obj,name,value){
			value || (value=obj[name]);
			Laya.__propun.value=value;
			Object.defineProperty(obj, name, Laya.__propun);
			return value;
		},
		uns:function(obj,names){
			names.forEach(function(o){Laya.un(obj,o)});
		}
	};

	window.console=window.console || ({log:function(){}});
	window.trace=window.console.log;
	Error.prototype.throwError=function(){throw arguments;};
	String.prototype.substr=Laya.__substr;
	Object.defineProperty(Array.prototype,'fixed',{enumerable: false});

	return Laya;
})(window,document);

(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;
	/**
	*全局引用类
	*/
	//class Laya
	var ___Laya=(function(){
		//function Laya(){};
		Laya.init=function(frameRate){
			(frameRate===void 0)&& (frameRate=60);
			setInterval(function(){Laya.timer._update()},1000 / frameRate);
		}

		__static(Laya,
		['timer',function(){return this.timer=new Timer();}
		]);
		return Laya;
	})()


	/**
	*...
	*@author ww
	*/
	//class NodeServer
	var NodeServer=(function(){
		function NodeServer(){
			Laya.init();
			Device.init();
			SystemSetting.isCMDVer=true;
			OSInfo.init();
			FileTools.init2();
			SystemSetting.appPath=NodeJSTools.getMyPath();
			UserSystem.UserPath=FileManager.getAppPath("user/");
			this.test();
		}

		__class(NodeServer,'NodeServer');
		var __proto=NodeServer.prototype;
		__proto.test=function(){
			var config;
			config={};
			config.perMessageDeflate=false;
			config.port=9909;
			var mServer;
			mServer=new StockServer();
			mServer.run(config);
		}

		return NodeServer;
	})()


	/**
	*封装所有驱动级接口
	*@author yung
	*/
	//class nodetools.devices.Device
	var Device=(function(){
		function Device(){};
		__class(Device,'nodetools.devices.Device');
		Device.init=function(){
			Device.Buffer=Buffer;
		}

		Device.require=function(mod){
			var rst;
			rst=require(mod);
			return rst;
		}

		Device.requireRemote=function(mod){
			if (!Device.remote)return Device.require(mod);
			return Device.remote.require(mod);
		}

		Device.app=null
		Device.appName="LayaAir";
		Device.appPath=null
		Device.dataPath=null
		Device.tempPath=null
		Device.workPath=null
		Device.userHome=null
		Device.extensionPath=null
		Device.remote=null
		Device.Buffer=null
		Device.electron=null
		Device.win=null
		return Device;
	})()


	/**文件管理类
	*@author yung
	*/
	//class nodetools.devices.FileManager
	var FileManager=(function(){
		function FileManager(){};
		__class(FileManager,'nodetools.devices.FileManager');
		FileManager.getPath=function(basePath,relativePath){
			return FileTools.getPath(basePath,relativePath);
		}

		FileManager.getRelativePath=function(basePath,targetPath){
			return FileManager.adptToCommonUrl(FileTools.getRelativePath(basePath,targetPath));
		}

		FileManager.getAppPath=function(path){
			return FileManager.getPath(SystemSetting.appPath,path);
		}

		FileManager.getDataPath=function(path){
			return FileManager.getPath(Device.dataPath,path);
		}

		FileManager.getAppRelativePath=function(path){
			return FileManager.getRelativePath(SystemSetting.appPath,path);
		}

		FileManager.getWorkPath=function(path){
			return FileManager.getPath(SystemSetting.workPath,path);
		}

		FileManager.getWorkRelativePath=function(path){
			return FileManager.adptToCommonUrl(FileManager.getRelativePath(SystemSetting.workPath,path));
		}

		FileManager.getResRelativePath=function(path){
			return FileManager.adptToCommonUrl(""+FileManager.getRelativePath(SystemSetting.assetsPath,path));
		}

		FileManager.adptToCommonUrl=function(url){
			return laya.debug.tools.StringTool.getReplace(url,"\\\\","/");
		}

		FileManager.adptToLocalUrl=function(url){
			return FileTools.path.normalize(url);
		}

		FileManager.getResPath=function(path){
			return FileManager.getPath(SystemSetting.assetsPath,path);
		}

		FileManager.getPagePath=function(path){
			return FileManager.getPath(SystemSetting.pagesPath,path);
		}

		FileManager.getFileName=function(path){
			return FileTools.path.basename(path).split(".")[0];
		}

		FileManager.createDirectory=function(path){
			try {
				FileTools.createDirectory(path);
				}catch (e){
				Sys.alert("Create folder failed:"+path);
			}
		}

		FileManager.createTxtFile=function(path,value){
			try {
				FileTools.createFile(path,value);
				}catch (e){
				Sys.alert("Create file failed:"+path);
			}
		}

		FileManager.createJSONFile=function(path,value){
			try {
				FileTools.createFile(path,JSON.stringify(value));
				}catch (e){
				Sys.alert("Create file failed:"+path);
			}
		}

		FileManager.createBytesFile=function(path,bytes){
			try {
				FileTools.createFile(path,bytes);
				}catch (e){
				Sys.alert("Create file failed:"+path);
			}
		}

		FileManager.removeFile=function(path){
			FileTools.removeE(path);
		}

		FileManager.copyFile=function(from,to){
			try {
				FileTools.copyE(from,to);
				}catch (e){
				Sys.alert("Copy file failed:(from:"+from+" to:"+to+")");
				console.log("Copy file failed:(from:"+from+" to:"+to+")");
			}
		}

		FileManager.readTxtFile=function(path,errorAlert){
			(errorAlert===void 0)&& (errorAlert=true);
			try {
				return FileTools.readFile(path);
				}catch (e){
				if (errorAlert)Sys.alert("Read file failed:"+path);
			}
			return null;
		}

		FileManager.readJSONFile=function(path,errorAlert){
			(errorAlert===void 0)&& (errorAlert=true);
			try {
				var str=nodetools.devices.FileManager.readTxtFile(path);
				return JSON.parse(str);
				}catch (e){
				if (errorAlert)Sys.alert("Read file failed:"+path);
				debugger;
			}
			return null;
		}

		FileManager.readByteFile=function(path,errorAlert){
			(errorAlert===void 0)&& (errorAlert=true);
			try {
				return FileTools.readFile(path);
				}catch (e){
				if (errorAlert)Sys.alert("Read file failed:"+path);
			}
			return null;
		}

		FileManager.getFileList=function(path){
			return FileTools.getFileList(path);
		}

		FileManager.exists=function(path){
			return FileTools.exist(path);
		}

		FileManager.getFileTree=function(path,hasExtension){
			(hasExtension===void 0)&& (hasExtension=false);
			var xml=findFiles(path);
			function findFiles (path){
				var node;
				if (FileTools.exist(path)){
					var fileName=FileTools.getFileName(path);
					node=new /*no*/this.XMLElement("<item label='"+fileName+"' path='"+path+"' isDirectory='true'/>");
					var a=FileTools.getDirFiles(path);
					var f;
					for(var $each_f in a){
						f=a[$each_f];
						f=FileTools.getPath(path,f);
						if (FileTools.isDirectory(f)&& f.indexOf(".svn")==-1){
							node.appendChild(findFiles(f));
						}
					}
					var $each_f;
					for($each_f in a){
						f=a[$each_f];
						f=FileTools.getPath(path,f);
						if (FileTools.isDirectory(f)==false){
							if (fileName.indexOf("$")==-1 && fileName.indexOf("@")==-1){
								node.appendChild(new /*no*/this.XMLElement("<item label='"+fileName+"' path='"+f+"' isDirectory='false'/>"));
							}
						}
					}
				}
				return node;
			}
			return xml
		}

		FileManager.rename=function(oldPath,newPath){
			try {
				FileTools.rename(oldPath,newPath);
				}catch (e){
				Sys.alert("Rename file failed:(from:"+oldPath+" to:"+newPath+")");
			}
		}

		return FileManager;
	})()


	/**
	*...
	*@author ww
	*/
	//class nodetools.devices.FileTools
	var FileTools=(function(){
		function FileTools(){}
		__class(FileTools,'nodetools.devices.FileTools');
		__getset(1,FileTools,'appPath',function(){
			var rst;
			var dirName;
			dirName=__dirname;;
			rst=FileTools.path.resolve(dirName,"../");
			return rst;
			var aPath;
			aPath=/*no*/this.Browser.window.location.href;
			aPath=aPath.replace("file:///","");
			aPath=aPath.replace("/h5/index.html","");
			aPath=aPath.split("index.")[0];
			aPath=decodeURI(aPath);
			return aPath;
		});

		__getset(1,FileTools,'workPath',function(){
			return "workPath";
		});

		FileTools.init=function(){
			FileTools.fs=Device.require("fs");
			FileTools.path=Device.require("path");
			FileTools.shell=Device.requireRemote("shell");
			FileTools.tempApp=Device.remote.app.getDataPath();
		}

		FileTools.init2=function(){
			FileTools.fs=Device.require("fs");
			FileTools.path=Device.require("path");
		}

		FileTools.getSep=function(){
			return FileTools.path.sep;
		}

		FileTools.getAbsPath=function(path){
			return path;
		}

		FileTools.isAbsPath=function(path){
			if(!path)return false;
			if(path.indexOf(":")>0)return true;
			if(path.substr(0,1)=="/")return true;
			return false;
		}

		FileTools.getPath=function(basePath,relativePath){
			return FileTools.path.join(basePath,relativePath);
		}

		FileTools.getRelativePath=function(basePath,targetPath){
			return FileTools.path.relative(basePath,targetPath);
		}

		FileTools.getAppPath=function(path){
			return FileTools.getPath(FileTools.appPath,path);
		}

		FileTools.getAppRelativePath=function(path){
			return FileTools.getRelativePath(FileTools.appPath,path);
		}

		FileTools.getWorkPath=function(path){
			return FileTools.getPath(FileTools.workPath,path);
		}

		FileTools.getWorkRelativePath=function(path){
			return FileTools.getRelativePath(FileTools.workPath,path);
		}

		FileTools.getFileDir=function(path){
			if (!path)return path;
			if(nodetools.devices.FileTools.isDirectory(path))return path;
			return nodetools.devices.FileTools.path.dirname(path);
		}

		FileTools.getParent=function(path){
			if (!path)return path;
			var lasti=0;
			lasti=path.lastIndexOf(nodetools.devices.FileTools.path.sep);
			return path.substring(0,lasti);
		}

		FileTools.getFileName=function(path){
			return nodetools.devices.FileTools.path.basename(path).split(".")[0];
		}

		FileTools.getFileNameWithExtension=function(path){
			if (path==null)
				return null;
			var a=path.split(nodetools.devices.FileTools.path.sep);
			var file=a[a.length-1];
			return file;
		}

		FileTools.getExtensionName=function(path){
			if (path==null)
				return null;
			var a=path.split(".");
			var file=a[a.length-1];
			return file;
		}

		FileTools.createDirectory=function(path){
			if (Boolean(path)){
				FileTools.ensurePath(path);
				if (!FileTools.fs.existsSync(path)){
					FileTools.fs.mkdirSync(path);
				}
			}
		}

		FileTools.ensurePath=function(pathStr){
			FileTools.mkdirsSync(pathStr,null);
			return;
			if (pathStr==null)return;
			var sep;
			sep=FileTools.path.sep;
			var a=pathStr.split(sep);
			var i=0,len=0;
			var tPath;
			tPath=a[0];
			len=a.length-1;
			for (i=1;i < len;i++){
				tPath+=sep+a[i];
				if (!FileTools.exist(tPath)){
					FileTools.createDirectory(tPath);
				}
			}
		}

		FileTools.mkdirsSync=function(dirpath,mode){
			if (!FileTools.fs.existsSync(dirpath)){
				var pathtmp;
				var pathParts=dirpath.split(FileTools.path.sep);
				pathParts.pop();
				var onWindows=OSInfo.type.indexOf("Windows")>-1;
				if(!onWindows){
					pathtmp="/"+pathParts[1];
					pathParts.splice(0,2);
				}
				pathParts.forEach(function(dirname){
					if (pathtmp){
						pathtmp=FileTools.path.join(pathtmp,dirname);
					}
					else {
						pathtmp=dirname;
					}
					if (!FileTools.fs.existsSync(pathtmp)){
						if (!FileTools.fs.mkdirSync(pathtmp,mode)){
							return false;
						}
					}
				});
			}
			return true;
		}

		FileTools.createFile=function(path,value){
			FileTools.ensurePath(path);
			FileTools.fs.writeFileSync(path,value);
		}

		FileTools.toBuffer=function(ab){
			var buffer=new Device.Buffer(ab.byteLength);
			var view=new Uint8Array(ab);
			for (var i=0;i < buffer.length;++i){
				buffer[i]=view[i];
			}
			return buffer;
		}

		FileTools.readFile=function(path,encoding){
			(encoding===void 0)&& (encoding="utf8");
			if (FileTools.fs.existsSync(path)){
				var rst;
				rst=FileTools.fs.readFileSync(path,encoding);
				if(((typeof rst=='string'))&&rst.charCodeAt(0)==65279&&encoding=="utf8"){
					rst=rst.substr(1);
				}
				return rst;
			}
			return null;
		}

		FileTools.appendFile=function(path,data){
			FileTools.fs.appendFileSync(path,data);
		}

		FileTools.moveToTrash=function(path){
			if (FileTools.exist(path)){
				if (FileTools.shell){
					FileTools.shell.moveItemToTrash(path);
					}else{
					FileTools.removeE(path,false);
				}
			}
		}

		FileTools.removeFile=function(path,toTrash){
			(toTrash===void 0)&& (toTrash=true);
			if (toTrash){
				FileTools.moveToTrash(path);
				return;
			}
			if (Boolean(path)){
				FileTools.fs.unlinkSync(path)
			}
		}

		FileTools.removeE=function(path,toTrash){
			(toTrash===void 0)&& (toTrash=true);
			if (!FileTools.exist(path))
				return;
			if (FileTools.isDirectory(path)){
				FileTools.removeDir(path,toTrash);
			}
			else{
				FileTools.removeFile(path,toTrash);
			}
		}

		FileTools.removeDir=function(path,toTrash){
			(toTrash===void 0)&& (toTrash=true);
			if (toTrash){
				FileTools.moveToTrash(path);
				return;
			};
			var files=[];
			if (FileTools.fs.existsSync(path)){
				files=FileTools.fs.readdirSync(path);
				files.forEach(function(file,index){
					var curPath=FileTools.getPath(path,file);
					if (FileTools.fs.statSync(curPath).isDirectory()){
						FileTools.removeDir(curPath);
					}
					else{
						FileTools.fs.unlinkSync(curPath);
					}
				});
				FileTools.fs.rmdirSync(path);
			}
		}

		FileTools.exist=function(path){
			if(!path)return false;
			return FileTools.fs.existsSync(path);
		}

		FileTools.isDirectory=function(path){
			var st;
			try{
				st=FileTools.fs.statSync(path);
				}catch(e){
				return false;
			}
			if(!st)return false;
			return st.isDirectory();
		}

		FileTools.getStat=function(path){
			return FileTools.fs.statSync(path);
		}

		FileTools.getMTime=function(path){
			return FileTools.getStat(path).mtime;
		}

		FileTools.watch=function(path,callBack){
			FileTools.watcherDic[path]=FileTools.fs.watch(path,callBack);
			return FileTools.watcherDic[path];
		}

		FileTools.isDirWatched=function(path){
			return FileTools.watcherDic.hasOwnProperty(path);
		}

		FileTools.unwatch=function(path){
			if (FileTools.watcherDic[path]){
				FileTools.watcherDic[path].close();
				delete FileTools.watcherDic[path];
			}
		}

		FileTools.copyE=function(from,to){
			if (!FileTools.exist(from))
				return;
			if (FileTools.isDirectory(from)){
				FileTools.copyDir(from,to);
			}
			else{
				FileTools.copyFile(from,to);
			}
		}

		FileTools.copyFile=function(from,to){
			FileTools.createFile(to,FileTools.readFile(from,null));
		}

		FileTools.copyDir=function(from,to){
			var files=[];
			if (FileTools.fs.existsSync(from)){
				FileTools.createDirectory(to);
				files=FileTools.fs.readdirSync(from);
				files.forEach(function(file,index){
					var curPath=FileTools.getPath(from,file);
					var tPath=FileTools.getPath(to,file);
					if (FileTools.fs.statSync(curPath).isDirectory()){
						FileTools.copyDir(curPath,tPath);
					}
					else{
						FileTools.copyFile(curPath,tPath);
					}
				});
			}
		}

		FileTools.walk=function(path,floor,handleFile,self){
			(self===void 0)&& (self=false);
			if(self)
				handleFile(path,floor);
			floor++;
			var files=FileTools.fs.readdirSync(path);
			files.forEach(function(item){
				var tmpPath=FileTools.getPath(path,item);
				if (tmpPath.indexOf(".svn")>-1)
					return;
				var stats=FileTools.fs.statSync(tmpPath);
				if (stats.isDirectory()){
					FileTools.walk(tmpPath,floor,handleFile);
				}
				else{
					handleFile(tmpPath,floor);
				}
			});
		}

		FileTools.getFileList=function(path){
			var arr=[];
			if(!nodetools.devices.FileTools.exist(path))return arr;
			FileTools.walk(path,0,findFiles);
			function findFiles (spath,floor){
				arr.push(spath);
			}
			return arr;
		}

		FileTools.getFileDesO=function(path){
			if (!FileTools.exist(path))
				return null;
			var rst={};
			rst.label=FileTools.getFileName(path);
			rst.path=path;
			if (FileTools.isDirectory(path)){
				rst.files=[];
				rst.dirs=[];
				rst.childs=[];
				rst.isDirectory=true;
				}else{
				rst.isDirectory=false;
			}
			return rst;
		}

		FileTools.getDirChildDirs=function(p){
			var files=nodetools.devices.FileTools.getDirFiles(p);
			var i=0,len=0;
			var rst;
			rst=[];
			len=files.length;
			for(i=0;i<len;i++){
				files[i]=FileTools.path.join(p,files[i]);
				if(nodetools.devices.FileTools.isDirectory(files[i])){
					rst.push(files[i]);
				}
			}
			return rst;
		}

		FileTools.getDirFiles=function(path){
			var rst;
			rst=FileTools.fs.readdirSync(path);
			rst.sort(FileTools.folderFirst);
			return rst;
		}

		FileTools.folderFirst=function(pathA,pathB){
			var isFolderA=false;
			isFolderA=pathA.indexOf(".")<0;
			var isFolderB=false;
			isFolderB=pathB.indexOf(".")<0;
			var right=-1;
			if(isFolderA){
				if(!isFolderB){
					return right;
				}
				return pathA<pathB?right:-right;
			}
			if(isFolderB){
				return-right;
			}
			return pathA<pathB?right:-right;
		}

		FileTools.getFileTreeArr=function(path){
			var tTreeO=FileTools.getFileTreeO(path);
			var rst=[];
			FileTools.getTreeArr(tTreeO,rst,false);
			return rst;
		}

		FileTools.getTreeArr=function(treeO,arr,add){
			(add===void 0)&& (add=true);
			if(add)
				arr.push(treeO);
			var tArr=treeO.childs;
			var i=0,len=tArr.length;
			for(i=0;i<len;i++){
				if(!add){
					tArr[i].nodeParent=null;
				}
				if(tArr[i].isDirectory){
					FileTools.getTreeArr(tArr[i],arr);
					}else{
					arr.push(tArr[i]);
				}
			}
		}

		FileTools.getFileTreeO=function(path){
			var rst=FileTools.getFileDesO(path);
			if (FileTools.fs.existsSync(path)){
				var files=FileTools.getDirFiles(path);
				var tO;
				files.forEach(function(file,index){
					var curPath=FileTools.getPath(path,file);
					if (FileTools.fs.statSync(curPath).isDirectory()){
						tO=FileTools.getFileTreeO(curPath);
						tO.nodeParent=rst;
						tO.hasChild=tO.childs.length > 0;
						rst.dirs.push(tO);
					}
					else{
						tO=FileTools.getFileDesO(curPath);
						tO.nodeParent=rst;
						tO.hasChild=false;
						rst.files.push(tO);
					}
					tO.label=file;
					rst.childs.push(tO);
				});
				rst.hasChild=rst.childs.length > 0;
			}
			return rst;
		}

		FileTools.isPathSame=function(a,b){
			if(a.toLocaleLowerCase()==b.toLocaleLowerCase())return true;
			return false;
		}

		FileTools.rename=function(oldPath,newPath){
			if (!FileTools.exist(oldPath))
				return;
			if(FileTools.isPathSame(oldPath,newPath)){
				/*no*/this.Alert.show("在移动文件到同一个位置！！");
				return;
			}
			FileTools.copyE(oldPath,newPath);
			FileTools.moveToTrash(oldPath);
			return;
			FileTools.fs.renameSync(oldPath,newPath);
		}

		FileTools.openItem=function(path){
			FileTools.shell.openItem(path);
		}

		FileTools.showItemInFolder=function(path){
			FileTools.shell.showItemInFolder(path);
		}

		FileTools.getFolder=function(path){
			path=FileManager.adptToCommonUrl(path);
			var idx=0;
			idx=path.lastIndexOf(".");
			if(idx>=0){
				idx=path.lastIndexOf("/",idx);
				if(idx>=0){
					path=path.substr(0,idx);
				}
			}
			return path;
		}

		FileTools.win=null
		FileTools.fs=null
		FileTools.path=null
		FileTools.shell=null
		FileTools.tempApp=null
		FileTools.watcherDic={};
		return FileTools;
	})()


	/**
	*...
	*@author ww
	*/
	//class nodetools.devices.NodeJSTools
	var NodeJSTools=(function(){
		function NodeJSTools(){}
		__class(NodeJSTools,'nodetools.devices.NodeJSTools');
		NodeJSTools.require=function(str){
			return require(str);;
		}

		NodeJSTools.getArgv=function(){
			var argv;
			argv=process.argv;;
			console.log("argv:",argv);
			return argv;
		}

		NodeJSTools.parseArgToObj=function(args,start,target){
			(start===void 0)&& (start=0);
			var i=0,len=0;
			len=args.length;
			var tParam;
			var pArr;
			for (i=start;i < len;i++){
				tParam=args[i];
				if (tParam.indexOf("=")> 0){
					pArr=tParam.split("=");
					if (target[pArr[0]] && typeof(target[pArr[0]])=="number"){
						pArr[1]=Sys.mParseFloat(pArr[1]);
					}
					console.log(pArr);
					target[pArr[0]]=pArr[1];
				}
			}
		}

		NodeJSTools.getMyPath=function(){
			return __dirname;
		}

		return NodeJSTools;
	})()


	/**
	*...
	*@author ww
	*/
	//class nodetools.devices.OSInfo
	var OSInfo=(function(){
		function OSInfo(){}
		__class(OSInfo,'nodetools.devices.OSInfo');
		OSInfo.init=function(){
			OSInfo.os=Device.require("os");
			OSInfo.platform=OSInfo.os.platform();
			OSInfo.tempdir=OSInfo.os.tmpdir();
			OSInfo.type=OSInfo.os.type();
			var tProcess;
			tProcess=process;;
			OSInfo.process=tProcess;
			OSInfo.env=OSInfo.process.env;
			console.log("type:",OSInfo.type);
		}

		OSInfo.os=null
		OSInfo.platform=null
		OSInfo.homedir=null
		OSInfo.tempdir=null
		OSInfo.type=null
		OSInfo.process=null
		OSInfo.env=null
		return OSInfo;
	})()


	/**
	*编辑器全局静态入口
	*@author ww
	*/
	//class nodetools.devices.Sys
	var Sys=(function(){
		function Sys(){};
		__class(Sys,'nodetools.devices.Sys');
		Sys.mParseFloat=function(v){
			v=parseFloat(v);
			if (isNaN(v))return 0;
			return v;
		}

		Sys.log=function(__args){
			var args=arguments;
			Sys.print("log",args,"#0080C0");
		}

		Sys.error=function(__args){
			var args=arguments;
			Sys.print("error",args,"#FF0000");
		}

		Sys.warn=function(__args){
			var args=arguments;
			Sys.print("warn",args,"#9B9B00");
		}

		Sys.plugin=function(__args){
			var args=arguments;
			Sys.print("plugin",args,"#007300");
		}

		Sys.print=function(type,args,color){
			var msg="";
			for (var i=0;i < args.length;i++){
				msg+=args[i]+" ";
			}
			console.log("%c ["+type+"]"+msg,"color: "+color+"");
		}

		Sys.alert=function(msg){
			console.log(msg);
		}

		Sys.lang=function(body,__args){
			var args=[];for(var i=1,sz=arguments.length;i<sz;i++)args.push(arguments[i]);
			var i=0,len=0;
			len=args.length;
			for (i=0;i < len;i++){
				body=body.replace("{"+i+"}",args[i]);
			}
			return body;
		}

		return Sys;
	})()


	/**系统配置
	*@author ww
	*/
	//class nodetools.devices.SystemSetting
	var SystemSetting=(function(){
		function SystemSetting(){};
		__class(SystemSetting,'nodetools.devices.SystemSetting');
		SystemSetting.setProject=function(path){
			if (FileTools.exist(path)){
				SystemSetting.projectPath=path;
				SystemSetting.projectName=FileTools.getFileName(path).replace(".laya","");
				SystemSetting.workPath=FileTools.path.dirname(path);
				SystemSetting.workPath=FileTools.path.dirname(SystemSetting.workPath);
				SystemSetting.pagesPath=FileManager.getWorkPath("laya/pages");
				SystemSetting.assetsPath=FileManager.getWorkPath("laya/assets");
				SystemSetting.stylePath=FileManager.getWorkPath("laya/styles.xml");
				SystemSetting.pageStylePath=FileManager.getWorkPath("laya/pageStyles.xml");
				SystemSetting.tempPath=FileManager.getPath(FileTools.tempApp,"data/"+SystemSetting.projectName)
				FileManager.createDirectory(SystemSetting.pagesPath);
				FileManager.createDirectory(SystemSetting.assetsPath);
				FileManager.createDirectory(SystemSetting.tempPath);
			}
		}

		SystemSetting.workPath="";
		SystemSetting.appPath="";
		SystemSetting.projectName="";
		SystemSetting.projectPath="";
		SystemSetting.pagesPath="";
		SystemSetting.assetsPath="";
		SystemSetting.stylePath="";
		SystemSetting.pageStylePath="";
		SystemSetting.tempResPath="";
		SystemSetting.tempVerPath="";
		SystemSetting.tempPath="";
		SystemSetting.lang="";
		SystemSetting.ifShowRuleGrid=true;
		SystemSetting.toCodeModeWhenPublicEnd=false;
		SystemSetting.isCMDVer=false;
		return SystemSetting;
	})()


	/**
	*...
	*@author ww
	*/
	//class nodetools.server.WSClient
	var WSClient=(function(){
		function WSClient(){
			this.socketO=null;
			this.serverO=null;
			this.funDic={};
			this.funDic["message"]=Utils.bind(this.onMessage,this);
			this.funDic["close"]=Utils.bind(this.onClose,this);
		}

		__class(WSClient,'nodetools.server.WSClient');
		var __proto=WSClient.prototype;
		//funDic["open"]=Utils.bind(onOpen,this);
		__proto.init=function(wsocket,server){
			this.serverO=server;
			var _this;
			_this=this;
			this.socketO=wsocket;
			var key;
			for (key in this.funDic){
				this.socketO.on(key,this.funDic[key]);
			}
			this.onOpen();
		}

		__proto.send=function(data){
			this.socketO.send(data);
		}

		__proto.sendJson=function(data){
			this.send(JSON.stringify(data));
		}

		__proto.onMessage=function(message){
			console.log("onMessage");
			console.log('received: %s',message);
		}

		__proto.onClose=function(code,reason){
			this.serverO.removeClient(this);
		}

		__proto.onOpen=function(){
			console.log("onOpen");
			this.send("hihi new client");
		}

		return WSClient;
	})()


	/**
	*...
	*@author ww
	*/
	//class nodetools.server.WSServer
	var WSServer=(function(){
		function WSServer(){
			this.serverO=null;
			this.clients=[];
			this.clientClz=null;
		}

		__class(WSServer,'nodetools.server.WSServer');
		var __proto=WSServer.prototype;
		__proto.run=function(config){
			var WebSocket=NodeJSTools.require("ws");
			var _self;
			_self=this;
			var serverO=new WebSocket.Server(config);
			serverO.on('connection',connection=function(ws){
				_self.onConnection(ws);
			});
		}

		__proto.createClient=function(){
			if (this.clientClz)return new this.clientClz();
			return new WSClient();
		}

		__proto.onConnection=function(ws){
			var tClient=this.createClient();
			tClient.init(ws,this);
			this.clients.push(tClient);
		}

		__proto.removeClient=function(client){
			var i=0,len=0;
			len=this.clients.length;
			for (i=0;i < len;i++){
				if (this.clients[i]==client){
					this.clients.splice(i,1);
					break ;
				}
			}
		}

		__proto.sendToAll=function(data,but){
			var i=0,len=0;
			len=this.clients.length;
			var tClient;
			for (i=0;i < len;i++){
				tClient=this.clients[i];
				if (tClient !=but){
					tClient.send(data);
				}
			}
		}

		return WSServer;
	})()


	/**
	*...
	*@author ww
	*/
	//class stockserver.users.UserData
	var UserData=(function(){
		function UserData(){
			this.userName=null;
			this.isLogined=false;
		}

		__class(UserData,'stockserver.users.UserData');
		var __proto=UserData.prototype;
		__proto.login=function(userName,pwd){
			this.userName=userName;
			this.isLogined=UserSystem.I.login(userName,pwd);
		}

		return UserData;
	})()


	/**
	*...
	*@author ww
	*/
	//class stockserver.users.UserSystem
	var UserSystem=(function(){
		function UserSystem(){}
		__class(UserSystem,'stockserver.users.UserSystem');
		var __proto=UserSystem.prototype;
		__proto.isUserNameOK=function(userName){
			return UserSystem.nameReg.test(userName);
		}

		__proto.isPwdOK=function(pwd){
			return (UserSystem.pwdReg.test(pwd));
		}

		__proto.login=function(userName,userPwd){
			if (!userName)return false;
			var dataO;
			dataO=this.getUserData(userName);
			if (!dataO)return false;
			return dataO.pwd==userPwd;
		}

		__proto.getUserPath=function(userName){
			return FileManager.getPath(UserSystem.UserPath,userName+".data");
		}

		__proto.createUser=function(userName,userPwd){
			if (!this.isUserNameOK(userName))return false;
			var userPath;
			userPath=this.getUserPath(userName);
			if (FileManager.exists(userPath)){
				return false;
			};
			var userData;
			userData={};
			userData.pwd=userPwd;
			FileManager.createJSONFile(userPath,userData);
			return true;
		}

		__proto.getUserData=function(userName){
			var userPath;
			userPath=this.getUserPath(userName);
			if (!FileManager.exists(userPath)){
				return null;
			}
			return FileManager.readJSONFile(userPath,false);
		}

		__proto.getUserDataEx=function(userName,sign){
			var dataO;
			dataO=this.getUserData(userName);
			if (!dataO)return null;
			return dataO[sign];
		}

		__proto.saveUserData=function(userName,sign,data){
			var dataO;
			dataO=this.getUserData(userName);
			if (!dataO)return null;
			dataO[sign]=data;
			var userPath;
			userPath=this.getUserPath(userName);
			FileManager.createJSONFile(userPath,dataO);
		}

		UserSystem.UserPath=null
		__static(UserSystem,
		['I',function(){return this.I=new UserSystem();},'nameReg',function(){return this.nameReg=new RegExp("^[A-Za-z]+$");},'pwdReg',function(){return this.pwdReg=new RegExp("^[A-Za-z0-9]+$");}
		]);
		return UserSystem;
	})()


	/**
	*
	*<code>Byte</code> 类提供用于优化读取、写入以及处理二进制数据的方法和属性。
	*/
	//class laya.server.core.Byte
	var Byte=(function(){
		function Byte(data){
			this._xd_=true;
			this._allocated_=8;
			//this._d_=null;
			//this._u8d_=null;
			this._pos_=0;
			this._length=0;
			if (data){
				this._u8d_=new Uint8Array(data);
				this._d_=new DataView(this._u8d_.buffer);
				this._length=this._d_.byteLength;
				}else {
				this.___resizeBuffer(this._allocated_);
			}
		}

		__class(Byte,'laya.server.core.Byte');
		var __proto=Byte.prototype;
		/**@private */
		__proto.___resizeBuffer=function(len){
			try {
				var newByteView=new Uint8Array(len);
				if (this._u8d_ !=null){
					if (this._u8d_.length <=len)newByteView.set(this._u8d_);
					else newByteView.set(this._u8d_.subarray(0,len));
				}
				this._u8d_=newByteView;
				this._d_=new DataView(newByteView.buffer);
				}catch (err){
				throw "___resizeBuffer err:"+len;
			}
		}

		/**
		*读取字符型值。
		*@return
		*/
		__proto.getString=function(){
			return this.rUTF(this.getUint16());
		}

		/**
		*从指定的位置读取指定长度的数据用于创建一个 Float32Array 对象并返回此对象。
		*@param start 开始位置。
		*@param len 需要读取的字节长度。
		*@return 读出的 Float32Array 对象。
		*/
		__proto.getFloat32Array=function(start,len){
			var v=new Float32Array(this._d_.buffer.slice(start,start+len));
			this._pos_+=len;
			return v;
		}

		/**
		*从指定的位置读取指定长度的数据用于创建一个 Uint8Array 对象并返回此对象。
		*@param start 开始位置。
		*@param len 需要读取的字节长度。
		*@return 读出的 Uint8Array 对象。
		*/
		__proto.getUint8Array=function(start,len){
			var v=new Uint8Array(this._d_.buffer.slice(start,start+len));
			this._pos_+=len;
			return v;
		}

		/**
		*从指定的位置读取指定长度的数据用于创建一个 Int16Array 对象并返回此对象。
		*@param start 开始位置。
		*@param len 需要读取的字节长度。
		*@return 读出的 Uint8Array 对象。
		*/
		__proto.getInt16Array=function(start,len){
			var v=new Int16Array(this._d_.buffer.slice(start,start+len));
			this._pos_+=len;
			return v;
		}

		/**
		*在指定字节偏移量位置处读取 Float32 值。
		*@return Float32 值。
		*/
		__proto.getFloat32=function(){
			var v=this._d_.getFloat32(this._pos_,this._xd_);
			this._pos_+=4;
			return v;
		}

		__proto.getFloat64=function(){
			var v=this._d_.getFloat64(this._pos_,this._xd_);
			this._pos_+=8;
			return v;
		}

		/**
		*在当前字节偏移量位置处写入 Float32 值。
		*@param value 需要写入的 Float32 值。
		*/
		__proto.writeFloat32=function(value){
			this.ensureWrite(this._pos_+4);
			this._d_.setFloat32(this._pos_,value,this._xd_);
			this._pos_+=4;
		}

		__proto.writeFloat64=function(value){
			this.ensureWrite(this._pos_+8);
			this._d_.setFloat64(this._pos_,value,this._xd_);
			this._pos_+=8;
		}

		/**
		*在当前字节偏移量位置处读取 Int32 值。
		*@return Int32 值。
		*/
		__proto.getInt32=function(){
			var float=this._d_.getInt32(this._pos_,this._xd_);
			this._pos_+=4;
			return float;
		}

		/**
		*在当前字节偏移量位置处读取 Uint32 值。
		*@return Uint32 值。
		*/
		__proto.getUint32=function(){
			var v=this._d_.getUint32(this._pos_,this._xd_);
			this._pos_+=4;
			return v;
		}

		/**
		*在当前字节偏移量位置处写入 Int32 值。
		*@param value 需要写入的 Int32 值。
		*/
		__proto.writeInt32=function(value){
			this.ensureWrite(this._pos_+4);
			this._d_.setInt32(this._pos_,value,this._xd_);
			this._pos_+=4;
		}

		/**
		*在当前字节偏移量位置处写入 Uint32 值。
		*@param value 需要写入的 Uint32 值。
		*/
		__proto.writeUint32=function(value){
			this.ensureWrite(this._pos_+4);
			this._d_.setUint32(this._pos_,value,this._xd_);
			this._pos_+=4;
		}

		/**
		*在当前字节偏移量位置处读取 Int16 值。
		*@return Int16 值。
		*/
		__proto.getInt16=function(){
			var us=this._d_.getInt16(this._pos_,this._xd_);
			this._pos_+=2;
			return us;
		}

		/**
		*在当前字节偏移量位置处读取 Uint16 值。
		*@return Uint16 值。
		*/
		__proto.getUint16=function(){
			var us=this._d_.getUint16(this._pos_,this._xd_);
			this._pos_+=2;
			return us;
		}

		/**
		*在当前字节偏移量位置处写入 Uint16 值。
		*@param value 需要写入的Uint16 值。
		*/
		__proto.writeUint16=function(value){
			this.ensureWrite(this._pos_+2);
			this._d_.setUint16(this._pos_,value,this._xd_);
			this._pos_+=2;
		}

		/**
		*在当前字节偏移量位置处写入 Int16 值。
		*@param value 需要写入的 Int16 值。
		*/
		__proto.writeInt16=function(value){
			this.ensureWrite(this._pos_+2);
			this._d_.setInt16(this._pos_,value,this._xd_);
			this._pos_+=2;
		}

		/**
		*在当前字节偏移量位置处读取 Uint8 值。
		*@return Uint8 值。
		*/
		__proto.getUint8=function(){
			return this._d_.getUint8(this._pos_++);
		}

		/**
		*在当前字节偏移量位置处写入 Uint8 值。
		*@param value 需要写入的 Uint8 值。
		*/
		__proto.writeUint8=function(value){
			this.ensureWrite(this._pos_+1);
			this._d_.setUint8(this._pos_,value,this._xd_);
			this._pos_++;
		}

		/**
		*@private
		*在指定位置处读取 Uint8 值。
		*@param pos 字节读取位置。
		*@return Uint8 值。
		*/
		__proto._getUInt8=function(pos){
			return this._d_.getUint8(pos);
		}

		/**
		*@private
		*在指定位置处读取 Uint16 值。
		*@param pos 字节读取位置。
		*@return Uint16 值。
		*/
		__proto._getUint16=function(pos){
			return this._d_.getUint16(pos,this._xd_);
		}

		/**
		*@private
		*读取指定长度的 UTF 型字符串。
		*@param len 需要读取的长度。
		*@return 读出的字符串。
		*/
		__proto.rUTF=function(len){
			var v="",max=this._pos_+len,c=0,c2=0,c3=0,f=String.fromCharCode;
			var u=this._u8d_,i=0;
			while (this._pos_ < max){
				c=u[this._pos_++];
				if (c < 0x80){
					if (c !=0){
						v+=f(c);
					}
					}else if (c < 0xE0){
					v+=f(((c & 0x3F)<< 6)| (u[this._pos_++] & 0x7F));
					}else if (c < 0xF0){
					c2=u[this._pos_++];
					v+=f(((c & 0x1F)<< 12)| ((c2 & 0x7F)<< 6)| (u[this._pos_++] & 0x7F));
					}else {
					c2=u[this._pos_++];
					c3=u[this._pos_++];
					v+=f(((c & 0x0F)<< 18)| ((c2 & 0x7F)<< 12)| ((c3 << 6)& 0x7F)| (u[this._pos_++] & 0x7F));
				}
				i++;
			}
			return v;
		}

		/**
		*字符串读取。
		*@param len
		*@return
		*/
		__proto.getCustomString=function(len){
			var v="",ulen=0,c=0,c2=0,f=String.fromCharCode;
			var u=this._u8d_,i=0;
			while (len > 0){
				c=u[this._pos_];
				if (c < 0x80){
					v+=f(c);
					this._pos_++;
					len--;
					}else {
					ulen=c-0x80;
					this._pos_++;
					len-=ulen;
					while (ulen > 0){
						c=u[this._pos_++];
						c2=u[this._pos_++];
						v+=f((c2 << 8)| c);
						ulen--;
					}
				}
			}
			return v;
		}

		/**
		*清除数据。
		*/
		__proto.clear=function(){
			this._pos_=0;
			this.length=0;
		}

		/**
		*@private
		*获取此对象的 ArrayBuffer 引用。
		*@return
		*/
		__proto.__getBuffer=function(){
			return this._d_.buffer;
		}

		/**
		*写入字符串，该方法写的字符串要使用 readUTFBytes 方法读取。
		*@param value 要写入的字符串。
		*/
		__proto.writeUTFBytes=function(value){
			value=value+"";
			for (var i=0,sz=value.length;i < sz;i++){
				var c=value.charCodeAt(i);
				if (c <=0x7F){
					this.writeByte(c);
					}else if (c <=0x7FF){
					this.writeByte(0xC0 | (c >> 6));
					this.writeByte(0x80 | (c & 63));
					}else if (c <=0xFFFF){
					this.writeByte(0xE0 | (c >> 12));
					this.writeByte(0x80 | ((c >> 6)& 63));
					this.writeByte(0x80 | (c & 63));
					}else {
					this.writeByte(0xF0 | (c >> 18));
					this.writeByte(0x80 | ((c >> 12)& 63));
					this.writeByte(0x80 | ((c >> 6)& 63));
					this.writeByte(0x80 | (c & 63));
				}
			}
		}

		/**
		*将 UTF-8 字符串写入字节流。
		*@param value 要写入的字符串值。
		*/
		__proto.writeUTFString=function(value){
			var tPos=0;
			tPos=this.pos;
			this.writeUint16(1);
			this.writeUTFBytes(value);
			var dPos=0;
			dPos=this.pos-tPos-2;
			this._d_.setUint16(tPos,dPos,this._xd_);
		}

		/**
		*@private
		*读取 UTF-8 字符串。
		*@return 读出的字符串。
		*/
		__proto.readUTFString=function(){
			var tPos=0;
			tPos=this.pos;
			var len=0;
			len=this.getUint16();
			return this.readUTFBytes(len);
		}

		/**
		*读取 UTF-8 字符串。
		*@return 读出的字符串。
		*/
		__proto.getUTFString=function(){
			return this.readUTFString();
		}

		/**
		*@private
		*读字符串，必须是 writeUTFBytes 方法写入的字符串。
		*@param len 要读的buffer长度,默认将读取缓冲区全部数据。
		*@return 读取的字符串。
		*/
		__proto.readUTFBytes=function(len){
			(len===void 0)&& (len=-1);
			if (len==0)return "";
			len=len > 0 ? len :this.bytesAvailable;
			return this.rUTF(len);
		}

		/**
		*读字符串，必须是 writeUTFBytes 方法写入的字符串。
		*@param len 要读的buffer长度,默认将读取缓冲区全部数据。
		*@return 读取的字符串。
		*/
		__proto.getUTFBytes=function(len){
			(len===void 0)&& (len=-1);
			return this.readUTFBytes(len);
		}

		/**
		*在字节流中写入一个字节。
		*@param value
		*/
		__proto.writeByte=function(value){
			this.ensureWrite(this._pos_+1);
			this._d_.setInt8(this._pos_,value);
			this._pos_+=1;
		}

		/**
		*@private
		*在字节流中读一个字节。
		*/
		__proto.readByte=function(){
			return this._d_.getInt8(this._pos_++);
		}

		/**
		*在字节流中读一个字节。
		*/
		__proto.getByte=function(){
			return this.readByte();
		}

		/**
		*指定该字节流的长度。
		*@param lengthToEnsure 指定的长度。
		*/
		__proto.ensureWrite=function(lengthToEnsure){
			if (this._length < lengthToEnsure)this._length=lengthToEnsure;
			if (this._allocated_ < lengthToEnsure)this.length=lengthToEnsure;
		}

		/**
		*写入指定的 Arraybuffer 对象。
		*@param arraybuffer 需要写入的 Arraybuffer 对象。
		*@param offset 偏移量（以字节为单位）
		*@param length 长度（以字节为单位）
		*/
		__proto.writeArrayBuffer=function(arraybuffer,offset,length){
			(offset===void 0)&& (offset=0);
			(length===void 0)&& (length=0);
			if (offset < 0 || length < 0)throw "writeArrayBuffer error - Out of bounds";
			if (length==0)length=arraybuffer.byteLength-offset;
			this.ensureWrite(this._pos_+length);
			var uint8array=new Uint8Array(arraybuffer);
			this._u8d_.set(uint8array.subarray(offset,offset+length),this._pos_);
			this._pos_+=length;
		}

		/**
		*获取此对象的 ArrayBuffer数据,数据只包含有效数据部分 。
		*/
		__getset(0,__proto,'buffer',function(){
			var rstBuffer=this._d_.buffer;
			if (rstBuffer.byteLength==this.length)return rstBuffer;
			return rstBuffer.slice(0,this.length);
		});

		/**
		*字节顺序。
		*/
		__getset(0,__proto,'endian',function(){
			return this._xd_ ? "littleEndian" :"bigEndian";
			},function(endianStr){
			this._xd_=(endianStr=="littleEndian");
		});

		/**
		*字节长度。
		*/
		__getset(0,__proto,'length',function(){
			return this._length;
			},function(value){
			if (this._allocated_ < value)
				this.___resizeBuffer(this._allocated_=Math.floor(Math.max(value,this._allocated_ *2)));
			else if (this._allocated_ > value)
			this.___resizeBuffer(this._allocated_=value);
			this._length=value;
		});

		/**
		*当前读取到的位置。
		*/
		__getset(0,__proto,'pos',function(){
			return this._pos_;
			},function(value){
			this._pos_=value;
			this._d_.byteOffset=value;
		});

		/**
		*可从字节流的当前位置到末尾读取的数据的字节数。
		*/
		__getset(0,__proto,'bytesAvailable',function(){
			return this.length-this._pos_;
		});

		Byte.getSystemEndian=function(){
			if (!Byte._sysEndian){
				var buffer=new ArrayBuffer(2);
				new DataView(buffer).setInt16(0,256,true);
				Byte._sysEndian=(new Int16Array(buffer))[0]===256 ? "littleEndian" :"bigEndian";
			}
			return Byte._sysEndian;
		}

		Byte.BIG_ENDIAN="bigEndian";
		Byte.LITTLE_ENDIAN="littleEndian";
		Byte._sysEndian=null;
		return Byte;
	})()


	/**
	*<code>Timer</code> 是时钟管理类。它是一个单例，可以通过 Laya.timer 访问。
	*/
	//class laya.server.core.Timer
	var Timer=(function(){
		var TimerHandler;
		function Timer(){
			this._delta=0;
			this.scale=1;
			this.currFrame=0;
			this._mid=1;
			this._map=[];
			this._laters=[];
			this._handlers=[];
			this._temp=[];
			this._count=0;
			this.currTimer=Date.now();
			this._lastTimer=Date.now();
			Laya.timer && Laya.timer.frameLoop(1,this,this._update);
		}

		__class(Timer,'laya.server.core.Timer');
		var __proto=Timer.prototype;
		/**
		*@private
		*帧循环处理函数。
		*/
		__proto._update=function(){
			if (this.scale <=0){
				this._lastTimer=Date.now();
				return;
			};
			var frame=this.currFrame=this.currFrame+this.scale;
			var now=Date.now();
			this._delta=(now-this._lastTimer)*this.scale;
			var timer=this.currTimer=this.currTimer+this._delta;
			this._lastTimer=now;
			var handlers=this._handlers;
			this._count=0;
			for (i=0,n=handlers.length;i < n;i++){
				handler=handlers[i];
				if (handler.method!==null){
					var t=handler.userFrame ? frame :timer;
					if (t >=handler.exeTime){
						if (handler.repeat){
							if (t > handler.exeTime){
								handler.exeTime+=handler.delay;
								handler.run(false);
								if (t > handler.exeTime){
									handler.exeTime+=Math.ceil((t-handler.exeTime)/ handler.delay)*handler.delay;
								}
							}
							}else {
							handler.run(true);
						}
					}
					}else {
					this._count++;
				}
			}
			if (this._count > 30 || frame % 200===0)this._clearHandlers();
			var laters=this._laters;
			for (var i=0,n=laters.length-1;i <=n;i++){
				var handler=laters[i];
				handler.method!==null && handler.run(false);
				this._recoverHandler(handler);
				i===n && (n=laters.length-1);
			}
			laters.length=0;
		}

		/**@private */
		__proto._clearHandlers=function(){
			var handlers=this._handlers;
			for (var i=0,n=handlers.length;i < n;i++){
				var handler=handlers[i];
				if (handler.method!==null)this._temp.push(handler);
				else this._recoverHandler(handler);
			}
			this._handlers=this._temp;
			this._temp=handlers;
			this._temp.length=0;
		}

		/**@private */
		__proto._recoverHandler=function(handler){
			this._map[handler.key]=null;
			handler.clear();
			Timer._pool.push(handler);
		}

		/**@private */
		__proto._create=function(useFrame,repeat,delay,caller,method,args,coverBefore){
			if (!delay){
				method.apply(caller,args);
				return;
			}
			if (coverBefore){
				var handler=this._getHandler(caller,method);
				if (handler){
					handler.repeat=repeat;
					handler.userFrame=useFrame;
					handler.delay=delay;
					handler.caller=caller;
					handler.method=method;
					handler.args=args;
					handler.exeTime=delay+(useFrame ? this.currFrame :Date.now());
					return;
				}
			}
			handler=Timer._pool.length > 0 ? Timer._pool.pop():new TimerHandler();
			handler.repeat=repeat;
			handler.userFrame=useFrame;
			handler.delay=delay;
			handler.caller=caller;
			handler.method=method;
			handler.args=args;
			handler.exeTime=delay+(useFrame ? this.currFrame :Date.now());
			this._indexHandler(handler);
			this._handlers.push(handler);
		}

		/**@private */
		__proto._indexHandler=function(handler){
			var caller=handler.caller;
			var method=handler.method;
			var cid=caller ? caller.$_GID || (caller.$_GID=Utils.getGID()):0;
			var mid=method.$_TID || (method.$_TID=(this._mid++)*100000);
			handler.key=cid+mid;
			this._map[handler.key]=handler;
		}

		/**
		*定时执行一次。
		*@param delay 延迟时间(单位为毫秒)。
		*@param caller 执行域(this)。
		*@param method 定时器回调函数。
		*@param args 回调参数。
		*@param coverBefore 是否覆盖之前的延迟执行，默认为 true 。
		*/
		__proto.once=function(delay,caller,method,args,coverBefore){
			(coverBefore===void 0)&& (coverBefore=true);
			this._create(false,false,delay,caller,method,args,coverBefore);
		}

		/**
		*定时重复执行。
		*@param delay 间隔时间(单位毫秒)。
		*@param caller 执行域(this)。
		*@param method 定时器回调函数。
		*@param args 回调参数。
		*@param coverBefore 是否覆盖之前的延迟执行，默认为 true 。
		*/
		__proto.loop=function(delay,caller,method,args,coverBefore){
			(coverBefore===void 0)&& (coverBefore=true);
			this._create(false,true,delay,caller,method,args,coverBefore);
		}

		/**
		*定时执行一次(基于帧率)。
		*@param delay 延迟几帧(单位为帧)。
		*@param caller 执行域(this)。
		*@param method 定时器回调函数。
		*@param args 回调参数。
		*@param coverBefore 是否覆盖之前的延迟执行，默认为 true 。
		*/
		__proto.frameOnce=function(delay,caller,method,args,coverBefore){
			(coverBefore===void 0)&& (coverBefore=true);
			this._create(true,false,delay,caller,method,args,coverBefore);
		}

		/**
		*定时重复执行(基于帧率)。
		*@param delay 间隔几帧(单位为帧)。
		*@param caller 执行域(this)。
		*@param method 定时器回调函数。
		*@param args 回调参数。
		*@param coverBefore 是否覆盖之前的延迟执行，默认为 true 。
		*/
		__proto.frameLoop=function(delay,caller,method,args,coverBefore){
			(coverBefore===void 0)&& (coverBefore=true);
			this._create(true,true,delay,caller,method,args,coverBefore);
		}

		/**返回统计信息。*/
		__proto.toString=function(){
			return "callLater:"+this._laters.length+" handlers:"+this._handlers.length+" pool:"+Timer._pool.length;
		}

		/**
		*清理定时器。
		*@param caller 执行域(this)。
		*@param method 定时器回调函数。
		*/
		__proto.clear=function(caller,method){
			var handler=this._getHandler(caller,method);
			if (handler){
				this._map[handler.key]=null;handler.key=0;
				handler.clear();
			}
		}

		/**
		*清理对象身上的所有定时器。
		*@param caller 执行域(this)。
		*/
		__proto.clearAll=function(caller){
			if (!caller)return;
			for (var i=0,n=this._handlers.length;i < n;i++){
				var handler=this._handlers[i];
				if (handler.caller===caller){
					this._map[handler.key]=null;handler.key=0;
					handler.clear();
				}
			}
		}

		/**@private */
		__proto._getHandler=function(caller,method){
			var cid=caller ? caller.$_GID || (caller.$_GID=Utils.getGID()):0;
			var mid=method.$_TID || (method.$_TID=(this._mid++)*100000);
			return this._map[cid+mid];
		}

		/**
		*延迟执行。
		*@param caller 执行域(this)。
		*@param method 定时器回调函数。
		*@param args 回调参数。
		*/
		__proto.callLater=function(caller,method,args){
			if (this._getHandler(caller,method)==null){
				if (Timer._pool.length)
					var handler=Timer._pool.pop();
				else handler=new TimerHandler();
				handler.caller=caller;
				handler.method=method;
				handler.args=args;
				this._indexHandler(handler);
				this._laters.push(handler);
			}
		}

		/**
		*立即执行 callLater 。
		*@param caller 执行域(this)。
		*@param method 定时器回调函数。
		*/
		__proto.runCallLater=function(caller,method){
			var handler=this._getHandler(caller,method);
			if (handler && handler.method !=null){
				this._map[handler.key]=null;
				handler.run(true);
			}
		}

		/**
		*两帧之间的时间间隔,单位毫秒。
		*/
		__getset(0,__proto,'delta',function(){
			return this._delta;
		});

		Timer._pool=[];
		Timer.__init$=function(){
			/**@private */
			//class TimerHandler
			TimerHandler=(function(){
				function TimerHandler(){
					this.key=0;
					this.repeat=false;
					this.delay=0;
					this.userFrame=false;
					this.exeTime=0;
					this.caller=null;
					this.method=null;
					this.args=null;
				}
				__class(TimerHandler,'');
				var __proto=TimerHandler.prototype;
				__proto.clear=function(){
					this.caller=null;
					this.method=null;
					this.args=null;
				}
				__proto.run=function(widthClear){
					var caller=this.caller;
					if (caller && caller.destroyed)return this.clear();
					var method=this.method;
					var args=this.args;
					widthClear && this.clear();
					if (method==null)return;
					args ? method.apply(caller,args):method.call(caller);
				}
				return TimerHandler;
			})()
		}

		return Timer;
	})()


	/**
	*<code>Utils</code> 是工具类。
	*/
	//class laya.server.core.Utils
	var Utils=(function(){
		function Utils(){};
		__class(Utils,'laya.server.core.Utils');
		Utils.toRadian=function(angle){
			return angle *Utils._pi2;
		}

		Utils.toAngle=function(radian){
			return radian *Utils._pi;
		}

		Utils.getGID=function(){
			return Utils._gid++;
		}

		Utils.bind=function(fun,scope){
			var rst=fun;
			rst=fun.bind(scope);;
			return rst;
		}

		Utils.updateOrder=function(array){
			if (!array || array.length < 2)return false;
			var i=1,j=0,len=array.length,key=NaN,c;
			while (i < len){
				j=i;
				c=array[j];
				key=array[j]._zOrder;
				while (--j >-1){
					if (array[j]._zOrder > key)array[j+1]=array[j];
					else break ;
				}
				array[j+1]=c;
				i++;
			}
			return true;
		}

		Utils._gid=1;
		Utils._pi=180 / Math.PI;
		Utils._pi2=Math.PI / 180;
		Utils._extReg=/\.(\w+)\??/g;
		return Utils;
	})()


	/**
	*...
	*@author ww
	*/
	//class MsgTool
	var MsgTool=(function(){
		function MsgTool(){}
		__class(MsgTool,'MsgTool');
		MsgTool.createMsg=function(type,data){
			var rst;
			rst={};
			rst.type=type;
			rst.data=data;
			return rst;
		}

		return MsgTool;
	})()


	/**
	*...
	*@author ww
	*/
	//class stockserver.StockClient extends nodetools.server.WSClient
	var StockClient=(function(_super){
		function StockClient(){
			this.mServer=null;
			this.userData=new UserData();
			StockClient.__super.call(this);
		}

		__class(StockClient,'stockserver.StockClient',_super);
		var __proto=StockClient.prototype;
		__proto.init=function(wsocket,server){
			_super.prototype.init.call(this,wsocket,server);
			this.mServer=server;
		}

		__proto.onMessage=function(message){
			console.log("StockClient:onMessage",message);
			var data;
			data=JSON.parse(message);
			console.log(data);
			if (data.type !="login" && !this.userData.isLogined){
				return;
			}
			switch(data.type){
				case "login":
					this.userData.login(data.user,data.pwd);
					this.sendJson({type:data.type,rst:this.userData.isLogined});
					break ;
				case "SaveMyStocks":
					console.log("saveData:",data.sign,data.data);
					UserSystem.I.saveUserData(this.userData.userName,data.sign,data.data);
					this.sendJson({type:data.type,rst:1});
					break ;
				case "GetStocks":
					this.sendJson({type:data.type,sign:data.sign,data:UserSystem.I.getUserDataEx(this.userData.userName,data.sign)});
					break ;
				}
		}

		__proto.onOpen=function(){
			this.sendJson(MsgTool.createMsg("welcome"));
		}

		return StockClient;
	})(WSClient)


	/**
	*...
	*@author ww
	*/
	//class stockserver.StockServer extends nodetools.server.WSServer
	var StockServer=(function(_super){
		function StockServer(){
			StockServer.__super.call(this);
			this.clientClz=StockClient;
		}

		__class(StockServer,'stockserver.StockServer',_super);
		return StockServer;
	})(WSServer)


	Laya.__init([Timer]);
	new NodeServer();

})(window,document,Laya);


/*
1 file:///D:/stocksite.git/trunk/NodeServer/src/nodetools/devices/FileManager.as (225):warning:XMLElement This variable is not defined.
2 file:///D:/stocksite.git/trunk/NodeServer/src/nodetools/devices/FileManager.as (237):warning:XMLElement This variable is not defined.
3 file:///D:/stocksite.git/trunk/NodeServer/src/nodetools/devices/FileTools.as (82):warning:Browser.window.location.href This variable is not defined.
4 file:///D:/stocksite.git/trunk/NodeServer/src/nodetools/devices/FileTools.as (82):warning:Browser.window.location.href This variable is not defined.
5 file:///D:/stocksite.git/trunk/NodeServer/src/nodetools/devices/FileTools.as (642):warning:Alert.show This variable is not defined.
*/