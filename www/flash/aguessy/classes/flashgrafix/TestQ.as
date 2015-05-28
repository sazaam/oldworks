package flashgrafix 
{
	import asSist.*;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import gs.TweenLite;
	import mvc.behavior.substitutes.Substitutor;
	import saz.helpers.layout.layers.Layer;
	import saz.helpers.layout.layers.LayerSystem;
	import saz.helpers.loadlists.loaders.AllLoader;
	import saz.helpers.loadlists.loaders.LoaderGraphics;
	//import saz.helpers.loadlists.loaders.StepLoader;
	import saz.helpers.loadlists.loaders.StructLoader;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestQ extends Sprite
	{
		public var XMLS:Array ;
		public var FONTS:Array ;
		private var layerSystem:LayerSystem;
			
		public function TestQ() 
		{
			$(this).attr( { alpha: 0 } ).bind(Event.ADDED_TO_STAGE, onStage) ; 
		}
		
		private function onStage(e:Event):void
		{
			$(stage).attr( { scaleMode: "noScale", align: "TL" } ) ;

			var allLoader:AllLoader = new AllLoader(this,new LoaderGraphics()) ;
			structLoader.addEventListener(Event.COMPLETE, initMain) ;
			structLoader.launch() ;
		}
		
		private function initMain(e:Event):void
		{
			$("#loadTXT").remove() ;
			XMLS = e.currentTarget.content.XMLS ;
			FONTS = e.currentTarget.content.FONTS ;
			trace(FONTS["EUROSTYLE_BOLD"]) ;
			trace("main inited") ;
			$(XML(XMLS[0])).appendTo(this) ;
			layerSystem = new LayerSystem([new Layer("sazaam", new Sprite()), new Layer("ornorm", new Sprite())], 0xFFFFFF, .8) ;
			
			intro() ;
		}
		
		private function intro():void
		{
			trace(parent as FinalLoader)
			$('TextField').each(function(i:int, el:TextField) {
				var tf1:TextFormat = el.getTextFormat() ;
				var tf2:TextFormat = new TextFormat(Font(new FONTS["EUROSTYLE"]()).fontName,155,0xFF6600,true) ;
				//tf1.font = Font(new FONTS[0]()).fontName ;
				//tf1.bold = false ;
				//tf1.color = 0xFFFFFF ;
				//tf2.font = Font(new FONTS[1]()).fontName ;
				tf2.bold = true ;
				//tf2.color = 0x0 ;
				Substitutor.IF(this, i == 0 , function() {
					//trace(tf1.font  , "    " ,  tf2.font  ) ;
						trace("FONTS" + Font.enumerateFonts()) ;
						el.setTextFormat(tf2) ;
						//trace(tf2.font) ;
						//el.setTextFormat(tf1, 0, 3) ;
						//el.setTextFormat(tf2, 3, el.text.length) ;
						el.addEventListener(MouseEvent.CLICK, onTextClicked) ;
					})
			});
			TweenLite.to(this, .4, { alpha:1 } ) ;
		}
		
		private function onTextClicked(e:MouseEvent):void
		{

			var f = e.currentTarget.filters[0] ;
			var s = e.target ;
			TweenLite.to(f, 1, { blurX:0, blurY:0, onUpdate:function() { s.filters = [f] }} ) ;
			//layerSystem.show("sazaam") ;
			//layerSystem.hide("sazaam") ;
		}
	}
}