package of.app.required.dialog 
{
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.text.TextField;
	import of.app.required.dialog.SWFAddresses.SWFAddress;
	import of.app.required.dialog.SWFAddresses.SWFAddressEvent;
	import of.app.required.regexp.BasicRegExp;
	import of.app.required.steps.AddressChanger;
	import of.app.XConsole;
	
	/**
	 * ...
	 * @author saz
	 */
	public class SWFAddressChanger extends AddressChanger
	{
		////////////////////////////////////////////////// CONST
		public static const LOCAL:Boolean = Security.sandboxType != Security.REMOTE ;
		private static  var __instance:SWFAddressChanger;
		////////////////////////////////////////////////// VARS
		public var futureAddress:String ;
		public var formerAddress:String ;
		
		protected var __inited:Boolean ;
		protected var __debug:Boolean ;
		protected var __debug_tf:TextField ;
		protected var __target:Sprite ;
		protected var __history:Boolean ;
		
		///////////////////////////////////////////////////////////////////////////////// CTOR
		public function SWFAddressChanger() 
		{
			__instance = this ;
		}
		public function init():SWFAddressChanger
		{
			trace(this, 'inited...') ;
			return this;
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// ENABLE
		public function enable(_target:Sprite,_history:Boolean = false,_debug:Boolean = false):SWFAddressChanger
		{
			__target = _target;
			__debug = _debug ;
			__history = _history ;
			
			SWFAddress.addEventListener(SWFAddressEvent.INIT, initSWFAddress) ;
			
			return this;
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// INITSWFADDRESS
		private function initSWFAddress(e:SWFAddressEvent):void 
		{
			var hist:Boolean = SWFAddress.getHistory() ;
			history = hist == __history ? __history : hist ;
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onAddressChange) ;
		}
		////////////////////////////////////////////////////////////////////////////////////////////////  ON ADDRESS CHANGE
		private function onAddressChange(e:SWFAddressEvent):void 
		{
			XConsole.log('CHANGED')
			__hierarchy.redistribute(e.value) ;
		}
//////////////////////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get hasInstance():Boolean { return Boolean(__instance as SWFAddressChanger) }
		static public function init(...rest:Array):SWFAddressChanger { return instance.init.apply(instance, [].concat(rest)) }
		static public function get instance():SWFAddressChanger { return hasInstance? __instance :  new SWFAddressChanger() }
		
		public function get debug_tf():TextField { return __debug_tf }
		public function set debug_tf(_newVal:TextField):void { __debug_tf = TextField(_newVal) }
		////////////////////////////////////////////////////////////////////////////////// SWFADDRESS
		public function get address():String { return SWFAddress.getPath().replace(__RX__CLEANURL,"") }
		public function get baseURL():String { return SWFAddress.getBaseURL() }
		public function get queryString():String { return SWFAddress.getQueryString() }
		public function getParameter(_val:String):String { return SWFAddress.getParameter(_val) }
		public function get parameterNames():Array { return SWFAddress.getParameterNames() }
		public function get path():String { return SWFAddress.getPath() }
		public function get pathNames():Array { return SWFAddress.getPathNames() }

		override public function get value():String {
			var s:String = SWFAddress.getValue().replace(/^\//,'') ;
			return s ;
		}
		
		override public function set value(newVal:String):void {
			SWFAddress.setValue(newVal) ; 
		}
		public function get title():String { return SWFAddress.getTitle() }
		public function set title(newVal:String):void { SWFAddress.setTitle(newVal) }
		public function get status():String { return SWFAddress.getStatus() }
		public function set status(newVal:String):void { return SWFAddress.setStatus(newVal) }
		public function get strict():Boolean { return SWFAddress.getStrict() }
		public function set strict(cond:Boolean):void{ return SWFAddress.setStrict(cond) }
		public function get history():Boolean { return SWFAddress.getHistory() }
		public function set history(cond:Boolean):void { __history = cond ; return SWFAddress.setHistory(__history) }
		public function get tracker():String{ return SWFAddress.getTracker() }
		public function set tracker(newVal:String):void { return SWFAddress.setTracker(newVal) }
		public function get debug():Boolean { return __debug }
		public function set debug(value:Boolean):void { __debug = value }
	}
}