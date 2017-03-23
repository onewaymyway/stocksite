package stock.prop 
{
	import laya.events.Event;
	import laya.ui.Box;
	import laya.ui.Label;
	import laya.ui.Panel;
	import laya.ui.TextInput;
	import ui.prop.PropPanelUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class PropPanel extends PropPanelUI 
	{
		public static const MakeChange:String = "MakeChange";
		public function PropPanel() 
		{
			super();
			//propBox = new Box();
			//addChild(propBox);
			okBtn.on(Event.MOUSE_DOWN, this, onOk);
		}
		private function onOk():void
		{
			if (!tPropO || !tPropItems) return;
			var i:int, len:int;
			len = tPropItems.length;
			var tPropItem:PropItem;
			var key:String;
			var tValue:*;
			for (i = 0; i < len; i++)
			{
				tPropItem = tPropItems[i];
				key = tPropItem.key;
				tPropO[key] = tPropItem.getValue();
			}
			event(MakeChange);
		}
		public var propBox:Box;
		public var tPropO:Object;
		public function initByData(propDes:Array, propO:Object):void
		{
			if (tPropO == propO)
			{
				return;
			} 
			tPropO = propO;
			tPropDes = propDes;
			createBox(propDes);
			initValue(propO);
		}
		public function refresh():void
		{
			if (tPropO)
			{
				initValue(tPropO);
			}
		}
		public function initValue(propO:Object):void
		{
			if (!tPropDes) return;
			var i:int, len:int;
			len = tPropItems.length;
			var tPropItem:PropItem;
			var key:String;
			for (i = 0; i < len; i++)
			{
				tPropItem = tPropItems[i];
				key = tPropItem.key;
				if (propO.hasOwnProperty(key))
				{
					tPropItem.setValue(propO[key]);
				}else
				{
					tPropItem.setValue("");
				}
			}
		}
		private var tPropDes:Array;
		private var tPropItems:Array=[];
		private function createBox(propDes:Array):void
		{
			tPropItems.length = 0;
			propBox.removeChildren();
			var i:int, len:int;
			len = propDes.length;
			var tItem:PropItem;
			var tPropO:Object;
			for (i = 0; i < len; i++)
			{
				tPropO = propDes[i];
				tItem = PropItem.createByType(tPropO[1]);
				tItem.setLabel(tPropO[0]);
				tItem.key = tPropO[0];
				propBox.addChild(tItem);
				tItem.pos(0, i * 30);
				tPropItems.push(tItem);
			}
			
		}
		
	}

}