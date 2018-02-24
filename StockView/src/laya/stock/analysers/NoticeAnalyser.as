package laya.stock.analysers 
{
	import laya.math.structs.ListDic;
	import laya.stock.StockNoticeManager;
	import stock.StockNoticeData;
	/**
	 * ...
	 * @author ww
	 */
	public class NoticeAnalyser extends AnalyserBase
	{
		public var noticeData:StockNoticeData;
		public var showAll:int = 0;
		public function NoticeAnalyser() 
		{
			
		}
		
		override public function initParamKeys():void 
		{
			paramkeys = ["showAll"]
		}
		override public function analyseWork():void 
		{
			noticeAnalyse();
		}
		
		private function noticeAnalyse():void
		{
			var tStockName:String;
			tStockName = stockData.stockName;
			
			noticeData = StockNoticeManager.I.getStockNotice(tStockName);
			if (!noticeData)
			{
				StockNoticeManager.I.loadStockNotice(tStockName);
				return;
			}
			
			var dataList:ListDic;
			dataList = noticeData.noticeData;
			var i:int, len:int;
			len = disDataList.length;
			var tData:Object;
			var tDate:String;
			var tNoticeList:Array;
			var noticeList:Array;
			var noticeInfoList:Array;
			noticeList = [];
			noticeInfoList = [];
			for (i = 0; i < len; i++)
			{
				tData = disDataList[i];
				tDate = tData["date"];
				tNoticeList = dataList.getData(tDate);
				if (tNoticeList)
				{
					noticeList.push([i, tNoticeList]);
					addNotices(noticeInfoList, i, tNoticeList);
					//noticeInfoList.push([tNoticeList[0]["title"],i]);
				}
			}
			resultData["noticeList"] = noticeList;
			resultData["noticeInfoList"] = noticeInfoList;
		}
		private static var showKeyWords:Array = ["增", "减","融资","核准", "重大事项","重要","合同","中标","重大资产","上市流通","补助","重组","股东","达成","冻结","季报","年报","质押","业绩","出售","非公开发行","终止","完成","关联交易","获得","拍卖","业务","解禁","员工持股","担保","股权激励","聘","重组","投资","辞职","收购", "激励", "分红", "合作", "购买", "转让","募资"];
		private static var noShowKeyWords:Array = ["异常波动","回复","意见","说明"];
		public function isShowTitle(title:String):Boolean
		{
			if (showAll > 0) return true;
			//return true;
			var i:int, len:int;
			
			len = noShowKeyWords.length;
			for (i = 0; i < len; i++)
			{
				if (title.indexOf(noShowKeyWords[i]) >= 0) return false;
			}
			len = showKeyWords.length;
			for (i = 0; i < len; i++)
			{
				if (title.indexOf(showKeyWords[i]) >= 0) return true;
			}
			return false;
		}
		private function addNotices(infoList:Array, index:int, noticeList:Array):void
		{
			var i:int, len:int;
			len = noticeList.length;
			var tNotice:Object;
			var tTitle:String;
			var tCount:int;
			tCount = 0;
			for (i = 0; i < len; i++)
			{
				tNotice = noticeList[i];
				tTitle = tNotice["title"];
				
				if (isShowTitle(tTitle))
				{
					if (tTitle.indexOf("：") >= 0)
					{
						tTitle = tTitle.split("：")[1];
					}
					infoList.push([tTitle,index,tCount*20]);
					tCount++;
				}
				
			}
		}
		override public function getDrawCmds():Array 
		{
			var rst:Array;
			rst = [];
			
			if(resultData["noticeInfoList"])
			rst.push(["drawTexts", [resultData["noticeInfoList"], "low", 50, "#ff0000", true, "#ff0000",true]]);
			//rst.push(["drawPointsLine", [resultData["maxs"], "high", -20]]);
			//rst.push(["drawPointsLine", [resultData["mins"], "low", 20]]);
			
			return rst;
		}
	}

}