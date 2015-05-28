package aguessy.custom.launch.visuals 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gs.TweenLite;
	import naja.model.control.context.Context;
	import naja.model.control.resize.StageResizer;
	import naja.model.Root;
	import naja.model.XUser;
	import saz.helpers.math.RatioPreserver;
	
	/**
	 * ...
	 * @author saz
	 */
	public class VisualManager extends Sprite
	{
		private static var __instance:VisualManager;
		private var user:XUser;
		private var __tg:Sprite;
		private var __fill:Object;
		private var __defaultFill:Object;
		private var bmp:Bitmap;
		
		public function VisualManager(_defaultFill:Object = null) 
		{
			__instance = this ;
			user = Root.user ;
			//alpha = 0 ;
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
			
			if (!stage) {
				__tg = Context.$get(this).attr( { id:"VM", name:"VM" } )[0] ;
				Context.$get("#all")[0].addChildAt(this,0) ;
			}
			__defaultFill = _defaultFill || 0xF8F8F8 ;
		}
		
		private function onStage(e:Event):void 
		{
			__fill = __defaultFill ;
			refresh() ;
			addEventListener(Event.RESIZE,onResize) ;
			StageResizer.instance.handle(this) ;
			//TweenLite.to(this, .5, { alpha:1 } ) ;
		}
		
		private function onResize(e:Event):void 
		{
			drawBackground();
		}
		
		public function refresh():void
		{
			//alpha = 0 ;
			drawBackground() ;
			//TweenLite.to(this, .5, { alpha:1 } ) ;
		}
		
		private function drawBackground(alpha:Number = 1):void
		{
			
			var w:int = Root.root.stage.stageWidth ;
			var h:int = Root.root.stage.stageHeight ;
			var background:Sprite = Context.$get("#background")[0] ;
			try 
			{
				removeChild(bmp) ;
			}catch (e:Error)
			{
				//
			}
		
			if (__fill is uint) {
				//graphics.beginFill(uint(__fill),alpha) ;
			}else if (__fill is String) {
				
			}else if (__fill is Bitmap) {
				
				bmp = Bitmap(__fill) ;
				
				scaleBitmap(bmp,w,h) ;
				
				addChild(bmp) ;
			}else if (__fill is BitmapData) {
				bmp = new Bitmap(BitmapData(__fill),"auto",true) ;
				
				scaleBitmap(bmp,w,h) ;
				
				addChild(bmp) ;
			}
			
		}
		
		private function scaleBitmap(bmp:Bitmap,w:int,h:int):void
		{
			if (!bmp.smoothing) bmp.smoothing = true ;
			var coords:Rectangle = getCoords(bmp.bitmapData, w, h) ;
			bmp.x = coords.x ;
			bmp.y = coords.y ;
			bmp.width = coords.width ;
			bmp.height = coords.height ;
		}
		
		private function getCoords(bmpd:BitmapData,w:int,h:int):Rectangle
		{
			var s:Rectangle = RatioPreserver.preserveRatio(new Rectangle(0,0,bmpd.width, bmpd.height), new Rectangle(0, 0, w, h),true) ;
			return s ;
		}
		
		public static function get instance():VisualManager 
		{
			return __instance || new VisualManager() ;
		}
		
		public function get fill():Object { return __fill; }
		
		public function set fill(value:Object):void 
		{ __fill = value ; refresh() }
		
		public function get defaultFill():Object { return __defaultFill }
	}
	
}