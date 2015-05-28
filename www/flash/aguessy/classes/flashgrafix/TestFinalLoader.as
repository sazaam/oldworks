package flashgrafix 
{
	import asSist.$;
	import flash.display.Sprite;
	import flash.events.Event;
	import saz.helpers.loadlists.loaders.AllLoader;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestFinalLoader extends Sprite
	{
		
		public function TestFinalLoader() 
		{
			$(stage).attr( { scaleMode: "noScale", align: "TL" } ) ;
			
			var allLoader:AllLoader = new AllLoader(this,new CustomLoaderGraphics(this),true) ;
			//allLoader.addEventListener(Event.COMPLETE, init) ;
			allLoader.launch() ;
		}
		
		private function init(e:Event):void 
		{
			//trace("sfbdndbdbdbnbdn : "+e.currentTarget.content)
			//trace("sfbdndbdbdbnbdn")
			//stage.dispatchEvent(new Event(Event.CONNECT)) ;
		}
	}
}