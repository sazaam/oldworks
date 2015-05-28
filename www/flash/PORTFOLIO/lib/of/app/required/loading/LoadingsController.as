package of.app.required.loading 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.text.Font;
	import of.app.Root;
	
	import of.app.required.regexp.BasicRegExp;
	import of.app.required.formats.FileFormat;
	import of.app.XParams;
	
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
			//trace(fileFormat)
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
					throw new Error("ZipFile not enabled", LoadingsController) ;
					//request.loader = new URLLoader() ;
					//URLLoader(request.loader).dataFormat = URLLoaderDataFormat.BINARY ;
				break ;
				case FileFormat.BINARY:
				case FileFormat.VARIABLES:
					request.loader = new URLLoader() ;
					URLLoader(request.loader).dataFormat = fileFormat ;
				break ;
				default:
					throw new ArgumentError("Unable to match FileFormat >>", LoadingsController) ;
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
						if (req.id == 'classes') LoadedData.insert('SWF','externals', response.loaderInfo.applicationDomain) ;
					break ;
					case FileFormat.IMG :
						response = Bitmap(response) ;
					break ;
					default :
						throw new Error("Unable to match FileFormat >>", LoadingsController) ;
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
						throw new Error("ZipFile not enabled", LoadingsController) ;
						//return zipAnswer(req, response, e) ;
					break ;
					case FileFormat.TXT:
					case FileFormat.BINARY:
					case FileFormat.VARIABLES:
					break ;
					default:
						throw new Error("Unable to match FileFormat >>", LoadingsController) ;
				}
			}
			req.response = response ;
			req.completed = true ;
			req.dispatchEvent(e) ;
			return response ;
		}
///////////////////////////////////////////////////////////////////////////////// fromXMLNode
		static public function fromXMLNode(node:XML):XLoaderRequest
		{
			var req:XLoaderRequest = new XLoaderRequest(node.@url.toXMLString(), node.@id.toXMLString(), null, true) ;
			req.ext = testUrl(req.url, Boolean(node.localName() == FileFormat.FONTS )) ;
			req.url = req.url.indexOf('http://') != -1 ? req.url : XParams.instance.fromRoot(req.ext, req.url) ;
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
				//trace(url)
			if (!Boolean(url.match(quickReg) as Array)) return FileFormat.SWF ;
			var s:String = url.match(quickReg)[0] ;
			if (!s) throw(new ArgumentError(url + " is not a correct url >>", LoadingsController )) ;
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