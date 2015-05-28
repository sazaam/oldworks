package of.app 
{
	import flash.display.LoaderInfo;
	import of.app.required.regexp.BasicRegExp;
	import tools.net.stringToObj;
	/**
	 * ...
	 * @author saz
	 */
	public class XParams
	{
		// REQUIRED
		static private var __instance:XParams ;
		//////////////////////////////////////// CTOR
		private var __params:Object =  {
			root:"../../www/" ,
			conf:"__conf__/config.xml",
			html:"html/",
			xml:"xml/",
			swf:"swf/",
			fonts:"swf/fonts/",
			img:"img/", 
			flv:"flv/",
			stage:{
				align:"TL",
				scaleMode:"noScale",
				frameRate:30
			}
		};
		//////////////////////////////////////// CTOR
		public function XParams()
		{
			__instance = this ;
		}
		public function init(info:LoaderInfo, parameters:Object = null, __external:Boolean = false):XParams
		{
			if (parameters) __params = parameters ;
			if (__external) {
				var local:Object = { }, net:Object = info.parameters ;
				for (var i:String in net) {
					__params[i] = net[i] ;
					if (i == 'stage') __params[i] = stringToObj(net[i]) ;
				}
			}
			trace(this, 'inited') ;
			return this ;
		}
		//////////////////////////////////////// RETRIEVE FROM LOADERINFO
		static public function init(info:LoaderInfo, parameters:Object = null):XParams { return instance.init(info, parameters) }
		
		
		//////////////////////////////////////// URL PATH ISSUES
		public function fromPath(...rest:Array):String
		{
			var l:int = rest.length ;
			var s:String = "", p:String = "";
			for (var i:int = 0 ; i < l ; i++ ) {
				var str:String = rest[i] ;
				if (!Boolean(str)) throw new ArgumentError("An error occurred...should check that every param of rest array is a String >>", this) ;
				if (Boolean(__params[str])) p = String(__params[str]) ;
				else if (str.match(BasicRegExp.url_VARIABLE_PATH_MULTI) is Array) p = toPath(str)
				else p = str ;
				if(p.indexOf(".") == -1) checkSlash(p) ;
				s += p ;
			}
			return s ;
		}
		private function checkSlash(s:String):String
		{
			if (s.search(BasicRegExp.url_IS_FOLDER_SLASHED) == -1) s += "/" ;
			return s
		}
		public function fromRoot(...rest:Array):String
		{
			return __params.root + fromPath.apply(null,[].concat(rest)) ;
		}
		public function toPath(str:String):String
		{
			return str.replace(BasicRegExp.url_VARIABLE_PATH_MULTI, function():String{ return __pathes[arguments[1]] }) ;
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get hasInstance():Boolean { return Boolean(__instance as XParams) }
		static public function get instance():XParams { return hasInstance? __instance :  new XParams() }
		static public function get params():Object { return __instance.__params }
		
		public function get params():Object { return __params }
	}
}