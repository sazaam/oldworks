package pro 
{
	import of.app.required.commands.Command;
	import of.app.required.context.XContext;
	import of.app.required.steps.VirtualSteps;
	import of.app.XUnique;
	import pro.navigation.navmain.OverallNavigation;
	/**
	 * ...
	 * @author saz
	 */
	public class UniqueNav extends XUnique
	{
		public function UniqueNav(originXml:XML)
		{
			super('NAV', new Command(this, onSite)) ;
			xml = originXml ;
		}
		
		private function onSite():void
		{
			trace('::::::::::::::::: ON NAV :::::::::::::::::') ;
			OverallNavigation.instance.init(XContext.$get("#nav")[0], this) ;
			OverallNavigation.instance.update(this) ;
		}
	}

}