package laya.stock.analysers.staticinfo 
{
	import laya.math.DataUtils;
	import laya.stock.analysers.AnalyserBase;
	import laya.stock.StockTools;
	
	/**
	 * ...
	 * @author ww
	 */
	public class PositionStatic extends AnalyserBase 
	{
		
		public function PositionStatic() 
		{
			super();
			
		}
		
		override public function analyseWork():void 
		{
			
		}
		
		override public function addToConfigTypes(types:Array):void 
		{
			var tData:Object;
			var tAnalyserInfos:Array;
			var sign:String;
			sign = "PositionAll";
			tData = {};
			tData.label = "expAll";
			tData.sortParams = [sign+".exp", true, true];
			tData.dataKey = sign;
			tData.tpl = "{#code#}:exp:{#exp#}\nwin:{#win#}\nlose{#lose#}";
			//tAnalyserInfos = [];
			//tAnalyserInfos.push(this.getParamsArr());
			//tData.analyserInfo = tAnalyserInfos;
			tData.tip = "全历史期望模型";
			types.push(tData);
			
			tData = {};
			tData.label = "winAll";
			tData.sortParams = [sign+".win", true, true];
			tData.dataKey = sign;
			tData.tpl = "{#code#}:exp:{#exp#}\nwin:{#win#}\nlose{#lose#}";
			//tAnalyserInfos = [];
			//tAnalyserInfos.push(this.getParamsArr());
			//tData.analyserInfo = tAnalyserInfos;
			tData.tip = "全历史期望模型";
			types.push(tData);
			
		}
		
		override public function addToShowData(showData:Object):void 
		{
			var min:Number;
			var max:Number;
			min = DataUtils.getKeyMin(disDataList, "close");
			max = DataUtils.getKeyMax(disDataList, "close");
			var tValue:Number;
			tValue = disDataList[disDataList.length - 1]["close"];
			var loseRate:Number;
			loseRate = (min - tValue) / tValue;
			var winRate:Number;
			winRate = (max - tValue) / tValue;
			var exp:Number;
			exp = winRate + 2 * loseRate;
			
			var sign:String;
			sign = "PositionAll";
			var expO:Object = {};
			showData[sign] = expO;
			expO.code = showData.code;
			expO.lose = StockTools.getGoodPercent(loseRate);
			expO.win = StockTools.getGoodPercent(winRate);
			expO.exp = StockTools.getGoodPercent(exp);
		}
	}

}