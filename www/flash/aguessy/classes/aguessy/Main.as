package aguessy 
{
	import aguessy.custom.UniqueSteps;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import naja.model.Root;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Main extends Root
	{
//////////////////////////////////////////////////////// CTOR
		public function Main() 
		{
			trace("CTOR > " + this) ;
			
			var o:Object = { config:"../xml/struct/config.xml",librairies:"../xml/struct/librairies.xml", scripts:"../xml/struct/scripts/js.xml", root:"../" , html:"../xml/" ,xml:"../xml/" , swf:"../swf/" , img:"../img/" ,flv:"../flv/" , pdf:"../pdf/" } ;
			
			Root.user.sitePathes = o ;
			Root.user.customizer = new UniqueSteps() ;
		}
	}
}