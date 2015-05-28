package naja.model.control.dialog 
{
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import naja.model.Root;
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
			trace("CTOR > " + this)
			__instance = this ;
			__jsModule = new JSModule() ;
			__swfAddress = new SWFAddressChanger() ;
			__hierarchy = __swfAddress.hierarchy ;
			__bandWidth = getBandWidth() ;
		}
		
		public function initAddress(home:String = null,debugTF:TextField = null):void
		{
			__swfAddress.home = home || "HOME" ;
			__swfAddress.init(Root.root, true, true) ;
		}
		
///////////////////////////////////////////////////////////////////////////////// HELPERS
		private function getBandWidth():int
		{
			var kbytes:Number = Root.root.loaderInfo.bytesTotal / 1024;
			var kbits:Number = kbytes * 8;
			var time:Number = getTimer() / 1000;
			return Math.floor((kbits/time) * (1 - 0.07)) ;
		}
		
		public static function calculateBuffer(flvLength:Number, flvBitrate:Number):Number {
			var bufferTime:Number;
			if (flvBitrate > bandWidth) {
				bufferTime = Math.ceil(flvLength - flvLength/(flvBitrate/bandWidth));
			} else {
				bufferTime = 0;
			}
			bufferTime += 3;
			return bufferTime;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get instance():ExternalDialoger { return __instance || new ExternalDialoger() }
		
		public function get jsModule():JSModule
		{ return  __jsModule }
		public function get hasExternal():Boolean { return JSModule.hasExternal }
		public function get isLocal():Boolean { return SWFAddressChanger.LOCAL }
		public function get swfAddress():SWFAddressChanger { return __swfAddress; }
		public function get hierarchy():AddressHierarchy { return __hierarchy; }
		
		public static function get bandWidth():int { return __instance.__bandWidth }
	}
}