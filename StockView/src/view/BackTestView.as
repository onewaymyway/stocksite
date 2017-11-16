package view 
{
	import laya.debug.tools.JSTools;
	import laya.debug.tools.Notice;
	import laya.events.Event;
	import laya.math.ArrayMethods;
	import laya.math.ValueTools;
	import laya.stock.StockTools;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import msgs.MsgConst;
	import ui.BackTestViewUI;
	import wrap.FileSelect;
	/**
	 * ...
	 * @author ww
	 */
	public class BackTestView extends BackTestViewUI
	{
		private var fileSelect:FileSelect;
		public function BackTestView() 
		{
			fileSelect = new FileSelect(selectFileBtn, "*", new Handler(this, onChange));
			list.renderHandler = new Handler(this, stockRender);
			list.array = [];
			list.mouseHandler = new Handler(this, onMouseList);
			list.scrollBar.touchScrollEnable = true;
			tip.text = "回测文件显示";
		}
		
		public var tI:int = 0;
		private var preTime:Number = 0;
		
		public function onMouseList(e:Event, index:int):void {
			
			if (e.type == Event.MOUSE_UP) {
				var tTime:Number = Browser.now();
				if (tTime - preTime > 500)
				{
					preTime = tTime;
					return;
				}
					
				preTime = tTime;
				var tData:Object;
				tData = list.array[index];
				tI = index;
				if (!tData)
					return;
				trace(tData);
				StockListManager.setStockList(list.array, tI);
				Notice.notify(MsgConst.Show_Stock_KLine, [tData.code,tData]);
			}
		}
		//{
            //"stock":"603330",
            //"sellRate":-0.0381834613646633,
            //"sell":29,
            //"date":"2017-09-22",
            //"buyPrice":44.26
        //}
		public static var tpl:String = "{#code#}\n{#date#}\n{#sell#}:{#winRate#}";
		public function stockRender(cell:Box, index:int):void {
			var item:Object = cell.dataSource;
			var label:Label;
			label = cell.getChildByName("label");
			var dataO:Object;
			dataO = item;
			dataO.winRate = StockTools.getGoodPercent(dataO.sellRate);
			label.text = ValueTools.getTplStr(tpl, dataO);
			
			label = cell.getChildByName("info");
			label.text = "";
		}
		private function onChange(e:*):void
		{
			trace("change:", e);
			var input:Object;
			input = e.target;
			var file:Object;
			file = input.files[0];
			if (file)
			{
				trace("selectFile:", file.name);
				

				JSTools.getTxtFromFile(file, Handler.create(this, onFileLoaded));
			}
			else
			{
				trace("nofileSelect");

			}
		
			
		}
		private function onFileLoaded(txt:String):void
		{
			var dataO:Object;
			dataO = JSON.parse(txt);
			trace("selectJson:", dataO);
			if (dataO&&dataO.list)
			{
				list.array = dataO.list;
				var tList:Array;
				tList = dataO.list;
				if (dataO.tpl)
				{
					tpl = dataO.tpl;
				}
				var tInfoO:Object;
				tInfoO = { };
				tInfoO.count = tList.length;
				tInfoO.avgRate = ArrayMethods.sumKey(tList, "sellRate") / tInfoO.count;
				tInfoO.avgRatePercent = StockTools.getGoodPercent(ArrayMethods.sumKey(tList, "sellRate") / tInfoO.count) + "%";
				tInfoO.avgDay = 1 + Math.floor(ArrayMethods.sumKey(tList, "sell") / tInfoO.count);
				tInfoO.winTime = ArrayMethods.count(tList, "sellRate", bigThenZero);
				tInfoO.winRate = StockTools.getGoodPercent(tInfoO.winTime / tInfoO.count) + "%";
				tInfoO.yearRate =  StockTools.getGoodPercent((tInfoO.avgRate / tInfoO.avgDay) * 240)+"%";
				tip.text=ValueTools.getTplStr("购买次数:{#count#},胜率:{#winRate#}\n平均盈利:{#avgRatePercent#},{#avgDay#}Day\nYearRate:{#yearRate#}", tInfoO);
			}
		}
		public static function bigThenZero(v:Number):Boolean
		{
			return v > 0;
		}
	}

}