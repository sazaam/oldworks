package naja.model 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import modules.foundation.Type;
	import naja.model.XModel;
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class XUser 
	{
//////////////////////////////////////////////////////// VARS
		private var __customizer:VirtualSteps ;
		private var __model:XModel ;
		//USER
		private var __pathes:Object ;
		private var __address:String ;
		private var __parameters:Object ;
		private var __sessionTicket:* ;
		private var __token:* ;
		private var __userData:Object = {};
//////////////////////////////////////////////////////// CTOR
		public function XUser() 
		{
			trace("CTOR > "+this)
			Root.root.addEventListener(Event.ADDED_TO_STAGE, onStage ) ;
		}
		
///////////////////////////////////////////////////////////////////////////////// SITE PATHES
		private function setSitePathes(o:Object):Object
		{
			var root:Root = Root.root ;
			var pathes:Object = { } ;
			var obj:Object = root.loaderInfo.parameters ;
			for (var a:String in o) {
				pathes[a] = o[a] ;
			}
			for (var i:String in obj) {
				if (i in pathes) pathes[i] = obj[i] ;
			}
			return pathes ;
		}
		
		
///////////////////////////////////////////////////////////////////////////////// STAGE INIT
		private function onStage(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			__model = new XModel() ;
			__model.loadConfig() ;
			__model.module.addEventListener(Event.CONNECT,onConnect) ;
		}
		
		
///////////////////////////////////////////////////////////////////////////////// MODEL CONNECT
		private function onConnect(e:Event):void 
		{
			play(Root.root) ;
		}
		
		private function play(root:Root):void
		{
			trace("PLAY > " + this) ;
			__model.open() ;
			//customizer.launch()
		}
		
		
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get model():XModel { return __model }
		public function get customizer():VirtualSteps { return __customizer }
		public function set customizer(value:VirtualSteps):void 
		{ __customizer = value }
		public function get sitePathes():Object {return __pathes } 
		public function set sitePathes(value:Object):void 
		{ __pathes = setSitePathes(value) }
		public function get userData():Object { return __userData }
		public function get address():String { return __address }
		public function get token():* { return __token }
		public function get sessionTicket():* { return __sessionTicket }
		public function get parameters():Object { return __parameters }
		
		
	}
}