package naja.model.data.loaders 
{
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.utils.Dictionary;
	import naja.model.data.FileFormat;
    
    /**
     * ロード操作が開始したときに送出されます。
     */
    [Event(name="open", type="Event.OPEN")]
    
    /**
     * ダウンロード処理を実行中にデータを受信したときに送出されます。
     */
    [Event(name="progress", type="ProgressEvent.PROGRESS")]
    
    /**
     * データが正常にロードされたときに送出されます。
     */
    [Event(name="complete", type="Event.COMPLETE")]
    
    /**
     * 
     * 
     * @example 
     * <listing version="3.0">
     * 
     * 
     * </listing>
     */
    public class MultiLoader extends EventDispatcher
    {
        private var _requests:Dictionary = new Dictionary();
        private var requests:Array = [] ;
        private var _waitAllOpened:Boolean = true;
        
        /**
         * 新しい MultiLoader インスタンスを作成します。
         */
        public function MultiLoader():void
        {
            
        }
        
        /**
         * 登録されているリクエストに対応するデータが全て読み込み開始になるのを待ってからイベントを発行するか否かです。<br>
         * true に設定することにより、progress イベント発行時に loadedTotal が一定値を保ちます。
         * 
         * @default true
         */
        public function get waitAllOpened():Boolean
        {
            return _waitAllOpened;
        }
        
        public function set waitAllOpened(value:Boolean):void
        {
            _waitAllOpened = value;
        }
        
        /**
         * 対象のリクエストを登録します。
         * 
         * @param request 登録対象のリクエストです。
         * 
         * @return 登録されたリクエストです。
         * 
         * @throws ArgumentError 重複するリクエストを追加した場合。
         * @throws ArgumentError リクエストに URL が存在しない場合。
         */
        public function addRequest(request:MultiLoaderRequest):MultiLoaderRequest
        {
            for each (var e:MultiLoaderRequest in _requests)
            {
                if (e == request)
                {
                    throw new ArgumentError(
                        "リクエストの追加には重複しないリクエストインスタンスを指定する必要があります。"
                    );
                }
            }
            
            if (request.url == null || request.url == "")
            {
                throw new ArgumentError("リクエストに URL が存在しません。");
            }
            
            var fileFormat:String = request.fileFormat;
            
            if (fileFormat == null)
            {
                var levelPattern:RegExp = /\.\.?\//;
                var paramPattern:RegExp = /\?.*$/;
                
                fileFormat = request.url;
                
                while (fileFormat.search(levelPattern) != -1)
                {
                    fileFormat = fileFormat.replace(levelPattern, "");
                }
                
                if (fileFormat.search(paramPattern) != -1)
                {
                    fileFormat = fileFormat.replace(paramPattern, "");
                }
                
                fileFormat = String(fileFormat.match(/\.[^.]+$/)[0]).substr(1).toLowerCase();
            }
            
            switch (fileFormat)
            {
                case FileFormat.SWF:
                case FileFormat.PNG:
                case FileFormat.JPG:
                case FileFormat.JPEG:
                case FileFormat.GIF:
                {
                    request.loader = new Loader();
                    request.LOADER = request.loader ;
                    break;
                }
                case FileFormat.XML:
                case FileFormat.TXT:
                {
                    request.loader = new URLLoader();
					request.LOADER = request.loader ;
                    break;
                }
                case FileFormat.BINARY:
                case FileFormat.VARIABLES:
                {
                    request.loader = new URLLoader();
                    URLLoader(request.loader).dataFormat = fileFormat;
					request.LOADER = request.loader ;
                    break;
                }
                default:
                {
                    throw new ArgumentError("対応していないファイル形式です。");
                }
            }
            
            request.fileFormat = fileFormat;
            
            _requests[request] = request;
            requests.push(request);
            return request;
        }
        
        /**
         * URL を元にリクエストを登録します。
         * 
         * @param url リクエストされる URL です。
         * @param id リクエストに付加する ID です。同一のローダー内で使用するリクエストは一意の ID にする必要があります。
         * @param fileFormat 読み込み対象のファイル形式です。指定が無い場合は読み込み時に拡張子から自動判別されます。
         * @param cacheEnabled 読み込み対象のデータをキャッシュするかの可否です。
         * 
         * @return URL を元に登録されたリクエストです。
         */
        public function addRequestByUrl(
            url:String, id:String = null,
            fileFormat:String = null, chacheEnabled:Boolean = true):MultiLoaderRequest
        {
            return addRequest(new MultiLoaderRequest(url, id, fileFormat, chacheEnabled));
        }
        
        /**
         * 対象の登録されているリクエストを解除します。
         * 
         * @param request 解除対象のリクエストです。
         * 
         * @return 解除されたリクエストです。
         * 
         * @throws ArgumentError 削除対象のリクエストが登録されていない場合。
         */
        public function removeRequest(request:MultiLoaderRequest):MultiLoaderRequest
        {
            if (_requests[request] != null)
            {
                removeEventListenerFrom(request);
                request.unload();
                delete requests[requests.indexOf(request)] ;
                delete _requests[request];
            }
            else
            {
                throw new ArgumentError("削除対象のリクエストが登録されていません。");
            }
            
            return request;
        }
        
        /**
         * ID を元に登録されているリクエストを解除します。
         * 
         * @param id 解除対象のリクエストの ID です。
         * 
         * @return 解除されたリクエストです。
         * 
         * @throws ArgumentError 削除対象のリクエストが登録されていない場合。
         */
        public function removeRequestById(id:String):MultiLoaderRequest
        {
            var removedRequest:MultiLoaderRequest;
            
            for each (var request:MultiLoaderRequest in _requests)
            {
                if (id == request.id)
                {
                    removeRequest(request);
                    removedRequest = request;
                    break;
                }
            }
            
            if (removedRequest == null)
            {
                throw new ArgumentError("削除対象のリクエストが登録されていません。");
            }
            
            return request;
        }
        
        /**
         * URL を元に登録されているリクエストを解除します。
         * 
         * @param url 解除対象の URL です。
         * 
         * @return 解除されたリクエストを含む配列です。
         */
        public function removeRequestsByUrl(url:String):Array
        {
            var requestes:Array = [];
            
            for each (var request:MultiLoaderRequest in _requests)
            {
                if (url == request.url)
                {
                    removeRequest(request);
                    requestes.push(request);
                }
            }
            
            return requestes;
        }
        
        /**
         * 登録されているリクエストを全て解除します。
         * 
         * @return 解除されたリクエストを含む配列です。
         */
        public function removeAllRequests():Array
        {
            var requests:Array = [];
            
            for each (var request:MultiLoaderRequest in _requests)
            {
                removeRequest(request);
                requests.push(request);
            }
            
            return requests;
        }
        
        /**
         * 読み込みが完了したリクエストに対応するレスポンスデータを取得します。
         * 
         * @param request レスポンスデータに対応するリクエストです。
         * 
         * @return リクエストに対応するレスポンスデータです。
         * 
         * @throws ArgumentError リクエストに対応するレスポンスデータが存在しない場合。
         */
        public function getResponse(request:MultiLoaderRequest):*
        {
            for each (var request:MultiLoaderRequest in _requests)
            {
                if (request.response != null)
                {
                    return request.response;
                }
            }
            
            throw new ArgumentError("リクエストに対応するデータが存在しません。");
        }
        
        /**
         * 読み込みが完了した ID に対応するレスポンスデータを取得します。
         * 
         * @param request レスポンスデータに対応する ID です。
         * 
         * @return ID に対応するレスポンスデータです。
         * 
         * @throws ArgumentError ID に対応するレスポンスデータが存在しない場合。
         */
        public function getResponseById(id:String):*
        {
            for each (var request:MultiLoaderRequest in _requests)
            {
                if (id == request.id)
                {
                    if (request.response != null)
                    {
                        return request.response;
                    }
                }
            }
            
            throw new ArgumentError("ID に対応するデータが存在しません。");
        }
        
        /**
         * 読み込みが完了したレスポンスデータを配列形式で全て取得します。
         * 
         * @return 読み込みが完了した全てのレスポンスデータです。
         */
        public function getAllResponses():Array
        {
            var responses:Array = [];
            
            for each (var request:MultiLoaderRequest in _requests)
            {
                if (request.response != null)
                {
                    responses.push(request.response);
                }
            }
            
            return responses;
        }
        
        /**
         * 登録されているリクエストの読み込みを開始します。
         */
        public function load():void
        {
            for each (var request:MultiLoaderRequest in _requests)
            {
                addEventListenerTo(request);
                request.load();
            }
        }
        
        /**
         * @private
         */
        private function addEventListenerTo(request:MultiLoaderRequest):void
        {
            request.addEventListener(Event.OPEN, open);
            request.addEventListener(ProgressEvent.PROGRESS, progress);
            request.addEventListener(Event.COMPLETE, complete);
        }
        
        /**
         * @private
         */
        private function removeEventListenerFrom(request:MultiLoaderRequest):void
        {
            request.removeEventListener(Event.OPEN, open);
            request.removeEventListener(ProgressEvent.PROGRESS, progress);
            request.removeEventListener(Event.COMPLETE, complete);
        }
        
        /**
         * @private
         */
        private function open(event:Event):void
        {
            var allOpened:Boolean = true;
            
            for each (var request:MultiLoaderRequest in _requests)
            {
                if (!waitAllOpened)
                {
					//trace("SA MERE")
                    request.removeEventListener(Event.OPEN, open);
                }
                
                if (!request.opened)
                {
                    allOpened = false;
                }
            }
            
            if (allOpened || !waitAllOpened)
            {
                dispatchEvent(new Event(Event.OPEN));
            }
        }
        
        /**
         * @private
         */
        private function progress(event:ProgressEvent):void
        {
            var allOpened:Boolean = true;
            
            var bytesLoaded:int = 0;
            var bytesTotal:int = 0;
            
            for each (var request:MultiLoaderRequest in _requests)
            {
                if (!request.opened)
                {
                    allOpened = false;
                    break;
                }
                
                bytesLoaded += request.bytesLoaded;
                bytesTotal += request.bytesTotal;
            }
            
            if (allOpened || !waitAllOpened)
            {
                dispatchEvent(new ProgressEvent(
                    ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal
                ));
            }
        }
        
        /**
         * @private
         */
        private function complete(event:Event):void
        {
            removeEventListenerFrom(MultiLoaderRequest(event.target));
            
            var allCompleted:Boolean = true;
            
            var bytesLoaded:int = 0;
            var bytesTotal:int = 0;
            var response:Array = [];
            
            for each (var request:MultiLoaderRequest in _requests)
            {
                if (!request.completed)
                {
                    allCompleted = false;
                    break;
                }
                
                bytesLoaded += request.bytesLoaded;
                bytesTotal += request.bytesTotal;
                response.push(request.response);
            }
            
            if (allCompleted)
            {
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }
    }
}