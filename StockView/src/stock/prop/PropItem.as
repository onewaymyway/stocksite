package stock.prop 
{
	import laya.math.ValueTools;
	import laya.stock.consts.ParamTypes;
	import laya.ui.Box;
	import laya.ui.Label;
	import laya.ui.TextInput;
	
	/**
	 * ...
	 * @author ww
	 */
	public class PropItem extends Box 
	{
		
		public function PropItem() 
		{
			
		}
		public function initByType(type:String = "")
		{
			tType = type;
			createPropItem(type);
		}
		public var box:Box;
		public var label:Label;
		public var tInput:TextInput;
		public var tType:String;
		private function createPropItem(type:String):void
		{
			this.removeChildren();
			

			label = new Label();
			label.color = "#ff0000";
			label.pos(0, 0);
			
			
			tInput = new TextInput();
			tInput.skin = "comp/textinput.png";		
			tInput.pos(70, 0);
			tInput.width = 100;
			tInput.color = "#ffffff";
			
			this.addChild(label);
			this.addChild(tInput);
		}
		public var key:String;
		public function setLabel(txt:String):void
		{
			label.text = txt;
		}
		public function setValue(v:*):void
		{
			tInput.text = v;
		}
		public function getValue():*
		{
			if (tType == ParamTypes.NUMBER)
			{
				return ValueTools.mParseFloat(tInput.text);
			}
			return tInput.text;
		}
		public static function createByType(type:String=""):PropItem
		{
			var rst:PropItem;
			rst = new PropItem();
			rst.initByType(type);
			return rst;
		}
		
	}

}