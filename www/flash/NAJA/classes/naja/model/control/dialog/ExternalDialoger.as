package naja.model.control.dialog 
{
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import naja.model.Root;
	import naja.model.XData;
	/**
	 * ...
	 * @author saz
	 */
	public class ExternalDialoger 
	{	
//////////////////////////////////////////////////////// VARS
		static private var __instance:ExternalDialoger;
		
		private var __jsModule:JSModule ;
		private var __hierarchy:AddressHierarchy ;
		private var __swfAddress:SWFAddressChanger ;
		private var __bandWidth:int ;
		
//////////////////////////////////////////////////////// CTOR
		public function ExternalDialoger() 
		{
			__instance = this ;
		}
		
		public function init():ExternalDialoger
		{
			__jsModule = new JSModule() ;
			__swfAddress = new SWFAddressChanger() ;
			__hierarchy = __swfAddress.hierarchy ;
			__bandWidth = getBandWidth() ;
			return this ;
		}
///////////////////////////////////////////////////////////////////////////////////////////////// LINKS
		public function initLinks(links:XML):void
		{
			var data:XData = Root.user.model.data ;
			data.generate(links) ;
		}
///////////////////////////////////////////////////////////////////////////////////////////////// SWFADDRESS
		public function initAddress(home:String = null):void
		{
			__swfAddress.home = home || "HOME" ;
			__swfAddress.init(Root.root, true, true) ;
		}
///////////////////////////////////////////////////////////////////////////////// BUFFER & BANDWIDTH
		private function getBandWidth():int
		{
			var kbytes:Number = Root.root.loaderInfo.bytesTotal / 1024;
			var kbits:Number = kbytes * 8;
			var time:Number = getTimer() / 1000;
			return int((kbits/time) * (1 - 0.07)) ;
		}
		
		public static function calculateBuffer(flvLength:Number, flvBitrate:Number):Number {
			var bufferTime:Number;
			if (flvBitrate > bandWidth) {
				var n:Number = flvLength - flvLength / (flvBitrate / bandWidth) ;
				bufferTime =  n == int(n) ? n : int(n) + 1 ;
			} else {
				bufferTime = 0;
			}
			bufferTime += 3;
			return bufferTime;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function init():ExternalDialoger { return instance.init() }
		static public function get instance():ExternalDialoger { return __instance || new ExternalDialoger() }
		static public function get hasInstance():Boolean { return  Boolean(__instance) }
		public function get jsModule():JSModule
		{ return  __jsModule }
		public function get hasExternal():Boolean { return JSModule.hasExternal }
		public function get isLocal():Boolean { return SWFAddressChanger.LOCAL }
		public function get swfAddress():SWFAddressChanger { return __swfAddress; }
		public function get hierarchy():AddressHierarchy { return __hierarchy; }
		
		public static function get bandWidth():int { return __instance.__bandWidth }
	}
}