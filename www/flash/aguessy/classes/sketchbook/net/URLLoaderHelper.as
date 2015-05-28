package sketchbook.net
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLVariables;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	
	/** 
	 * URLLoaderを簡略化したクラスです。
	 * <p>URLLoaderのイベントに対するコールバックハンドラや、URLRequestを介さず直接URLをコールするメソッドを提供します。</p> 
	 * <p>TODO: Flashのundocumentな使用か、onCompleteというハンドラがうまく動かない</p>
	 * @example <listing version="3.0">
	 * var loader:URLLoaderSB = new URLLoader()
	 * loader.onComplete=function(data:Object):void
	 * {
	 *   trace("loadCompleted")  
	 * }
	 * loader.loadURL("http://www.fladdict.net")</listing>
	 * 
	 * @see flash.net.URLLoader
	 *  * */
	public class URLLoaderHelper
	{
		/** Event.COMPLETEのコールバックハンドラ。 引数としてdata:Objectが渡されます。 */
		public var onComplete:Function 
		/** HTTPStatusEvent.HTTP_STATUSのコールバックハンドラ。引数としてstatusが渡されます。*/
		public var onHttpStatus:Function 
		/** IOErrorEvent.IOErrorのコールバックハンドラ。*/
		public var onIOError:Function 
		/** Event.OPENのコールバックハンドラ。 */
		public var onOpen:Function 
		/** ProgressEvent.PROGRESSのコールバックハンドラ。引数としてbytesLoaded, bytesTotalが渡されます。*/
		public var onProgress:Function = function():void{}
		public var onSecurityError:Function 
		
		/** URLRequestMethodの定数へのショートカット */
		public static const METHOD_POST:String = URLRequestMethod.POST
		/** URLRequestMethodの定数へのショートカット */
		public static const METHOD_GET:String = URLRequestMethod.GET
		
		/** URLLoaderDataの定数へのショートカット */
		public static const DATA_FORMAT_BINARY:String = URLLoaderDataFormat.BINARY
		/** URLLoaderDataの定数へのショートカット */
		public static const DATA_FORMAT_TEXT:String = URLLoaderDataFormat.TEXT
		/** URLLoaderDataの定数へのショートカット */
		public static const DATA_FORMAT_VARIABLES:String = URLLoaderDataFormat.VARIABLES
		
		private var _target:URLLoader
		
		/** 
		 * 対象のURLLoaderに対する簡易イベントハンドラー等を提供するヘルパー。
		 */
		public function URLLoaderHelper(urlLoader:URLLoader)
		{
			target = urlLoader
		}
		
		/** 操作対象のURLLoader */
		public function set target(urlLoader:URLLoader):void
		{
			if(urlLoader==_target) return
			if(_target!=null){
				_target.removeEventListener(Event.COMPLETE, _complete)
				_target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatus)
				_target.removeEventListener(IOErrorEvent.IO_ERROR, _ioError)
				_target.removeEventListener(ProgressEvent.PROGRESS, _progress)
				_target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError)
			}
			
			_target = urlLoader
			
			if(_target!=null){
				_target.addEventListener(Event.COMPLETE, _complete,false,0,true)
				_target.addEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatus, false, 0, true)
				_target.addEventListener(IOErrorEvent.IO_ERROR, _ioError, false,0,true)
				_target.addEventListener(ProgressEvent.PROGRESS, _progress, false, 0, true)
				_target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityError, false, 0, true)
			}	
		}
		
		public function get target():URLLoader
		{
			return _target
		}
		
		
		/**
		 * URLLoader.loadのショートカット
		 * URLRequestだけでなく、StringでURLを指定してもリクエスト可能です。
		 * 
		 * @see flash.net.URLRequest#load()
		 */
		public function load(...rest):void
		{
			var req:URLRequest
			if(rest[0] is URLRequest )
				req = rest[0]
				
			if(rest[0] is String )
				req = new URLRequest(rest[0])
				
			_target.load(req)
		}
		
		
		/**
		 * URLRequestを介さずにURLをダイレクトに指定するロード方法します。 
		 *
		 * @example <listing version="3.0">
		 * var params:Object = {keyword:"test", sort:"asc"}
	     * var loader:URLLoaderSB = new URLLoader()
	     * loader.loadURL("http://www.fladdict.net",params,"POST")</listing>
	     * 
		 * @param url ロードするURL
		 * @param params サーバーに渡す引数を格納した無名オブジェクト
		 * @param method POST or GET
		 * @param headerParams ヘッダーとして送信する値を格納した無名オブジェクト
		 * 
		 * @see flash.net.URLRequest
		 * */
		public function loadURL(url:String, params:Object=null, method:String="GET", headerParams:Object=null):void
		{
			var req:URLRequest = new URLRequest(url)
			
			var val:URLVariables = new URLVariables()
			for(var prop:String in params)
				val[prop] = params[prop]
			req.data = val
			req.method = method
			
			var urlHeaders:Array = new Array()
			for(prop in headerParams)
				urlHeaders.push( new URLRequestHeader(prop,headerParams[prop]) )
			req.requestHeaders = urlHeaders
			
			_target.load(req)	
		}
		
		
		public function get data():*
		{
			_target.data
		}
		
		public function set dataFormat(dataFormat:String):void
		{
			_target.dataFormat = dataFormat
		}
		
		public function get dataFormat():String
		{
			return _target.dataFormat
		}
		
		
		
		private function _complete(e:Event):void
		{
			if(onComplete!=null)
				onComplete(_target.data)
		}
		
		private function _httpStatus(e:HTTPStatusEvent):void
		{
			if(onHttpStatus!=null)
				onHttpStatus(e.status)
		}
		
		private function _ioError(e:IOErrorEvent):void
		{
			if(onIOError!=null)
				onIOError()
		}
		
		private function _open(e:Event):void
		{
			if(onOpen!=null)
				onOpen()
		}
		
		private function _progress(e:ProgressEvent):void
		{
			if(onProgress!=null)
				onProgress(e.bytesLoaded, e.bytesLoaded)
		}
		
		private function _securityError(e:SecurityErrorEvent):void
		{
			if(onSecurityError!=null)
				onSecurityError()
		}
	}
}