package naja.model.data.loaders 
{
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
	import naja.model.data.FileFormat;
    
    /**
     * 
     * 
     * @example 
     * <listing version="3.0">
     * 
     * 
     * </listing>
     */
    public class MultiLoaderRequest extends EventDispatcher
    {
        public var index:int = 0;
        private var _id:String;
        private var _fileFormat:String;
        private var _cacheEnabled:Boolean;
        
        private var _loader:*;
        public var LOADER:*;
        
        private var _request:URLRequest = new URLRequest();
        private var _response:*;
        
        private var _bytesLoaded:int = 0;
        private var _bytesTotal:int = 0;
        private var _opened:Boolean = false;
        private var _completed:Boolean = false;
        
        /**
         * 新しい MultiLoaderRequest インスタンスを作成します。
         * 
         * @param url リクエストされる URL です。
         * @param id リクエストに付加する ID です。同一のローダー内で使用するリクエストは一意の ID にする必要があります。
         * @param fileFormat 読み込み対象のファイル形式です。指定が無い場合は読み込み時に拡張子から自動判別されます。
         * @param cacheEnabled 読み込み対象のデータをキャッシュするかの可否です。
         */
        public function MultiLoaderRequest(
            url:String = null, id:String = null,
            fileFormat:String = null, cacheEnabled:Boolean = true):void
        {
            this.url = url;
            this.id = id;
            this.fileFormat = fileFormat;
            this.cacheEnabled = cacheEnabled;
        }
        
        /**
         * 任意の POST データの MIME コンテンツタイプです。
         */
        public function get contentType():String
        {
            return request.contentType;
        }
        
        public function set contentType(value:String):void
        {
            request.contentType = value;
        }
        
        /**
         * URL リクエストで送信されるデータを含むオブジェクトです。
         */
        public function get data():Object
        {
            return request.data;
        }
        
        public function set data(value:Object):void
        {
            request.data = value;
        }
        
        /**
         * HTTP フォーム送信メソッドが GET または POST のどちらの操作であるかを制御します。
         */
        public function get method():String
        {
            return request.method;
        }
        
        public function set method(value:String):void
        {
            request.method = value;
        }
        
        /**
         * HTTP リクエストヘッダの配列が HTTP リクエストに追加されます。
         */
        public function get requestHeaders():Array
        {
            return request.requestHeaders;
        }
        
        public function set requestHeaders(value:Array):void
        {
            request.requestHeaders = value;
        }
        
        /**
         * リクエストされる URL です。
         */
        public function get url():String
        {
            return request.url;
        }
        
        public function set url(value:String):void
        {
            request.url = value;
        }
        
        /**
         * リクエストに付加する ID です。同一のローダー内で使用するリクエストは一意の ID にする必要があります。
         */
        public function get id():String
        {
            return _id;
        }
        
        public function set id(value:String):void
        {
            _id = value;
        }
        
        /**
         * 読み込み対象のファイル形式です。指定が無い場合は読み込み時に拡張子から自動判別されます。
         */
        public function get fileFormat():String
        {
            return _fileFormat;
        }
        
        public function set fileFormat(value:String):void
        {
            _fileFormat = value;
        }
        
        /**
         * 読み込み対象のデータをキャッシュするかの可否です。
         * 
         * @default true
         */
        public function get cacheEnabled():Boolean
        {
            return _cacheEnabled;
        }
        
        public function set cacheEnabled(value:Boolean):void
        {
            _cacheEnabled = value;
        }
        
        /**
         * @private
         */
        internal function get loader():*
        {
            return _loader;
        }
        
        /**
         * @private
         */
        internal function set loader(value:*):void
        {
            if (!(value is Loader || value is URLLoader || value == null))
            {
                throw new Error(
                    "loader オブジェクトには Loader クラス、もしくは URLLoader クラスのみ設定できます。"
                );
            }
            
            var eventDispatcher:EventDispatcher = getEventDispatcher(_loader);
            
            if (eventDispatcher != null)
            {
                eventDispatcher.removeEventListener(Event.OPEN, open);
                eventDispatcher.removeEventListener(ProgressEvent.PROGRESS, progress);
                eventDispatcher.removeEventListener(Event.COMPLETE, complete);
                
                eventDispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
                eventDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
                eventDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
                
                eventDispatcher.removeEventListener(Event.INIT, init);
            }
            
            eventDispatcher = getEventDispatcher(value);
            
            if (eventDispatcher != null)
            {
                eventDispatcher.addEventListener(Event.OPEN, open);
                eventDispatcher.addEventListener(ProgressEvent.PROGRESS, progress);
                eventDispatcher.addEventListener(Event.COMPLETE, complete);
                
                eventDispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
                eventDispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioError);
                eventDispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
                
                eventDispatcher.addEventListener(Event.INIT, init);
            }
            
            _loader = value;
        }
        
        /**
         * @private
         */
        internal function get request():URLRequest
        {
            return _request;
        }
        
        /**
         * @private
         */
        internal function get response():*
        {
            return _response;
        }
        
        /**
         * @private
         */
        internal function get bytesLoaded():int
        {
            return _bytesLoaded;
        }
        
        /**
         * @private
         */
        internal function get bytesTotal():int
        {
            return _bytesTotal;
        }
        
        /**
         * @private
         */
        internal function get opened():Boolean
        {
            return _opened;
        }
        
        /**
         * @private
         */
        internal function get completed():Boolean
        {
            return _completed;
        }
        
        /**
         * @private
         */
        internal function load():void
        {
            request.url = url;
            
            if (!cacheEnabled)
            {
                var uniqueKey:String = new Date().toString();
                var pettern:RegExp = /\ /;
                
                while (uniqueKey.search(pettern) != -1)
                {
                    uniqueKey = uniqueKey.replace(pettern, "");
                }
                
                var doNotCache:String = (url.search(/\?.*$/) != -1) ? "&" : "?";
                doNotCache += "noCache=" + uniqueKey + Math.random();
                
                request.url += doNotCache;
            }
            
            request.contentType = contentType;
            request.data = data;
            request.method = method;
            request.requestHeaders = requestHeaders;
            
            loader.load(request);
        }
        
        /**
         * @private
         */
        internal function unload():void
        {
            id = null;
            fileFormat = null;
            cacheEnabled = true;
            
            if (loader is Loader)
            {
				Loader(loader).unload();
            }
            LOADER = null;
            loader = null;
            
            _request = new URLRequest();
            _response = null;
            
            _bytesLoaded = 0;
            _bytesTotal = 0;
            _opened = false;
            _completed = false;
        }
        
        /**
         * @private
         */
        private function getEventDispatcher(loader:*):EventDispatcher
        {
            var eventDispatcher:EventDispatcher;
            
            if (loader is Loader)
            {
                eventDispatcher = Loader(loader).contentLoaderInfo;
            }
            else if (loader is URLLoader)
            {
                eventDispatcher = URLLoader(loader);
            }
            
            return eventDispatcher;
        }
        
        /**
         * @private
         */
        private function open(event:Event):void
        {
            _opened = true;
            
            dispatchEvent(event);
        }
        
        /**
         * @private
         */
        private function progress(event:ProgressEvent):void
        {
            _bytesLoaded = event.bytesLoaded;
            _bytesTotal = event.bytesTotal;
            
            dispatchEvent(event);
        }
        
        /**
         * @private
         */
        private function complete(event:Event):void
        {
            var response:*;
            
            if (loader is Loader)
            {
                response = Loader(loader).contentLoaderInfo.content;
            }
            else
            {
                response = URLLoader(loader).data;
                
                switch (fileFormat)
                {
                    case FileFormat.XML:
                    {
                        response = new XML(response);
                        break;
                    }
                    case FileFormat.TXT:
                    case FileFormat.BINARY:
                    case FileFormat.VARIABLES:
                    {
                        break;
                    }
                    default:
                    {
                        throw new Error("読み込み完了後のデータ作成に失敗しました。");
                    }
                }
            }
            
            _response = response;
            _completed = true;
            
            dispatchEvent(event);
        }
        
        /**
         * @private
         */
        private function httpStatus(event:HTTPStatusEvent):void
        {
            dispatchEvent(event);
        }
        
        /**
         * @private
         */
        private function ioError(event:IOErrorEvent):void
        {
            dispatchEvent(event);
        }
        
        /**
         * @private
         */
        private function securityError(event:SecurityErrorEvent):void
        {
            dispatchEvent(event);
        }
        
        /**
         * @private
         */
        private function init(event:Event):void
        {
            dispatchEvent(event);
        }
    }
}