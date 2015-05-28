package of.app.required.loading 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import of.app.required.regexp.BasicRegExp;
	import naja.model.data.loadings.LoadedData;
	import naja.model.data.loadings.XLoader;
	import naja.model.data.loadings.XLoaderRequest;
	import of.app.required.formats.FileFormat;
	import of.app.required.zip.ZipEntry;
	import of.app.required.zip.ZipFile;
	import of.app.Root;
	
	public class LoadingsController 
	{
		static private var __instance:LoadingsController;
		//////////////////////////////////////////////////////// CTOR
		public function LoadingsController() 
		{
			__instance = this ;
		}
		public function init():LoadingsController 
		{ 
			return this ;
		}
///////////////////////////////////////////////////////////////////////////////// ADD REQUEST
		static public function treatRequest(xl:XLoader, request:XLoaderRequest):XLoaderRequest
		{
			var fileFormat:String = request.fileFormat ;
			if (fileFormat == null) {
				var levelPattern:RegExp = BasicRegExp.url_LEVELS_RE ;
				var paramPattern:RegExp = BasicRegExp.url_PARAMS_RE ;
				fileFormat = request.url ;
				while (fileFormat.search(levelPattern) != -1)
					fileFormat = fileFormat.replace(levelPattern, "") ;
				if (fileFormat.search(paramPattern) != -1) fileFormat = fileFormat.replace(paramPattern, "") ;
				fileFormat = String(fileFormat.match(BasicRegExp.url_EXTENSION_RE)[0]).toLowerCase() ;
			}
			switch (fileFormat)
			{
				case FileFormat.SWF:
				case FileFormat.PNG:
				case FileFormat.JPG:
				case FileFormat.JPEG:
				case FileFormat.BMP:
				case FileFormat.GIF:
					request.loader = new Loader() ;
				break ;
				case FileFormat.XML:
				case FileFormat.TXT:
					request.loader = new URLLoader() ;
				break ;
				case FileFormat.ZIP:
					request.loader = new URLLoader() ;
					URLLoader(request.loader).dataFormat = URLLoaderDataFormat.BINARY ;
				break ;
				case FileFormat.BINARY:
				case FileFormat.VARIABLES:
					request.loader = new URLLoader() ;
					URLLoader(request.loader).dataFormat = fileFormat ;
				break ;
				default:
					throw new ArgumentError("Unable to match FileFormat") ;
			}
			request.fileFormat = fileFormat ;
			return request ;
		}
///////////////////////////////////////////////////////////////////////////////// TREAT COMPLETE
		static public function treatComplete(req:XLoaderRequest, e:Event):*
		{
			var response:* ;
			var loader:* = req.loader ;
			if (loader is Loader) {
				response = Loader(loader).contentLoaderInfo.content ;
				switch (req.ext)
				{
					case FileFormat.FONTS :
						var c:Array = req.id.match(BasicRegExp.url_ID_FROM_URL_RE) ;
						var str:String = Boolean(c as Array)? c[0] : req.id ;
						var font:Class = Loader(loader).contentLoaderInfo.applicationDomain.getDefinition(str) as Class ;
						Font.registerFont(font) ;
						response = font ;
					break ;
					//case FileFormat.MP3 :
						//response =  ;
					//break ;
					case FileFormat.SWF :
						response = Sprite(response) ;
					break ;
					case FileFormat.IMG :
						response = Bitmap(response) ;
					break ;
					default :
						throw new Error("Unable to match FileFormat") ;
				}
			}
			else {
				response = URLLoader(loader).data ;
				switch (req.fileFormat)
				{
					case FileFormat.XML:
						response = new XML(response) ;
					break ;
					case FileFormat.ZIP:
						return zipAnswer(req, response, e) ;
					break ;
					case FileFormat.TXT:
					case FileFormat.BINARY:
					case FileFormat.VARIABLES:
					break ;
					default:
						throw new Error("Unable to match FileFormat") ;
				}
			}
			req.response = response ;
			req.completed = true ;
			req.dispatchEvent(e) ;
			return response ;
		}
///////////////////////////////////////////////////////////////////////////////// ZIP ANSWER
		static private function zipAnswer(req:XLoaderRequest, r:ByteArray,evt:Event):*
		{
			var z:ZipFile = new ZipFile(IDataInput(r as IDataInput)) ;
			req.response = z ;
			var resp:Object = {};
			var entries:Array = z.entries ;
			var l:int = entries.length ;
			resp.count = [] ;
			for (var i:int = 0 ; i < l ; i++ ) {
				var entry:ZipEntry = entries[i] ;
				if (entry.isDirectory())  resp.count.push(i) ;
				else 
				{
					var name:String = entry.name ;
					var ext:String = testUrl(name,name.indexOf("fonts") != -1)
					switch(ext) {
						case FileFormat.FONTS :
						case FileFormat.SWF :
						case FileFormat.IMG :
							zipAnswerTreat(req, name, ext, z, entry , resp, evt) ;
						break ;
						case FileFormat.XML :
							resp[name] = new XML(z.getInput(entry)) ; 
							LoadedData.insert(ext.toUpperCase(), name, resp[name]) ;
							resp.count.push(i) ;
						break ;
					}
				}
			}
			if (resp.count.length == l) {
				req.completed = true ;
				req.dispatchEvent(evt) ;
			}
			return z ;
		}
///////////////////////////////////////////////////////////////////////////////// ZIP ANSWER TREAT
		static private function zipAnswerTreat(req:XLoaderRequest, name:String, ext:String, z:ZipFile, entry:ZipEntry, resp:Object ,evt:Event):void
		{
			var s:String = name ;
			var answer:* ;
			var dataLoader:Loader = new Loader() ;
			var l:int = z.entries.length ;
			dataLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void { 
				e.target.removeEventListener(e.type, arguments.callee) ;
				switch(ext) {
					case  FileFormat.FONTS :
						var c:Array = name.match(BasicRegExp.url_ID_FROM_URL_RE) ;
						var str:String = Boolean(c as Array)? c[0] : name ;
						var font:Class = Loader(dataLoader).contentLoaderInfo.applicationDomain.getDefinition(str) as Class ;
						Font.registerFont(font) ;
						answer =  font ;
					break ;
					case  FileFormat.SWF :
						answer = e.currentTarget.content as Sprite ;
					break ;
					case  FileFormat.IMG :
						answer = e.currentTarget.content as Bitmap ;
					break ;
				}
				resp[name] = answer ;
				resp.count.push("NaN") ;
				LoadedData.insert(ext.toUpperCase(), name, answer) ;
				if (resp.count.length == l) {
					req.completed = true ;
					req.dispatchEvent(evt) ;
				}
			} )
			dataLoader.loadBytes(z.getInput(entry)) ;
		}
