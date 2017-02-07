package {
	import laya.net.Loader;
	import laya.utils.Handler;
	import view.TestView;
	
	public class LayaUISample {
		
		public function LayaUISample() {
			//初始化引擎
			Laya.init(600, 400);
			
			//加载引擎需要的资源
			Laya.loader.load([{url: "res/atlas/comp.json", type: Loader.ATLAS}], Handler.create(this, onLoaded));
		}
		
		private function onLoaded():void {
			//实例UI界面
			var testView:TestView = new TestView();
			Laya.stage.addChild(testView);
		}
	}
}