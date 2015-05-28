package of.app.required.dialog 
{
	import flash.system.ApplicationDomain;
	import flash.utils.getTimer;
	import of.app.Root;
	import of.app.XFactor;
	/**
	 * ...
	 * @author saz
	 */
	public class XExternalDialoger 
	{	
//////////////////////////////////////////////////////// VARS
		static private var __instance:XExternalDialoger;
		
		private var __jsModule:JSModule ;
		private var __hierarchy:AddressHierarchy ;
		private var __swfAddress:SWFAddressChanger ;
		private var __bandWidth:int ;
		
//////////////////////////////////////////////////////// CTOR
		public function XExternalDialoger() 
		{
			__instance = this ;
		}
		
		private function setup():void 
		{
			XFactor.register(AddressHierarchy, 'hierarchy') ;
			XFactor.register(SWFAddressChanger, 'jsmodule') ;
			XFactor.register(JSModule, 'jsmodule') ;
		}
		
		public function init():XExternalDialoger
		{
			setup() ;
			__jsModule = JSModule.instance ;
			__swfAddress = SWFAddressChanger.instance ;
			__hierarchy = AddressHierarchy.instance ;
			__bandWidth = getBandWidth() ;
			
			trace(this, ' inited...')
			return this ;
		}
///////////////////////////////////////////////////////////////////////////////////////////////// LINKS
		public function initLinks(links:XML):void
		{
			Root.user.data.generate(links) ;
		}
///////////////////////////////////////////////////////////////////////////////////////////////// SWFADDRESS
		public function initAddress():void
		{
			__swfAddress.enable(Root.root, true, true) ;
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
		static public function init():XExternalDialoger { return instance.init() }
		static public function get instance():XExternalDialoger { return __instance || new XExternalDialoger() }
		static public function get hasInstance():Boolean { return  Boolean(__instance as XExternalDialoger) }
		public function get jsModule():JSModule
		{ return  __jsModule }
		public function get hasExternal():Boolean { return JSModule.hasExternal }
		public function get isLocal():Boolean { return SWFAddressChanger.LOCAL }
		public function get swfAddress():SWFAddressChanger { return __swfAddress; }
		public function get hierarchy():AddressHierarchy { return __hierarchy; }
		
		public static function get bandWidth():int { return __instance.__bandWidth }
	}
}