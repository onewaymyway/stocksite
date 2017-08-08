package stockserver 
{
	import laya.server.core.Byte;
	import nodetools.server.WSClient;
	import stockserver.users.UserData;
	import stockserver.users.UserSystem;
	
	/**
	 * ...
	 * @author ww
	 */
	public class StockClient extends WSClient 
	{
		public var mServer:StockServer;
		public var userData:UserData = new UserData();
		public function StockClient() 
		{
			super();
			
		}
		override public function init(wsocket:*, server:*):void 
		{
			super.init(wsocket, server);
			mServer = server;
		}
		override public function onMessage(message:*):void 
		{
			trace("StockClient:onMessage", message);
			var data:Object;
			data = JSON.parse(message);
			trace(data);
			if (data.type != StockMsg.Login && !userData.isLogined)
			{
				return;
			}
			switch(data.type)
			{
				case StockMsg.Login:
					userData.login(data.user, data.pwd);
					sendJson({type:data.type,rst:userData.isLogined});
					break;
				case StockMsg.Regist:
					sendJson( {type:data.type,rst:UserSystem.I.createUser(data.user,data.pwd});
					break;
				case StockMsg.SaveMyStocks:
					trace("saveData:", data.sign, data.data);
					UserSystem.I.saveUserData(userData.userName, data.sign, data.data);
					sendJson( {type:data.type,rst:1});
					break;
				case StockMsg.GetStocks:
					sendJson({type:data.type,sign:data.sign,data:UserSystem.I.getUserDataEx(userData.userName,data.sign)});
					break;
			}
		}
		
		override public function onOpen():void 
		{
			sendJson(MsgTool.createMsg(StockMsg.Welcome));
		}
	}

}