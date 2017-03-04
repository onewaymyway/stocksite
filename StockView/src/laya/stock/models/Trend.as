package laya.stock.models {
	
	/**
	 * ...
	 * @author ww
	 */
	public class Trend {
		
		public function Trend() {
			upList = new UpList();
			downList = new DownList();
		}
		public var isDown:Boolean = true;
		public var upList:UpList;
		public var downList:DownList;
		public var sign:String = "low";
		
		public var preData:Object;
		
		public function addData(data:Object):void {
			if (isDown) {
				if (downList.add(data)) {
					upList.reset();
				}
				else {
					if (downList.getLen() > 0) {
						if (upList.getLen() == 0) {
							upList.add(preData);
							upList.add(data);
						}
						else {
							upList.add(data);
						}
					}
					
				}
			}
			preData = data;
		
		}
		
		public function clear():void {
			preData = null;
			downList.reset();
			upList.reset();
		}
	
	}

}