 package naja.tools.zip {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	
	public class ZipLoader extends URLLoader {
		
		private static var ZIP_CACHE:Dictionary = new Dictionary();
		
		public static function clearCache():void 
		{
			ZIP_CACHE = null;
			ZIP_CACHE = new Dictionary();
		}
		/**
		 * zip?????URL???????
		 */
		private static const ZIP_FILE_REG:RegExp = /.*?\.zip$/;
		/**
		 * zip?????????????????
		 */
		private static const ZIP_ENTRY_REG:RegExp = /(.*?\.zip):\/\/(.*$)/;
		/**
		 * ??????Zip?????URL
		 */
		private var _zipUrl:String;
		/**
		 * ?????Zip???????????????????URL?
		 * Zip?????????/?????
		 */
		private var _entryUrl:String;
		
		private var _entryDataFormat:String;
		
		private var isCompleteProcessRequired:Boolean = false;
		/**
		 * zip?????????????????????????????????ZipLoader??????????
		 */
		public function ZipLoader() {
			super();
			this.addEventListener(Event.COMPLETE , zipFileLoadCompleted , false , int.MAX_VALUE);
			this._zipUrl = null;
			this._entryUrl = null;
		}

		/**
		 * @see flash.net.URLLoader
		 * @param	req
		 */
		public override function load(req:URLRequest):void {
			var url:String = req.url;
			this.isCompleteProcessRequired = false;
			switch (true) {
				case ZIP_ENTRY_REG.test(url)://zip????????????
					var result:Object = ZIP_ENTRY_REG.exec(url);
					this._zipUrl = result[1];//TODO Zip???????URL
					this._entryUrl = result[2];//TODO Zip?????
					var zip:ZipFile = ZIP_CACHE[this._zipUrl] as ZipFile;
					if ( zip ) {
						//??????Zip?????
						this.dataFromZip(zip);
						dispatchEvent(new Event(Event.COMPLETE));
					} else {
						//????????????????
						this.isCompleteProcessRequired = true;
						this.load(new URLRequest(zipUrl));
					}
					break;
				case ZIP_FILE_REG.test(url)://zip??????????????????
					this.isCompleteProcessRequired = true;
					this._zipUrl = url;
					this._entryDataFormat = this.dataFormat;
					this.dataFormat = URLLoaderDataFormat.BINARY;
					super.load(req);
					break;
				default://?(?????????)
					super.load(req);
					break;
			}
		}
		
		/**
		 * zip???????????????????????????
		 * ????ZipFile????????????????????
		 * @param	e
		 */
		private function zipFileLoadCompleted(e:Event):void {
			if (this.isCompleteProcessRequired) {
				//Zip????????????????ZipEntry????????????????
				var zipfile:ZipFile = new ZipFile(e.target.data);
				//zip?????????????
				ZIP_CACHE[this._zipUrl] = zipfile;
				this.dataFromZip(zipfile);
				this.dataFormat = this._entryDataFormat;
				if (!this.data) {
					//???????????????this.dataFromZip?IOErrorEvent??????????????
					//Event.COMPLETE?????
					e.stopImmediatePropagation();
				}
			}
		}
		
		/**
		 * zip?????????????????????????????
		 * @param	zip			zip????
		 */
		private function dataFromZip(zip:ZipFile):void 
		{
			if ( zip && this.entryUrl) {
				this.data = this.getZipEntry(zip, this.entryUrl);
			}
		}
		
		private function getZipEntry(zip:ZipFile, entryUrl:String):ByteArray
		{
			if (ZIP_ENTRY_REG.test(entryUrl)) {
				//zip??????zip???????????(foo.zip://bar.txt??)
				var result:Object = ZIP_ENTRY_REG.exec(entryUrl);
				var outerEntry:String = result[1];
				var innerEntry:String = result[2];
				var innerZip:ZipFile = new ZipFile(zip.getInput(zip.getEntry(outerEntry)));
				return this.getZipEntry(innerZip, innerEntry);
			} else {
				//zip????????????????byteArray?????
				var entry:ZipEntry = zip.getEntry(entryUrl);
				if (entry) {
					return zip.getInput(entry);
				} else {
					dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
					return null;
				}
			}
		}
		public function get zipUrl():String { return _zipUrl; }
		public function get entryUrl():String { return _entryUrl; }
	}
}