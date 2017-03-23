package view.plugins 
{
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.Notice;
	import laya.events.Event;
	import laya.stock.analysers.AnalyserBase;
	import laya.ui.Box;
	import laya.ui.CheckBox;
	import laya.ui.Label;
	import laya.utils.Handler;
	import msgs.MsgConst;
	import ui.plugins.AnalyserListUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class AnalyserList extends AnalyserListUI 
	{
		
		public function AnalyserList() 
		{
			list.renderHandler = new Handler(this, mRender);
			list.array = [];
			list.scrollBar.autoHide = true;
		}
		private var dataList:Array;
		public function initAnalysers(analyserList:Array):void
		{
			dataList = [];
			var i:int, len:int;
			len = analyserList.length;
			var tData:Object;
			var tAnalyserClass:Class;
			
			for (i = 0; i < len; i++)
			{
				tAnalyserClass = analyserList[i];
				tData = { };
				tData.name = ClassTool.getClassName(tAnalyserClass);
				tData.Analyser = new tAnalyserClass();
				tData.enabled = false;
				dataList.push(tData);
			}
			list.array = dataList;
		}
		public function refreshList():void
		{
			if (list && list.array)
			{
				list.refresh();
			}
		}
		public function getAnalyserByName(analyserName:String):Object
		{
			var i:int, len:int;
			len = dataList.length;
			var tData:Object;
			for (i = 0; i < len; i++)
			{
				tData = dataList[i];
				if (tData.name == analyserName)
				{
					return tData;
				}
			}
			return null;
		}
		public function setAnalyserParams(analyserName:String, paramO:Object):void
		{
			var analyserO:Object;
			analyserO = getAnalyserByName(analyserName);
			if (!analyserO) return;
			var tAnalyser:AnalyserBase;
			tAnalyser = analyserO["Analyser"];
			if (!tAnalyser) return;
			tAnalyser.setByParam(paramO);
			refreshList();
		}
		private var checkHandler:Handler;
		public function mRender(cell:Box, index:int):void {
			var item:Object = cell.dataSource;
			var label:Label;
			label = cell.getChildByName("nameTxt");
			var check:CheckBox;
			check = cell.getChildByName("ifShow");
			label.text = item.name;
			check.selected = item.enabled;
			cell.off(Event.CLICK, this, onAnalyserDoubleDown);
			cell.on(Event.CLICK, this, onAnalyserDoubleDown,[item]);
			//check["tar"] = item;
			check.clickHandler = new Handler(this, onCheckChange,[check,item]);
		}
		private function onAnalyserDoubleDown(item:Object):void
		{
			var tAnalyser:AnalyserBase;
			tAnalyser = item.Analyser;
			trace("tAnalyser", tAnalyser);
			Notice.notify(MsgConst.Show_Analyser_Prop, [tAnalyser.paramDes,tAnalyser]);
		}
		private function onCheckChange(check:CheckBox,item:Object):void
		{
			item.enabled = check.selected;
			noticeSelectAnalyses();
		}
		private function noticeSelectAnalyses():void
		{
			var  analyserList:Array;
			analyserList = [];
			var i:int, len:int;
			len = dataList.length;
			var tData:Object;
			for (i = 0; i < len; i++)
			{
				tData = dataList[i];
				if (tData.enabled)
				{
					analyserList.push(tData.Analyser);
				}
			}
			Notice.notify(MsgConst.AnalyserListChange, [analyserList]);
		}
	}

}