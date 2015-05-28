package saz.geeks.Mac 
{
	import flash.events.Event;
	import flash.text.TextField;
	import saz.geeks.Mac.views.MacSkin
	import saz.geeks.Mac.views.MacView
	import saz.geeks.Mac.views.MacViewz
	/**
	 * ...
	 * @author saz
	 */
	public class MacPlayerGraphics 
	{
		public var 	macPlayer				:MacPlayer
		public var 		skinz				:Array

		
		
		public var currentView:MacView;
		
		private var 	skin_0				:Object = {
		
												UPPER_NAV : new UpperNav(),
												NEXT : new Next(),
												PREV : new Next(),
												SECTION : Section,
												TYPO_SECTION : new FontSkin01(),
												TYPO_TEXTES : new FontSkin01_textes(),
												PARTS_MCS : [new ParamsSection(),new VideoSection(),new MusicSection(),new StudioSection()],
												PARTS_MCS_BACKGROUNDS : ["img/params_behind.jpg","img/video_behind.jpg","img/music_behind.jpg","img/studio_behind.jpg"]
											}
		
		public function MacPlayerGraphics() 
		{
			
		}
		
		public function resize(e:Event):void
		{
			currentView.posElems(e)
		}
		
		public function init(_player:MacPlayer):MacPlayerGraphics
		{
			macPlayer				= _player
			skinz 					= [new MacSkin().generateBytes( skin_0 )] 
			var view:MacView		= new MacView().init(this)
			view.skin = skinz[0]
			view.generate(macPlayer.MacDepot.sectionList)
			currentView = view
			//currentView.displaySections(true)
			view.posElems()
			//macPlayer.target.stage.dispatchEvent(new Event(Event.RESIZE))
			return this
		}
		
	}
	
}