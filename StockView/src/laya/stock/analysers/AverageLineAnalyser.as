package laya.stock.analysers 
{
	import laya.stock.analysers.lines.AverageLine;
	import laya.stock.StockTools;
	
	/**
	 * ...
	 * @author ww
	 */
	public class AverageLineAnalyser extends AverageLine 
	{
		
		public function AverageLineAnalyser() 
		{
			super();
			days = "5,12,26";
			colors = "#ff0000,#00ffff,#ffff00";
		}
		
		override public function addToConfigTypes(types:Array):void 
		{
			var mTpl:String;
			mTpl = "{#code#}:{#rate#}%:{#day#}:{#mRate#}\n{#lastBuy#}:{#changePercent#}%\n{#high7#}%,{#high15#}%,{#high30#}%,{#high45#}%";
			var mTip:String;
			mTip="股票:当前变化率:趋势持续天数:平均变化率\n最后购买时间:当前盈利\n7天最大盈利,15天最大盈利,30天最大盈利,45天最大盈利";
			var tData:Object;
			var tAnalyserInfos:Array;
			tData = {};
			tData.label = "AvgByRate";
			tData.sortParams = ["averageO.rate", true, true];
			tData.dataKey = "averageO";
			tAnalyserInfos = [];
			tAnalyserInfos.push(this.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			
			tData.tip = mTip;
			tData.tpl =mTpl;
			types.push(tData);
			
			tData = {};
			tData.label = "AvgByDay";
			tData.sortParams = ["averageO.day", true, true];
			tData.dataKey = "averageO";
			tAnalyserInfos = [];
			tAnalyserInfos.push(this.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			
			tData.tip = mTip;
			tData.tpl = mTpl;
			types.push(tData);
			
			tData = {};
			tData.label = "AvgByMRate";
			tData.sortParams = ["averageO.mRate", true, true];
			tData.dataKey = "averageO";
			tAnalyserInfos = [];
			tAnalyserInfos.push(this.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			
			tData.tip = mTip;
			tData.tpl = mTpl;
			types.push(tData);
			
			tData = {};
			tData.label = "AvgByBuy";
			tData.sortParams = ["averageO.lastBuy", true, false];
			tData.dataKey = "averageO";
			tAnalyserInfos = [];
			tAnalyserInfos.push(this.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			
			tData.tip = mTip;
			tData.tpl = mTpl;
			types.push(tData);
			
		}
		
		
		override public function addToShowData(showData:Object):void {
			var kLineO:Object;
			kLineO = {};
			
			kLineO.code = showData.code;
			kLineO.day = 0;
			kLineO.rate = 0;
			kLineO.last
			
			var avgs:Array;
			avgs = resultData["averages"];
			var i:int, len:int;
			len = avgs.length;
			var upCount:int = 0;
			var tI:int;
			tI = disDataList.length - 1;
			while (tI >= 0)
			{
				if (isUpTrend(avgs, tI))
				{
					tI--;
					upCount++;
				}else
				{
					break;
				}
			}
			kLineO.day = upCount;
			if (tI < 0) tI = 0;
			if (upCount > 0)
			{
				kLineO.lastBuy = disDataList[tI]["date"];
				var prePrice:Number;
				var tPrice:Number;
				var tIndex:int;
				var lastIndex:int = tI;
				tIndex = disDataList.length - 1;
				prePrice = StockTools.getStockPriceEx(lastIndex, "close", this);
				tPrice = StockTools.getStockPriceEx(tIndex, "close", this);
				kLineO.rate = StockTools.getGoodPercent((tPrice-prePrice) / prePrice);
				kLineO.mRate = StockTools.getGoodPercent((tPrice-prePrice) / (prePrice * upCount));
				kLineO.lastBuy = disDataList[lastIndex]["date"];
				StockTools.getBuyStaticInfos(lastIndex, disDataList, kLineO);
			}
			showData["averageO"] = kLineO;
			
		}
		
		private function isUpTrend(avgs:Array,index:int):void
		{
			var i:int, len:int;
			len = avgs.length;
			var preLine:Array;
			var tLine:Array;
			for (i = 1; i < len; i++)
			{
				preLine = avgs[i - 1][0][index];
				tLine = avgs[i][0][index];
				if (tLine[1] > preLine[1])
				{
					return false;
				}
			}
			return true;
		}
	}

}