///////////////////////////////////////////////////////////////////////////////// fromXMLNode
		static public function fromXMLNode(node:XML):XLoaderRequest
		{
			var req:XLoaderRequest = new XLoaderRequest(node.@url.toXMLString(), node.@id.toXMLString(), null, true) ;
			req.ext = testUrl(req.url, Boolean(node.localName() == FileFormat.FONTS )) ;
			req.url = Root.user.parameters.fromRoot(req.ext, req.url) ;
			return req ;
		}
		static public function toXMLNode(...rest:Array):XML
		{
			var url:String = rest[0] ;
			var id:String = rest[1] ;
			var font:Boolean = rest[2] || false ;
			var s:String = testUrl(url, font) ;
			return XML("<" + s+ " id='" + id + "' url='" + url + "' />") ;
		}
///////////////////////////////////////////////////////////////////////////////// TEST URL
		static public function testUrl(url:String, font:Boolean):String
		{
			var quickReg:RegExp = BasicRegExp.ext_STRICT_RE ,
				imgReg:RegExp = BasicRegExp.ext_IMG_RE ,
				videoReg:RegExp = BasicRegExp.ext_VID_RE,
				textReg:RegExp = BasicRegExp.ext_TEXT_RE, 
				extXmlReg:RegExp = BasicRegExp.ext_EXTENDED_XML_RE ,
				xmlReg:RegExp = BasicRegExp.ext_XML_RE ,
				zipReg:RegExp = BasicRegExp.ext_ZIP_RE ;
			var s:String = url.match(quickReg)[0] ;
			if (!s) throw(new ArgumentError(url + " is not a correct url")) ;
			else if (font && s=="swf")  s = FileFormat.FONTS ;
			else if (s.search(imgReg) != -1) s = FileFormat.IMG ;
			else if (s.search(videoReg) != -1) s = FileFormat.VID ;
			else if (s.search(textReg) != -1) s  = FileFormat.TEXT ;
			else if (s.search(extXmlReg) != -1) s = FileFormat.EXTENDED_XML ;
			else if (s.search(zipReg) != -1) s = FileFormat.ZIP ;
			if (s.search(xmlReg) != -1) s = FileFormat.XML ;
			return s ;
		}
		///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function init():LoadingsController { return instance.init() }
		static public function get instance():LoadingsController{ return __instance || new LoadingsController() }
		static public function get hasInstance():Boolean { return  Boolean(__instance) }
	}
}