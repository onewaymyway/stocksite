///////////////////////////////////////////////////////////
//  CMDShell.as
//  Macromedia ActionScript Implementation of the Class CMDShell
//  Created on:      2015-10-30 下午3:27:37
//  Original author: ww
///////////////////////////////////////////////////////////

package nodetools.devices
{
	
	/**
	 * 本地程序调用封装
	 * @author ww
	 * @version 1.0
	 *
	 * @created  2015-10-30 下午3:27:37
	 */
	public class CMDShell
	{
		public function CMDShell()
		{
		}
		public static var childProcess:*;
		public static var iconv:*;
		
		public static function init():void
		{
			childProcess = Device.requireRemote("child_process");
			iconv = Device.requireRemote('iconv-lite');
		
		}
		/**
		 * 执行本地文件 
		 * @param fileName 文件名
		 * @param param 参数
		 * @param callBack 完成回调
		 * 
		 */
		public static function exeFile(fileName:String, param:Array, callBack:Function):void
		{
			childProcess.execFile(fileName, param, callBack);
		}
		
		/**
		 * 执行命令 
		 * @param cmd 命令
		 * @param callBack 完成回调，形式参照callBackTmp
		 * 
		 */
		public static function execute(cmd:String, callBack:Function = null,option:Object=null):void
		{
			trace("execute:",cmd);
			if(!option)
			{
				option={encoding: "binary",maxBuffer:1024*1024*20};
			}
			childProcess.exec(cmd, option, callBack);
		}
		
		public static function callBackTmp(err:String, stdOut:*, stdErr:String):void
		{
			trace("err:", err);
			//trace("stdOut:",stdOut);
			trace("stdErr:", stdErr);
			
			trace("stdOut:", iconv.decode(stdOut, "gbk"));
		}
		
		/**
		 * 执行命令行程序 
		 * @param cmd 命令
		 * @param callBack 完成回调，回调时传命令所产生的控制台输出
		 * 
		 */
		public static function executeExtra(cmd:String, callBack:Function):void
		{
			childProcess.exec(cmd, {encoding: "binary",maxBuffer:1024*1024*20}, function callBackTmp(err:String, stdOut:*, stdErr:String):void
				{
					trace("err:", err);
					//trace("stdOut:",stdOut);
					trace("stdErr:", stdErr);
					
					//trace("stdOut:", iconv.decode(stdOut, "gbk"));
					callBack(iconv.decode(stdOut, "gbk"));
				});
		}
		public static function decode(data:*,type:String):String
		{
			return iconv.decode(data, type);
		}
	}
}