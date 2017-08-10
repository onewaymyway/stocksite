package stockserver.users 
{
	import nodetools.devices.FileManager;
	import stock.tools.SMD5;
	/**
	 * ...
	 * @author ww
	 */
	public class UserSystem 
	{
		
		public function UserSystem() 
		{
			
		}
		public static var I:UserSystem=new UserSystem();
		public static var UserPath:String;
		public static var nameReg:RegExp = new RegExp("^[A-Za-z]+$");
		public static var pwdReg:RegExp=new RegExp("^[A-Za-z0-9]+$");
		public function isUserNameOK(userName:String):Boolean
		{
			return nameReg.test(userName);
		}
		public function isPwdOK(pwd:String):Boolean
		{
			return (pwdReg.test(pwd));
		}
		public function login(userName:String, userPwd:String):Boolean
		{
			if (!userName) return false;
			var dataO:Object;
			dataO = getUserData(userName);
			if (!dataO) return false;
			return SMD5.md5(dataO.pwd,userName,null) == userPwd;
		}
		
		public function getUserPath(userName:String):String
		{
			return FileManager.getPath(UserPath, userName + ".data");
		}
		public function createUser(userName:String, userPwd:String):Boolean
		{
			
			if (!isUserNameOK(userName)) return false;
			var userPath:String;
			userPath = getUserPath(userName);
			if (FileManager.exists(userPath))
			{
				return false;
			}
			var userData:Object;
			userData = { };
			userData.pwd = userPwd;
			FileManager.createJSONFile(userPath, userData);
			return true;
		}
		public function getUserData(userName:String):Object
		{
			var userPath:String;
			userPath = getUserPath(userName);
			if (!FileManager.exists(userPath))
			{
				return null;
			}
			return FileManager.readJSONFile(userPath, false);
		}
		
		public function getUserDataEx(userName:String, sign:String):*
		{
			var dataO:Object;
			dataO = getUserData(userName);
			if (!dataO) return null;
			return dataO[sign];
		}
		
		public function saveUserData(userName:String, sign:String, data:*):*
		{
			var dataO:Object;
			dataO = getUserData(userName);
			if (!dataO) return null;
			dataO[sign] = data;
			var userPath:String;
			userPath = getUserPath(userName);
			FileManager.createJSONFile(userPath, dataO);
		}
	}

}