package testing 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import frocessing.core.F5Graphics3D;
	import frocessing.display.F5MovieClip3DBmp;
	import frocessing.f3d.F3DContainer;
	import frocessing.f3d.models.F3DCube;
	import frocessing.geom.FNumber3D;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.*;
	import org.libspark.betweenas3.tweens.ITween;
	import tools.grafix.Draw;
	
	/**
	 * ...
	 * @author saz
	 */
	[SWF(width=465,height=465, frameRate=24, backgroundColor=0xFFFFFF)]
	public class TestStripes3D extends Sprite
	{
		
		private var __w:int = 400;
		private var __h:int = 400 ;
		
		private var __screenW:int = 247 ;
		private var __screenH:int = 207 ;
		
		private const URL:String = "../img/home/screen.png";
		private var __screen:Sprite;
		private var __screenBMP:Bitmap;
		
		
		private var __liveRenderer3D:F5LiveRenderer3D;
		private var __back:Sprite;
		private const DROP:DropShadowFilter = new DropShadowFilter(5,90, 0xFF3300, 1, 15,15,2, 3);
		
        
		public function TestStripes3D() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
		private function onStage(e:Event):void 
		{
			stage.align = 'TL' ;
			stage.scaleMode = 'noScale' ;
			
			if (e.type == Event.ADDED_TO_STAGE) {
				removeEventListener(e.type, arguments.callee) ;
				addEventListener(Event.REMOVED_FROM_STAGE, arguments.callee) ;
				
				events() ;
				init() ;
			}else {
				events(false) ;
				removeEventListener(e.type, arguments.callee) ;
			}
		}
		
		
		// INIT
		private function init():void 
		{
			initStage() ;
			
			presets() ;
			loadScreen() ;
		}
		
		private function initStage():void 
		{
			stage.align = 'TL' ;
			stage.scaleMode = 'noScale' ;
		}
		
		private function presets():void 
		{
			//FShapeSVG.parseSVG() ;
		}
		

		
		private function resume():void 
		{
			addContent() ;
			
			// LOADINGS FINISHED, REAL START
		}
		
		private function addContent():void 
		{
			addBack() ;
			addScreen() ;
			initViewPort3D() ;
			stage.dispatchEvent(new Event(Event.RESIZE)) ;
		}
		
		// VIEWPORT3D
		private function initViewPort3D():void 
		{
			__liveRenderer3D = new F5LiveRenderer3D(this) ;
		}
		// BACK
		private function addBack():void 
		{
			__back = new Sprite() ;
			__back.addEventListener(Event.RESIZE, onBackResize) ;
			addChild(__back) ;
		}
		private function drawBack():void 
		{
			Draw.redraw('rect', { g:__back.graphics, color:0xAAAAAA, alpha:.4 }, 0, 0, stage.stageWidth, stage.stageHeight) ;
		}
		
		// SCREEN
		private function addScreen():void 
		{
			__screen = new Sprite() ;
			__screen.addChild(__screenBMP) ;
			__screen.addEventListener(Event.RESIZE, onScreenResize) ;
			addChild(__screen) ;
		}
		
		private function posScreen():void 
		{
			__screen.x = (stage.stageWidth - __screen.width) >> 1 ;
			__screen.y = (stage.stageHeight - __screen.height) >> 1 ;
		}
		
		
		
		
		
		// LOAD
		
		private function loadScreen():void 
		{
			var loader:Loader = new Loader() ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				e.target.removeEventListener(e.type, arguments.callee) ;
				__screenBMP = e.target.content ;
				resume() ;
			}) ;
			loader.load(new URLRequest(URL), new LoaderContext(true)) ;
		}
		
		
		
		
		// EVENTS
		
		private function events(cond:Boolean = true):void 
		{
			if (cond) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouse) ;
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouse) ;
				stage.addEventListener(Event.RESIZE, onStageResize) ;
			}else {
				stage.removeEventListener(Event.RESIZE, onStageResize) ;
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouse) ;
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouse) ;
			}
		}
		private function onMouse(e:MouseEvent):void 
		{
			var cond:Boolean = e.type == MouseEvent.MOUSE_DOWN ;
			if (cond) {
				//var bmpdt:BitmapData = new BitmapData(__screen.width, __screen.height, true, 0x0) ;
				//bmpdt.draw(__screen) ;
				if (e.target == __back) {
					addChildAt(__liveRenderer3D.render(__back, e.stageX, e.stageY), 0) ;
				}else if (e.target == __screen) {
					addChild(__liveRenderer3D.render(__screen, e.stageX, e.stageY)) ;
				}else if (e.target is Stage) {
					stage.addChild(__liveRenderer3D.render(stage, e.stageX, e.stageY)) ;
				}
			}else {
				__liveRenderer3D.reset(__liveRenderer3D.parent.removeChild,__liveRenderer3D) ;
			}
		}
		private function onStageResize(e:Event):void 
		{
			__back.dispatchEvent(e) ;
			__screen.dispatchEvent(e) ;
			__liveRenderer3D.dispatchEvent(e) ;
		}
		
		private function onBackResize(e:Event):void 
		{
			drawBack() ;
		}
		private function onScreenResize(e:Event):void 
		{
			posScreen() ;
		}
		//private function onScreenOver(e:MouseEvent):void 
		//{
			//var cond:Boolean = e.type == MouseEvent.ROLL_OVER ;
			//if (cond) {
				//__screen.filters = __screen.filters.concat(DROP) ;
			//}else {
				//var p:Array = __screen.filters ;
				//p.splice(DROP) ;
				//__screen.filters = p ;
			//}
		//}
	}
}