package laya.stock.analysers 
{
	import laya.debug.tools.ClassTool;
	import laya.math.DataUtils;
	import laya.math.GraphicUtils;
	import laya.math.ValueTools;
	import laya.stock.consts.ParamTypes;
	import laya.utils.Utils;
	import stock.StockData;
	/**
	 * ...
	 * @author ww
	 */
	public class AnalyserBase 
	{
		
		public function AnalyserBase() 
		{
			initParamKeys();
			initParamDes();
		}
		public function initParamKeys():void
		{
			paramkeys = [];
		}
		public var stockData:StockData;
		public var dataList:Array;
		public var disDataList:Array;
		public var resultData:Object;
		public var paramkeys:Array;
		public var paramDes:Array = [];
		public var forSelect:Boolean = false;
		private function initParamDes():void
		{
			paramDes.length = 0;
			var i:int, len:int;
			var tKey:String;
			var tValue:*;
			len = paramkeys.length;
			for (i = 0; i < len; i++)
			{
				tKey = paramkeys[i];
				tValue = this[tKey];
				//debugger;
				if (tValue is String)
				{
					paramDes.push([tKey,ParamTypes.STRING]);
				}else
				{
					paramDes.push([tKey,ParamTypes.NUMBER]);
				}
			}
		}
		
		public function getParam():Object
		{
			var rst:Object;
			rst = { };
			if (paramkeys)
			{
				var i:int, len:int;
				len = paramkeys.length;
				var tKey:String;
				for (i = 0; i < len; i++)
				{
					tKey = paramkeys[i];
					rst[tKey] = this[tKey];
				}
			}
			return rst;
		}
		public function getParamsArr():Array
		{
			return [ClassTool.getClassName(this),getParam()];
		}
		public function setByParam(params:Object):void
		{
			if (paramkeys)
			{
				var i:int, len:int;
				len = paramkeys.length;
				var tKey:String;
				for (i = 0; i < len; i++)
				{
					tKey = paramkeys[i];
					if (params[tKey])
					{
						this[tKey]=params[tKey] ;
					}		
				}
			}
		}
		
		public function showIndexs():void
		{
			var i:int, len:int;
			len = disDataList.length;
			var indexs:Array;
			indexs = [];
			for (i = 0; i < len; i++)
			{
				indexs.push([i + "",i]);
			}
			resultData["indexs"] = indexs;
		}
		
		public function analyser(stockData:StockData,start:int = 0, end:int = -1,forSelect:Boolean=false):void
		{
			this.forSelect = forSelect;
			this.stockData = stockData;
			dataList = stockData.dataList;
			analyserData(start,end);
		}
		public function initByStrData(data:String):void
		{
			var stockData:StockData;
			stockData = new StockData();
			stockData.init(data);
			analyser(stockData);			
		}
		public function analyserData(start:int = 0, end:int = -1):void
		{
			if (end < start) end = dataList.length;
			disDataList = dataList.slice(start, end);
			resultData = { };
			analyseWork();
		}
		public function getDataByI(i:int):Object
		{
			return disDataList[i];
		}
		public function analyseWork():void
		{

		}
		public function getDrawCmds():Array
		{
			return null;
		}
		
		public function addToConfigTypes(types:Array):void
		{
			
		}
		
		public function addToShowData(showData:Object):void
		{
			
		}
		
		public function addGridLine(barHeight:Number,gridLineValue:String):void
		{
			var i:int, len:int;
			var gridLine:Array;
			gridLine = [];
			var values:Array;
			values = gridLineValue.split(",");
			len = values.length;
			for (i = 0; i < len; i++) {
				values[i] = ValueTools.mParseFloat(values[i]) * barHeight;
			}
			gridLine.push(0, disDataList.length - 1, values, color, gridLineValue.split(","));
			resultData["gridLine"] = gridLine;
		}
		
		public function addGridLineToDraw(rst:Array):void
		{
			rst.push(["drawGridLineEx", resultData["gridLine"]]);
		}
	}

}