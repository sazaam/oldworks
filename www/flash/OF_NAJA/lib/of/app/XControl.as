package of.app 
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import naja.tools.steps.VirtualSteps;
	import of.app.required.build.XBuild;
	import of.app.required.context.XContext;
	import of.app.required.dialog.XExternalDialoger;
	import of.app.required.events.XEventsRegisterer;
	import of.app.required.loading.XAllLoader;
	import of.app.required.loading.XGraphicalLoader;
	import of.app.required.steps.VirtualSteps;
	
	public class XControl
	{
		// REQUIRED
		static private var __instance:XControl ;
		static public const LOCAL:Boolean = Security.sandboxType != Security.REMOTE ;
		static public const EXTERNAL:Boolean = Boolean(ExternalInterface.objectID) ;
		static public const EXTERNAL_ID:String = ExternalInterface.objectID ;
		
		//////////////////////////////////////// CTOR
		public function XControl()
		{
			__instance = this ;
		}
		//////////////////////////////////////// INIT
		public function init(...rest:Array):XControl
		{
			trace(this, 'inited...') ;
			setup() ;
			return this ;
		}
		
		public function setup():void
		{
			//	---> Context enabled
			XFactor.register(XContext, 'context', XUser.target), XContext.initStage(XParams.params.stage) ;
			//	---> Events enabled
			XFactor.register(XEventsRegisterer, 'events_registerer') ;
			//	---> dialog enabled
			XFactor.register(XExternalDialoger, 'dialoger') ;
			//	---> loadings enabled
			XFactor.register(XGraphicalLoader, 'application_loader', XUser.custom.graphics) ;
			//	---> All loadings enabled
			XFactor.register(XAllLoader, 'all_loader', XUser.target) ;
		}
		
		public function build():void
		{
			XFactor.register(XBuild, 'builder').build(XParams.params).addEventListener(Event.CONNECT, onBuild) ;
		}
		///////////////////////////////////////////////////////////////////////////////// OPEN
		private function onBuild(e:Event):void
		{
			var dialoger:XExternalDialoger = XUser.factory.classes.dialoger ;
			var u:VirtualSteps = dialoger.hierarchy.functions = XUser.custom.unique ;
			trace('SITE BUILD !!!!!!!!!!!!!!!!!!!!!!!!!!!')
			u.commandOpen.addEventListener(Event.COMPLETE , onOpen) ;
			u.play() ;			
		}
		
		private function onOpen(e:Event):void 
		{
			var dialoger:XExternalDialoger = XUser.factory.classes.dialoger ;
			dialoger.initAddress(dialoger.swfAddress.home) ;
			XUser.console.upgrade() ;
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function init(...rest:Array):XControl { return instance.init.apply(instance, [].concat(rest)) }
		static public function get hasInstance():Boolean { return Boolean(__instance as XControl) }
		static public function get instance():XControl { return hasInstance? __instance :  new XControl() }
	}
}