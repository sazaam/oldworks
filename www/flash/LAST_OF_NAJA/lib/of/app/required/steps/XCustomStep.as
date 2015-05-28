package of.app.required.steps
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import of.app.required.commands.Command;
	import of.app.required.context.XContext;
	import of.app.required.dialog.XExternalDialoger;
	import of.app.required.steps.VirtualSteps;
	import of.app.Root;
	import of.app.XConsole;
	import pro.navigation.navmain.OverallNavigation;
	import tools.grafix.Draw;
	import tools.layer.Layer;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class XCustomStep extends VirtualSteps
	{
		public var needsLoading:Boolean;
		public var isFinal:Boolean;
		
		public function XCustomStep(__id:String, structXML:XML) 
		{
			super(__id, new Command(this, onStep, true), new Command(this, onStep, false)) ;
			xml = structXML ;
		}
		
		private function onStep(cond:Boolean):void
		{
			if (cond) {
				trace("opening step", id) ;
				Root.user.console.log('opening step id : ' + id + '   >>> path : ' + path) ;
			}else {
				trace("closing step", id) ;
				Root.user.console.log('closing step id : ' + id + '   >>> path : ' + path) ;
			}
		}
	}
}