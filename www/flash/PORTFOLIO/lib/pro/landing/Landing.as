package pro.landing 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import gs.easing.Expo;
	import gs.TweenLite;
	import gs.TweenMax;
	import tools.fl.sprites.Smart;
	
	/**
	 * v 0.1
	 * @author saz
	 */
	
	public class Landing extends Sprite
	{
		private var __screen:Smart;
		
		public function Landing() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage) ;
			
			init() ;
			events() ;
		}
		
		private function events():void 
		{
			/// RESIZE
			stage.addEventListener(Event.RESIZE, onStageResize) ;
			addEventListener(Event.RESIZE, onResize) ;
			
			dispatchEvent(new Event(Event.RESIZE)) ;
			
			//CLICK
			stage.addEventListener(MouseEvent.CLICK, onStageClicked )
		}
		
		private function onStageClicked(e:Event):void 
		{
			trace('YO')
			moveScreen() ;
		}
		
		private function moveScreen():void 
		{
			TweenMax.killTweensOf(__screen) ;
			var p:Point =  __screen.properties.getCoords() ;
			TweenMax.to(__screen, .5, {bezier:[{x:p.x + 50}, {x:p.x -50}, {x:p.x}], ease:Expo.easeOut});
		}
		
		private function onResize(e:Event):void 
		{
			__screen.dispatchEvent(e) ;
		}
		
		private function onStageResize(e:Event):void 
		{
			dispatchEvent(e) ;
		}
		
		private function init():void 
		{
			// stage
			stage.align = 'TL' ;
			stage.scaleMode = 'noScale' ;
			
			// blockTest
			var w__screen:int = 200 ;
			var h__screen:int = 200 ;
			
			__screen = new Smart( {
					coords:new Point(),
					resize:function(e):void {
						this.coords.x = (stage.stageWidth - w__screen ) >> 1 ;
						this.coords.y = (stage.stageHeight - h__screen)  >> 1 ;
						__screen.x = this.coords.x ;
						__screen.y = this.coords.y ;
					},
					getCoords:function():Point{return this.coords}
				}) ;
			__screen.properties.screen = __screen ;
			
			__screen.graphics.beginFill(0xFF6600) ;
			__screen.graphics.drawRect(0,0,h__screen,h__screen) ;
			__screen.graphics.endFill() ;
			
			__screen.addEventListener(Event.RESIZE, function(e:Event):void {
					__screen.properties.resize(e) ;
				}) ;
			
			addChild(__screen) ;
		}
	}
}