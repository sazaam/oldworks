package  
{
	import arr.LimitedArr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import saz.helpers.sprites.Smart;
	/**
	 * ...
	 * @author saz
	 */
	public class TestPrinciple extends MovieClip
	{
		private var arr:LimitedArr ;
		private var total:int;
		private var __items:Array;
		private var __shapeCont:Sprite;
		
		public function TestPrinciple() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
		
		private function onStage(e:Event):void 
		{
			
			
			
			init() ;
			events() ;
		}
		
		private function events():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown) ;
		}
		
		public function init():void
		{
			total = 7 ;
			var xml:XML = aaa_3D_loaded_scheme ;
			arr = new LimitedArr( 7 , 4) ;
			
			var l:int = xml.*.length() ;
			
			initGraphics() ;
			
			for each(var item:XML in xml.*) {
				var i:int = item.childIndex() ;
				
				gCreateShape(i,l,item) ;
			}
		}
		
		private function gCreateShape(i:int,l:int,xml:XML):void
		{
			var sh:Smart = new Smart({rectangle:new Rectangle(0, 0, 10, 10)}) ;
			sh.name = "shape_" + i ;
			sh.graphics.beginFill(0xff3300, .4) ;
			sh.graphics.drawRect(0, 0, 10, 10) ;
			sh.graphics.endFill() ;
			__shapeCont.addChild(sh) ;
			
			__items.push(sh) ;
		}
		
		private function initGraphics():void
		{
			__items = [] ;
			__shapeCont = new Sprite() ;
		}
		
		private function onDown(e:MouseEvent):void 
		{
			//arr.translate(-1) ;
			
			//arr["8"] = 4 ;
			trace(arr) ;
		}
		
		
		
		
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
	}
}