package naja.model.control.dialog 
{
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author saz
	 */
	public class SWFAddressChanger 
	{
		////////////////////////////////////////////////// CONST
		public static const LOCAL:Boolean = Security.sandboxType != Security.REMOTE ;
		public static const __RX__CLEANURL:RegExp = /^\/|\/$/g ;
		public static const __RX__SPLITTER:RegExp = /[\d\w]+[^\/]/g ;
		////////////////////////////////////////////////// VARS
		public var SWFLocalOnly:Boolean ;	
		public var futureAddress:String ;
		public var formerAddress:String ;
		
		protected var __inited:Boolean ;
		protected var __debug:Boolean ;
		protected var __debug_tf:TextField ;
		protected var __home:String ;
		protected var __target:Sprite ;
		protected var __history:Boolean ;
		protected var __hierarchy:AddressHierarchy;
		
		///////////////////////////////////////////////////////////////////////////////// CTOR
		public function SWFAddressChanger() 
		{
			__hierarchy = new AddressHierarchy() ;
		}
		
		public function init(_target:Sprite,_history:Boolean = false,_debug:Boolean = false):SWFAddressChanger
		{
			__target = _target;
			if (_debug) __debug = _debug ;
			if (_history) __history = _history ;
			SWFAddress.addEventListener(SWFAddressEvent.INIT, initSWFAddress);
			return this;
		}
		
		private function initSWFAddress(e:SWFAddressEvent):void 
		{
			__hierarchy.init(this) ;
			var hist:Boolean = SWFAddress.getHistory() ;
			history = hist == __history ? __history : hist ;
			if (__target.hasEventListener(e.type)) __target.dispatchEvent(e) ;
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onAddressChange);
		}
		public function evaluate(s:String = null):void
		{
			formerAddress = address || __home;
			if (s == null) 
			{
				s = futureAddress.toUpperCase() ;
			}
			else
			{
				futureAddress = s.toUpperCase() ;
			}
			
			var rest:Array = s.match(__RX__SPLITTER) ;
			
			if (hierarchy.check.apply(hierarchy, [].concat(rest)) ) {
				value = s ;
			}
			
		}
		
		private function onAddressChange(e:SWFAddressEvent):void 
		{
			if (e.value == "/" && __home!="/") {
				value = __home ;
				return ;
			}
			if (__debug) {
				var s:String = "\nSWFADDRESS Changed\n" + e.value ;
			}
			__hierarchy.redistribute(e.value.replace(__RX__CLEANURL,"").split("/")) ;
			if(__target.hasEventListener(e.type)) __target.dispatchEvent(e) ;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
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

		public function get value():String {
			var s:String = SWFAddress.getValue() ;
			s = s.replace(__RX__CLEANURL,"") ;
			return s ;
		}
		
		public function set value(_newVal:String):void {  SWFAddress.setValue(_newVal) }
		public function get title():String { return SWFAddress.getTitle() }
		public function set title(_newVal:String):void { SWFAddress.setTitle(_newVal) }
		public function get status():String { return SWFAddress.getStatus() }
		public function set status(_newVal:String):void { return SWFAddress.setStatus(_newVal) }
		public function get strict():Boolean { return SWFAddress.getStrict() }
		public function set strict(cond:Boolean):void{ return SWFAddress.setStrict(cond) }
		public function get history():Boolean { return SWFAddress.getHistory() }
		public function set history(cond:Boolean):void { __history = cond ; return SWFAddress.setHistory(__history) }
		public function get tracker():String{ return SWFAddress.getTracker() }
		public function set tracker(_newVal:String):void { return SWFAddress.setTracker(_newVal) }
		public function get debug():Boolean { return __debug }
		public function set debug(value:Boolean):void { __debug = value }
		public function get home():String { return __home.toUpperCase() }
		public function set home(value:String):void { __home = value.toUpperCase() }
		
		public function get hierarchy():AddressHierarchy { return __hierarchy }
	}
}