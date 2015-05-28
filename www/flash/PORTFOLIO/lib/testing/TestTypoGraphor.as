package testing 
{
	import fl.motion.DynamicMatrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import geeks.fx.Typographeur;
	import tools.fl.sprites.BehaviorSmart;
	import tools.fl.sprites.Smart;
	import tools.geom.matrix.GridMatrix;
	import tools.grafix.Draw;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestTypoGraphor extends Sprite 
	{
		private var container:Sprite;
		private var __t:Typographeur;
		
		public function TestTypoGraphor() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage)
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			init() ;
		}
		
		private function init():void 
		{
			initStage() ;
			initParams() ;
			initContainer() ;
		}
		
		private function initStage():void 
		{
			stage.align = 'TL' ;
			stage.scaleMode = 'noScale' ;
		}
		private function initParams():void 
		{
			//__t = new Typographeur('Kozuka Gothic Pro L', '思無愛') ;
			__t = new Typographeur('Mistral', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') ;
			__t.type = Typographeur.BOX ;
			__t.fromFile('../img/home2.jpg', .1, 100, 1, 3) ;
			__t.addEventListener(DataEvent.DATA, onReady) ;
			//rowsDisplayLimit = 3 ;
			//__index = 4 ;
			//unitWidth = 200 ;
			//unitHeight = 200 ;
			//margin = 1 ;
		}
		
		private function onReady(e:DataEvent):void 
		{
			addChild(__t.bmp) ;
		}
		
		private function initContainer():void 
		{
			container = new Sprite() ;
			addChild(container) ;
			stage.addEventListener(KeyboardEvent.KEY_UP, onStagePress, true) ;
			stage.addEventListener(MouseEvent.CLICK, onStageClick, true) ;
		}
		private function onStageClick(e:MouseEvent):void 
		{
			trace(e, e.target)
			//var n:int = e.target.name.replace('smart_', '') ;
			//trace(n == __index) ;
			//highlight(n) ;
		}
		private function onStagePress(e:KeyboardEvent):void 
		{
			trace(e, e.target)
			//if (!Boolean(e.target is Smart)) {
				//return ;
			//}
			//switch (e.keyCode) 
			//{
				//case Keyboard.UP:
					//highlight('up') ;
				//break;
				//case Keyboard.DOWN:
					//highlight('down') ;
				//break;
				//case Keyboard.LEFT:
					//highlight('left') ;
				//break;
				//case Keyboard.RIGHT:
					//highlight('right') ;
				//break;
			//}
		}
	}
}