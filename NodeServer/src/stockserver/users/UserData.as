package stockserver.users 
{
	/**
	 * ...
	 * @author ww
	 */
	public class UserData 
	{
		
		public function UserData() 
		{
			
		}
		public var userName:String;
		public var isLogined:Boolean = false;
		public function login(userName:String, pwd:String):void
		{
			this.userName = userName;
			isLogined = UserSystem.I.login(userName, pwd);
		}
	}

}