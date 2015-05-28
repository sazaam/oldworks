package of.app 
{
	import of.app.required.loading.AribitraryBasicLoaderGraphics;
	import of.app.required.loading.DefaultLoaderGraphics;
	import of.app.required.loading.I.ILoaderGraphics;
	import of.app.required.steps.VirtualSteps ;
	import pro.Unique;
	
	/**
	 * ...
	 * @author saz
	 */
	public class XCustom
	{
		// REQUIRED
		private static var __instance:XCustom ;
		//////////////////////////////////////// PARAMETERS
		private var __defaultParams:Object ;
		static public const DEFAULT_PARAMS:Object = {
			root:"../" ,
			//conf:"../json/default_output.json" ,
			//conf:"http://127.0.0.1:8000/datas/" ,
			//conf:"../xml/default_output.xml" ,
			conf:"__conf__/config.xml" ,
			html:"html/",
			xml:"xml/",
			fonts:"swf/fonts/",
			swf:"swf/",
			img:"img/", 
			flv:"flv/",
			stage:{
				align:"TL",
				scaleMode:"noScale",
				frameRate:30
			}
		} ;
		//////////////////////////////////////// SCHEMES
		private var __schemes:Object ;
		//////////////////////////////////////// VARS
		private var __unique:XUnique ;
		private var __graphics:ILoaderGraphics ;
		
		//////////////////////////////////////// CTOR
		public function XCustom()
		{
			__instance = this ;
			gen() ;
		}
		
		private function gen():void
		{
			generateParams(DEFAULT_PARAMS) ;
			generateRequired(XUnique) ;
		}
		
		protected function generateRequired(...params):void
		{
			var cUnique:Class = params[0] ;
			var cGraphics:Class = params[1] || AribitraryBasicLoaderGraphics ;
			__unique = new cUnique() ;
			__graphics = new cGraphics() ;
		}
		
		protected function generateParams(_def_par:Object):void
		{
			__defaultParams = _def_par ;
		}
		//////////////////////////////////////// INIT
		public function init():XCustom
		{
			trace(this, ' inited...') ;
			return this ;
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get defaultParams():Object { return __instance.default_params }
		static public function get unique():XUnique { return __unique }
		static public function init(...rest:Array):XCustom { return instance.init.apply(instance, [].concat(rest)) }
		static public function get hasInstance():Boolean { return Boolean(__instance as XCustom) }
		static public function get instance():XCustom { return hasInstance? __instance :  new XCustom() }
		
		public function get defaultParams():Object { return __defaultParams }
		public function set defaultParams(value:Object):void { __defaultParams = value }
		public function get unique():XUnique { return __unique }
		public function get graphics():ILoaderGraphics { return __graphics }
	}
}