package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import graph3D.Graph3D;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Test3D extends MovieClip
	{
		internal static const aaa_3D_loaded_scheme:XML = <section id="portfolio">
	<category name="spoons">
		<item id="pirate_mind">
			<image url="" />
			<image url="" />
		</item>
		<item id="crazy_town">
			<image url="" />
			<image url="" />
		</item>
		<item id="crazy_moose">
			<image url="" />
			<image url="" />
			<image url="" />
			<image url="" />
		</item>
	</category>
	<category name="items">
		<item id="crazy_moose">
			<image url="" />
			<image url="" />
			<image url="" />
			<image url="" />
		</item>
	</category>
	<category name="furniture">
		<item id="pirate_mind">
			<image url="" />
			<image url="" />
		</item>
		<item id="crazy_town">
			<image url="" />
			<image url="" />
		</item>
		<item id="crazy_town">
			<image url="" />
			<image url="" />
		</item>
		<item id="useless_tool">
			<image url="" />
			<image url="" />
			<image url="" />
		</item>
		<item id="crazy_moose">
			<image url="" />
			<image url="" />
			<image url="" />
			<image url="" />
		</item>
	</category>
	<category name="interior">
		<item id="hopeless_snitches">
			<image url="" />
			<image url="" />
			<image url="" />
		</item>
		<item id="crazy_town">
			<image url="" />
			<image url="" />
		</item>
		<item id="crazy_town">
			<image url="" />
			<image url="" />
		</item>
		<item id="crazy_town">
			<image url="" />
			<image url="" />
		</item>
		<item id="crazy_town">
			<image url="" />
			<image url="" />
		</item>
		<item id="viandox_window">
			<image url="" />
			<image url="" />
			<image url="" />
			<image url="" />
		</item>
		<item id="crazy_town">
			<image url="" />
			<image url="" />
		</item>
		<item id="viandox_window">
			<image url="" />
			<image url="" />
			<image url="" />
			<image url="" />
		</item>
	</category>
</section> ;
		
		public function Test3D() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
			trace("initialized") ;
		}
		
		private function onStage(e:Event):void 
		{
			stage.align = 'TL' ;
			stage.scaleMode = 'noScale' ;
			var mmask:Sprite = new sazaam() ;
			addChild(mmask) ;
			var xml:XML = aaa_3D_loaded_scheme ;
			var mc:Sprite = new Sprite() ;
			mmask.addChild(mc) ;
			var m:Sprite = mmask["maskk"];
			mmask.x = 50 ;
			mmask.y = 70 ;
			m.cacheAsBitmap = true ;
			mc.cacheAsBitmap = true ;
			mc.mask = m ;
			mc.x = stage.stageWidth/2 + mmask.width/2+2 ;
			mc.y = stage.stageHeight/2 + 41 ;
			
			var g3D:Graph3D = new Graph3D() ;
			g3D.init(mc) ;
			
			g3D.evaluate(xml) ;

			g3D.play() ;
			
			//mc.scaleX = mc.scaleY = .75 ;
			//addChild(mc) ;
		}
	}
}