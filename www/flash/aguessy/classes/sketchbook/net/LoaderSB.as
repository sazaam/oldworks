package sketchbook.net
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	/**
	 * MovieClipや画像の読み込みを簡略化する為の関数を追加したLoaderクラス
	 * 
	 */
	public class LoaderSB extends Loader
	{
		//ロード完了後にonLoadが呼ばれる
		public var onLoad:Function
		public var onProgress:Function	//引数に bytesLoaded と bytesTotalが渡ります
		public var onIOError:Function
		
		public function LoaderSB():void
		{
			super();
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoad, false, 0, true);
			this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onProgress, false, 0, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onIOError, false, 0, true);
		}
		
		/** swfをURLでロードする */
		public function loadURL(url:String, context:LoaderContext=null):void
		{
			var req:URLRequest = new URLRequest(url);
			super.load(req, context)
		}
		
		
		/** loadしたSWF内のシンボルを取得する */
		public function getDefinition(className:String):Class
		{
			var app:ApplicationDomain = this.contentLoaderInfo.applicationDomain
			return Class(app.getDefinition(className));
		}
		
		private function _onLoad(e:Event):void
		{
			if(onLoad!=null)
				onLoad();
		}
		
		private function _onIOError(e:IOErrorEvent):void
		{
			if(onIOError!=null)
				onIOError();
		}
		
		private function _onProgress(e:ProgressEvent):void
		{
			if(onProgress!=null)
				onProgress(e.bytesLoaded, e.bytesTotal);
		}
	}
}