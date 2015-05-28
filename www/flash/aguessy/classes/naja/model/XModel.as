package naja.model 
{
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class XModel 
	{
//////////////////////////////////////////////////////// VARS
		private var __data:XData ;
		private var __module:XModule ;
		private var __config:XML ;
		private var __sections:XML ;
		private var __scripts:XML ;
		private var __libraries:XML ;
		private var __uniqueSteps:VirtualSteps ;
//////////////////////////////////////////////////////// CTOR
		public function XModel() 
		{
			trace("CTOR > "+this)
			__data = new XData() ;
			__module = new XModule() ;
			__module.init(this) ;
			__uniqueSteps = user.customizer ;
		}
		
		public function loadConfig():void
		{
			__module.loadConfigXML() ;
		}
		
		public function open():void
		{
			__module.open() ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get data():XData { return __data }
		public function get user():XUser { return Root.user }
		public function get module():XModule { return __module }
		public function get config():XML { return __config }
		public function set config(value:XML):void 
		{ __config = value }
		public function get libraries():XML { return __libraries }
		public function set libraries(value:XML):void 
		{ __libraries = value }
		public function get sections():XML { return __sections }
		public function set sections(value:XML):void 
		{ __sections = value }
		public function get scripts():XML { return __scripts }
		public function set scripts(value:XML):void 
		{ __scripts = value }
	}
}