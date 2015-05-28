package of.app 
{

	import flash.display.Loader;
	import flash.display.Sprite;

	/**
	 * ...
	 * @author saz-ornorm
	 */
	public class XUser
	{
		// REQUIRED
		static private var __instance:XUser ;
		//////////////////////////////////////// VARS
		private var __target:Sprite ;
		private var __root:Root ;
		private var __custom:XCustom ;
		private var __controller:XControl ;
		private var __console:XConsole ;
		private var __parameters:XParams;
		private var __factory:XFactor ;
		private var __data:XData ;
		private var __userData:Object ;
		
		
		//////////////////////////////////////// CTOR
		public function XUser() 
		{
			__instance = this ;
		}
		public function init(...rest:Array):XUser
		{
			trace("XAPP ON AIR !") ;
			__target = rest[0] ;
			__root = Root.root ;
			__userData = { } ;
			__data = new XData() ;
			__factory = XFactor.instance ;
			
			return this ;
		}
		//////////////////////////////////////// SETUP
		public function setup(custom:Class = null, control:XControl = null):void
		{
			//	---> External Presets
			__custom = XFactor.register(custom || XCustom, 'custom') ;
			//	---> AppParams established & Root.LoaderInfo parsed
			__parameters = XFactor.register(XParams, 'application_parameters', __target.loaderInfo, __custom.defaultParams)  ;
			//	--->  Start Application Prerequired Constructions
			__controller = control || XFactor.register(XControl, 'controller') ;
			//	---> Console enabled
			__console = XFactor.register(XConsole, 'console').dump(XParams.params) ;
		}
		
		//////////////////////////////////////// BUILD
		public function build():void
		{
			__controller.build() ;
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get target():Root { return __instance.target }
		static public function get root():Root { return __instance.root }
		static public function get custom():XCustom { return __instance.__custom }
		static public function set custom(value:XCustom):void { __instance.__custom = value }
		static public function get controller():XControl { return __instance.__controller }
		static public function get console():XConsole { return __instance.__console }
		static public function get parameters():XParams { return __instance.__parameters }
		static public function get factory():XFactor { return __instance.__factory }
		static public function get data():XData { return __instance.data }
		static public function get userData():Object { return __instance.userData }
		static public function init(...rest:Array):XUser { return instance.init.apply(instance, [].concat(rest)) }
		static public function get hasInstance():Boolean { return Boolean(__instance as XUser) }
		static public function get instance():XUser { return hasInstance? __instance :  new XUser() }
		
		public function get target():Sprite { return __target }
		public function get root():Root { return __root }
		public function get custom():XCustom { return __custom }
		public function set custom(value:XCustom):void { __custom = value }
		public function get controller():XControl { return __controller }
		public function get console():XConsole { return __console }
		public function get parameters():XParams { return __parameters }
		public function get factory():XFactor { return __factory }
		public function get data():XData { return __data }
		public function get userData():Object { return __userData }
	}
}


//////////////////////////////////////// XDATA
import flash.utils.Dictionary ;
import of.app.required.data.Gates;

dynamic class XData {
	//////////////////////////////////////// VARS
	public var __events:Gates 							= new Gates() ;
	public var __links:Object 							= { } ;
	public var __loaded:Dictionary 					= new Dictionary() ;
	public var __objects:Gates 						= new Gates() ;
	//////////////////////////////////////// CTOR
	function XData() {
		
	}
	
	///////////////////////////////////////////////////////////////////////////////// GENERATE
	/**
	 * Self-generates an Object, that will represent the content of an XML, 
	 * and will be accessible with the name of the localName() of xml's containing node
	 * 
	 * @param xml XML - the source XML
	 */	
	public function generate(xml:XML):void
	{
		this[xml.localName()] = createFromXML(xml) ;
	}
	///////////////////////////////////////////////////////////////////////////////// CREATEFROMXML
	/**
	 * Creates an Object from an XML, recursively and based on the localName() of the nodes the reading playhead meets.
	 * 
	 * @param xml XML - the source XML
	 */	
	public static function createFromXML(xml:XML):Object
	{
		var o:Object = { } ;
		var localName:String = xml.localName() ;
		o.localName = function():String { return localName } ;
		
		for each(var child:XML in xml.*) {
			var ref:String = child.@id.toXMLString() || String(child.childIndex()) ;
			var p:Object = { } ;
			for each(var attr:XML in child.attributes()) {
				p[attr.localName()] = attr.toXMLString() ;
			}
			for each(var ch:XML in child.*) {
				var l:String = ch.localName() ;
				if (Boolean(p[l])) {
					trace("!!! Overwriting over an attribute... XData")
				}else {
					p[l] = ch.toXMLString() ;
				}
			}
			o[ref] = p ;
		}
		return o ;
	}
	///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
	public function get address():String { return __address }
	public function get token():* { return __token }
	public function get sessionTicket():* { return __sessionTicket }
	public function get events():Gates { return __events }
	public function set events(value:Gates):void 
	{ __events = value }
	public function get loaded():Dictionary { return __loaded }
	public function set loaded(d:Dictionary) 
	{ __loaded = d }
	public function get objects():Gates { return __objects }
	public function set objects(value:Gates):void
	{ __objects = value }
}