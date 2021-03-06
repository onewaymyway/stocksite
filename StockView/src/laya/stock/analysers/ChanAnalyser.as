package laya.stock.analysers {
	import laya.math.DataUtils;
	import laya.stock.analysers.chan.ChanKBar;
	import laya.stock.analysers.chan.ChanKList;
	import laya.stock.analysers.chan.ChanTrend;
	import laya.stock.StockTools;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ChanAnalyser extends AnalyserBase {
		
		public function ChanAnalyser() {
			super();
		
		}
		public var ifShowIndex:int = 0;
		public var showRaw:int = 0;
		public var onlyBuy:int = 0;
		
		override public function initParamKeys():void {
			paramkeys = ["ifShowIndex", "showRaw", "onlyBuy"];
		}
		
		override public function analyseWork():void {
			myCalculate();
		}
		
		public function getMegerLines(chanList:ChanKList):void {
			var cPointList:Array;
			cPointList = chanList.kList;
			var i:int, len:int;
			len = cPointList.length;
			var tops:Array;
			var bottoms:Array;
			tops = [];
			bottoms = [];
			var tDataO:ChanKBar;
			for (i = 0; i < len; i++) {
				tDataO = cPointList[i];
				tops.push(ChanKList.getIndex(tDataO.topO));
				bottoms.push(ChanKList.getIndex(tDataO.bottomO));
				
			}
			resultData["tops"] = tops;
			resultData["bottoms"] = bottoms;
		}
		
		public function myCalculate():void {
			
			if (ifShowIndex)
				showIndexs();
			var cPointList:Array;
			cPointList = [];
			var chanList:ChanKList;
			chanList = new ChanKList();
			
			chanList.setDataList(disDataList);
			
			if (showRaw) {
				getMegerLines(chanList);
				return;
			}
			else {
				
			}
			
			cPointList = chanList.findTopBottoms();
			var i:int, len:int;
			len = cPointList.length;
			var tops:Array;
			var bottoms:Array;
			tops = [];
			bottoms = [];
			var tType:String;
			var tArr:Array;
			var tDataO:ChanKBar;
			
			var points:Array;
			points = [];
			var preData:ChanKBar;
			
			var tIndex:int;
			
			var pointWithPriceList:Array;
			pointWithPriceList = [];
			for (i = 0; i < len; i++) {
				tArr = cPointList[i];
				tType = tArr[0];
				tDataO = tArr[1];
				if (tType != DataUtils.K_Unknow) {
					if (tType == DataUtils.K_Top) {
						tIndex = ChanKList.getIndex(tDataO.topO);
						tops.push(tIndex);
						pointWithPriceList.push([tIndex,"high",StockTools.getStockPriceEx(tIndex,"high",this)]);
						if (preData) {
							points.push([tIndex, "high", " " + StockTools.getGoodPercent((tDataO.top - preData.bottom) / preData.bottom) + "%"]);
						}
						else {
							points.push([tIndex, "high"]);
						}
						
					}
					if (tType == DataUtils.K_Bottom) {
						tIndex = ChanKList.getIndex(tDataO.bottomO);
						bottoms.push(tIndex);
						pointWithPriceList.push([tIndex,"low",StockTools.getStockPriceEx(tIndex,"low",this)]);
						if (preData) {
							points.push([tIndex, "low", " " + StockTools.getGoodPercent((tDataO.bottom - preData.top) / preData.top) + "%"]);
						}
						else {
							points.push([tIndex, "low"]);
						}
						
					}
					preData = tDataO;
				}
			}
			
			var chanTrend:ChanTrend;
			chanTrend = new ChanTrend();
			chanTrend.initByData(pointWithPriceList);
			resultData["tops"] = tops;
			resultData["bottoms"] = bottoms;
			resultData["points"] = points;
			resultData["types"] = chanTrend.typeList;
			resultData["buys"] = chanTrend.buyList;
		}
		
		override public function addToConfigTypes(types:Array):void {
			
			var mTpl:String;
			mTpl = "{#code#}:{#rate#}%:{#day#}:{#mRate#}\n{#lastBuy#}:{#changePercent#}%\n{#high7#}%,{#high15#}%,{#high30#}%,{#high45#}%";
			var mTip:String;
			mTip="股票:当前变化率:趋势持续天数:平均变化率\n最后购买时间:当前盈利\n7天最大盈利,15天最大盈利,30天最大盈利,45天最大盈利";
			var tData:Object;
			var tAnalyserInfos:Array;
			tData = {};
			tData.label = "TrendByRate";
			tData.sortParams = ["TrendO.rate", true, true];
			tData.dataKey = "TrendO";
			tAnalyserInfos = [];
			tAnalyserInfos.push(this.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			
			tData.tip = mTip;
			tData.tpl =mTpl;
			types.push(tData);
			
			tData = {};
			tData.label = "TrendByDay";
			tData.sortParams = ["TrendO.day", true, true];
			tData.dataKey = "TrendO";
			tAnalyserInfos = [];
			tAnalyserInfos.push(this.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			
			tData.tip = mTip;
			tData.tpl = mTpl;
			types.push(tData);
			
			tData = {};
			tData.label = "TrendByMRate";
			tData.sortParams = ["TrendO.mRate", true, true];
			tData.dataKey = "TrendO";
			tAnalyserInfos = [];
			tAnalyserInfos.push(this.getParamsArr());
			tData.analyserInfo = tAnalyserInfos;
			
			tData.tip = mTip;
			tData.tpl = mTpl;
			types.push(tData);
			
			tData = {};
			tData.label = "TrendByBuy";
			tData.sortParams = ["TrendO.lastBuy", true, false];
			tData.dataKey = "TrendO";
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
			kLineO.rate = 1;
			
			var points:Array;
			points = resultData["points"];
			
			if (points && points.length) {
				showData.TrendO = kLineO;
				var lastData:Array;
				lastData = points[points.length - 1];
				var lastIndex:int;
				lastIndex = lastData[0];
				var lastType:String;
				lastType = lastData[1];
				var prePrice:Number;
				var tPrice:Number;
				var tIndex:int;
				tIndex = disDataList.length - 1;
				prePrice = StockTools.getStockPriceEx(lastIndex, lastType, this);
				tPrice = StockTools.getStockPriceEx(tIndex, "close", this);
				kLineO.day = tIndex-lastIndex+1;
				kLineO.rate = StockTools.getGoodPercent((tPrice-prePrice) / prePrice);
				kLineO.mRate = StockTools.getGoodPercent((tPrice-prePrice) / (prePrice * kLineO.day));
				var buys:Array;
				buys = resultData["buys"];
				kLineO.lastBuy = "0000";
				if (buys&&buys.length>0)
				{
					kLineO.lastBuy = dataList[buys[buys.length - 1][1]]["date"];
					StockTools.getBuyStaticInfos(buys[buys.length - 1][1], disDataList, kLineO);
				}
				
			}
		
		}
		
		override public function getDrawCmds():Array {
			var rst:Array;
			rst = [];
			
			//rst.push(["drawPoints", [resultData["bottoms"], "low", 3, "#ffff00"]]);
			//rst.push(["drawPoints", [resultData["tops"], "high", 3, "#00ff00"]]);
			if(!onlyBuy)
			rst.push(["drawPointsLineEx", [resultData["points"]]]);
			if (ifShowIndex)
				rst.push(["drawTexts", [resultData["indexs"], "low", 30, "#00ff00", true, "#00ff00"]]);
			//rst.push(["drawTexts", [resultData["types"], "low", 30, "#ffff00", true, "#ffff00"]]);
			rst.push(["drawTexts", [resultData["buys"], "low", 50, "#ff0000", true, "#ff0000"]]);
			//rst.push(["drawPointsLine", [resultData["maxs"], "high", -20]]);
			//rst.push(["drawPointsLine", [resultData["mins"], "low", 20]]);
			
			return rst;
		}
	}

}