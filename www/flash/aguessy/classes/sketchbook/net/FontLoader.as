package sketchbook.net
{
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.text.Font;
	import flash.events.ProgressEvent;
	
	/**
	 * 外部swfに埋め込まれたフォントをロードするクラス。
	 * 外部swfにはFontをライブラリに追加クラス名をつける。
	 * 
	 * var fld : FontLoader = new FontLoader();
	 * fld.addEventListener( Event.Complete );
	 * fld.loadFont( new URLRequest(myFont.swf);, "myFontClassName" );
	 * 
	 * trace(fld.font);
	 */
	public class FontLoader extends EventDispatcher
	{
		public var onLoad : Function
		public var onProgress:Function	//引数に bytesLoaded と bytesTotalが渡ります
		public var onIOError:Function
		
		protected var _font : Font
		protected var _loader : Loader
		protected var _fontClassName : String
		
		
		
		public function FontLoader():void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onComplete, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onProgress, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onIOError, false, 0, true);
		}
		
		/**
		 * フォントを格納したswfをロードする
		 * 
		 * @param req ロードするswfのURLRequest
		 * @param fontClassName swfにエンベッドされたフォントのクラスの名。
		*/
		public function loadFont(req:URLRequest, fontClassName:String):void
		{
			_fontClassName = fontClassName;
			_loader.load(req);
		}
		
		/**
		 * ロードしたフォントをインスタンスとして取得する
		 */
		public function get font():Font
		{
			return _font;
		}
		
		protected function _onComplete( e:Event ) : void
		{
			var embeddedFontClass:Class = _loader.contentLoaderInfo.applicationDomain.getDefinition(_fontClassName) as Class;
			Font.registerFont(embeddedFontClass);
			_font = new embeddedFontClass();
			
			if( onLoad != null )
				onLoad();
			
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		protected function _onProgress( e:ProgressEvent ) : void
		{
			if(onProgress!=null)
				onProgress(e.bytesLoaded, e.bytesTotal);
			dispatchEvent( e );
		}
		
		protected function _onIOError( e:IOErrorEvent ) : void
		{
			if(onIOError!=null)
				onIOError();
				
			dispatchEvent( e );
		}
	}
}