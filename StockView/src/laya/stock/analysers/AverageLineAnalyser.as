package laya.stock.analysers {
	import laya.math.DataUtils;
	import laya.stock.analysers.lines.AverageLine;
	import laya.stock.StockTools;
	
	/**
	 * ...
	 * @author ww
	 */
	public class AverageLineAnalyser extends AverageLine {
		public var showBuy:int = 0;
		public var showTrend:int = 1;
		public var color:String = "#ffff00";
		public function AverageLineAnalyser() {
			super();
			days = "5,12,26";
			colors = "#ff0000,#00ffff,#ffff00";
		}
		
		override public function initParamKeys():void {
			paramkeys = ["days", "colors", "priceType", "showBuy", "showTrend"];
		}
		
		override public function addToConfigTypes(types:Array):void {
			var mTpl:String;
			mTpl = "{#code#}:{#rate#}%:{#day#}:{#mRate#}\n{#lastBuy#}:{#changePercent#}%\n{#high7#}%,{#high15#}%,{#high30#}%,{#high45#}%";
			var mTip:String;
			mTip = "股票:当前变化率:趋势持续天数:平均变化率\n最后购买时间:当前盈利\n7天最大盈利,15天最大盈利,30天最大盈利,45天最大盈利";
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
			tData.tpl = mTpl;
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
		
		override public function doAverages():void {
			super.doAverages();
			var buyPoints:Array;
			buyPoints = [];
			var avgs:Array;
			avgs = resultData["averages"];
			var i:int, len:int;
			len = disDataList.length;
			var upCount:int = 0;
			var tI:int;
			var preIsUp:Boolean;
			preIsUp = false;
			tI = disDataList.length - 1;
			var curIsUp:Boolean;
			for (i = 1; i < len; i++) {
				curIsUp = isUpTrend(avgs, i);
				if ((!preIsUp) && curIsUp) {
					buyPoints.push(["buy:" + disDataList[i]["date"], i]);
				}
				preIsUp = curIsUp;
			}
			
			resultData["buys"] = buyPoints;
			
			if (showTrend > 0) {
				len = disDataList.length;
				var distanceList:Array;
				distanceList = [];
				for (i = 0; i < len; i++) {
					distanceList.push([i, barHeight * getAvgDistance(avgs, i),_colorDic[getTrendType(avgs,i)]]);
				}
				resultData["distanceList"] = distanceList;
				addGridLine(barHeight, "0,0.025,0.05,0.1,0.15,0.20,0.25",color);
			}
		
		}
		private static var _colorDic:Object = {"-1":"#00ff00","0":"#00ffff","1":"#ff0000" };
		public var barHeight:Number = 500;
		private static var _tempArr:Array = [];
		
		private function getAvgDistance(avgs:Array, index:int):Number {
			_tempArr.length = avgs.length;
			var i:int, len:int;
			len = _tempArr.length;
			for (i = 0; i < len; i++) {
				_tempArr[i] = avgs[i][0][index][1];
			}
			return DataUtils.getDistanceRate(_tempArr);
		}
		
		override public function getDrawCmds():Array {
			var rst:Array;
			rst = super.getDrawCmds();
			if (showBuy > 0)
				rst.push(["drawTexts", [resultData["buys"], "low", 30, "#00ff00", true, "#00ff00"]]);
			if (showTrend > 0) {
				rst.push(["drawLinesEx", [resultData["distanceList"]]]);
				
				addGridLineToDraw(rst);
			}
			
			return rst;
		}
		
		override public function addToShowData(showData:Object):void {
			var kLineO:Object;
			kLineO = {};
			
			kLineO.code = showData.code;
			kLineO.day = 0;
			kLineO.rate = 0;
			kLineO.last = ""
			
			var avgs:Array;
			avgs = resultData["averages"];
			var i:int, len:int;
			len = avgs.length;
			var upCount:int = 0;
			var tI:int;
			tI = disDataList.length - 1;
			while (tI >= 0) {
				if (isUpTrend(avgs, tI)) {
					tI--;
					upCount++;
				}
				else {
					break;
				}
			}
			
			len = avgs.length;
			var curAvgs:Array;
			curAvgs = [];
			var lastIndex:int;
			lastIndex = disDataList.length - 1;
			for (i = 0; i < len; i++) {
				curAvgs.push(avgs[i][0][lastIndex][1]);
			}
			kLineO.avgs = curAvgs;
			
			kLineO.day = upCount;
			if (tI < 0)
				tI = 0;
			if (upCount > 0) {
				kLineO.lastBuy = disDataList[tI]["date"];
				var prePrice:Number;
				var tPrice:Number;
				var tIndex:int;
				//var lastIndex:int = tI;
				tIndex = disDataList.length - 1;
				prePrice = StockTools.getStockPriceEx(lastIndex, "close", this);
				tPrice = StockTools.getStockPriceEx(tIndex, "close", this);
				kLineO.rate = StockTools.getGoodPercent((tPrice - prePrice) / prePrice);
				kLineO.mRate = StockTools.getGoodPercent((tPrice - prePrice) / (prePrice * upCount));
				kLineO.lastBuy = disDataList[lastIndex]["date"];
				StockTools.getBuyStaticInfos(lastIndex, disDataList, kLineO);
				
			}
			showData["averageO"] = kLineO;
		
		}
		
		private function isUpTrend(avgs:Array, index:int):Boolean {
			var i:int, len:int;
			len = avgs.length;
			var preLine:Array;
			var tLine:Array;
			for (i = 1; i < len; i++) {
				preLine = avgs[i - 1][0][index];
				tLine = avgs[i][0][index];
				if (tLine[1] > preLine[1]) {
					return false;
				}
			}
			return true;
		}
		
		private function getTrendType(avgs:Array, index:int):int {
			var i:int, len:int;
			len = avgs.length;
			var preLine:Array;
			var tLine:Array;
			var flg:Boolean;
			
			//是否多头形态
			flg = true;
			for (i = 1; i < len; i++) {
				preLine = avgs[i - 1][0][index];
				tLine = avgs[i][0][index];
				if (tLine[1] > preLine[1]) {
					flg = false;
					break;
				}
			}
			if (flg)
				return 1;
			
			//是否空头形态
			flg = true;
			for (i = 1; i < len; i++) {
				preLine = avgs[i - 1][0][index];
				tLine = avgs[i][0][index];
				if (tLine[1] < preLine[1]) {
					flg = false;
					break;
				}
			}
			if (flg)
				return -1;
			return 0;
		}
	}

}