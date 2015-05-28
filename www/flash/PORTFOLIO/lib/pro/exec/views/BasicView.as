package pro.exec.views 
{
	import asSist.as3Query;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import of.app.required.context.XContext;
	import tools.geom.RatioPreserver;
	/**
	 * ...
	 * @author saz
	 */
	public class BasicView 
	{
		static private var __stage:Stage;
		static private var __target:Sprite;
		static private var __spaceNav:Sprite;
		static private var __basicNav:Sprite;
		static private var __depthNav:Sprite;
		static private var __frame:Sprite;
		static private var __minFrame:Sprite;
		static private var __focusIndex:int;
		static private var __background:Sprite;
		static protected var __externals:ApplicationDomain;
		static protected var __lastFocused:InteractiveObject; 
		
		///////////////////////////////////// CTOR
		public function BasicView() 
		{
			
		}
		
		////////////////////////////////////////////////////////////////////////// DISPLAY
		///////////////////////////////////// FILTERS
		public const BlackAndWhiteColorMatrix:Array = [
			0.6, 0.2, 0.2, 0, 0,
			0.6, 0.2, 0.2, 0, 0,
			0.6, 0.2, 0.2, 0, 0,
			0, 0, 0, 1, 0
		];
		public const InvertTypeWhiteColorMatrix:Array = [
			0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 
			0, 0, 0, 1, 0
		] ;
		public const COLOR_BW:ColorMatrixFilter = new ColorMatrixFilter(BlackAndWhiteColorMatrix) ;
		public const COLOR_TO_BLACK:ColorMatrixFilter = new ColorMatrixFilter(InvertTypeWhiteColorMatrix) ;
		public const DROP_SHADOW_STRONG:DropShadowFilter = new DropShadowFilter(2, 90, 0x0, .75, 5, 5, 2.5, 3)
		public const DROP_SHADOW_ALL:DropShadowFilter = new DropShadowFilter(1, 90, 0xFFFFFF, .45, 1, 1, 1, 3) ;
		public const DROP_SHADOW_INNER_ALL:DropShadowFilter = new DropShadowFilter(5, 90, 0x0, 1, 32, 32, .9, 3, true) ;
		
		public function applyDropShadow(spr:DisplayObject, cond:Boolean = true):void 
		{
			var p:Array = spr.filters ;
			if (cond) {
				spr.filters = spr.filters.concat(DROP_SHADOW_ALL) ;
			}else {
				p.splice(DROP_SHADOW_ALL) ;
				spr.filters = p ;
			}
		}
		public function applyInnerShadow(spr:DisplayObject, cond:Boolean = true):void 
		{
			var p:Array = spr.filters ;
			if (cond) {
				spr.filters = spr.filters.concat(DROP_SHADOW_INNER_ALL) ;
			}else {
				p.splice(DROP_SHADOW_INNER_ALL) ;
				spr.filters = p ;
			}
		}
		
		public function applyBackShadow(spr:DisplayObject, cond:Boolean = true):void 
		{
			if (cond) {
				spr.filters = spr.filters.concat(DROP_SHADOW_STRONG) ;
			}else {
				p.splice(DROP_SHADOW_STRONG) ;
				spr.filters = p ;
			}
		}
		///////////////////////////////////// BITMAP 
		public function scaleBitmap(bmp:Bitmap, w:int,h:int):Bitmap
		{
			if (!bmp.smoothing) bmp.smoothing = true ;
			var coords:Rectangle = getCoords(bmp.bitmapData, w, h) ;
			bmp.x = coords.x ;
			bmp.y = coords.y ;
			bmp.width = coords.width ;
			bmp.height = coords.height ;
			return bmp ;
		}
		public function getCoords(bmpd:BitmapData,w:int,h:int):Rectangle
		{
			var s:Rectangle = RatioPreserver.preserveRatio(new Rectangle(0,0,bmpd.width, bmpd.height), new Rectangle(0, 0, w, h),true) ;
			return s ;
		}
		
		///////////////////////////////// FOCUS
		public function setFocus(id:* = ''):void 
		{
			if (id is String) {
				__stage.focus = id == ''? null : $get('#' + id)[0] ;
			}else if(id is InteractiveObject){
				__stage.focus = id ;
			}
			if(__stage.focus != null) __lastFocused = __stage.focus ;
		}
		public function getFocus():InteractiveObject { return __stage.focus }
		
		///////////////////////////////// AS3QUERY
		public function $get(ref:*):as3Query
		{
			return XContext.$get(ref) ;
		}
		
		static public function get stage():Stage { return __stage }
		static public function set stage(value:Stage):void { __stage = value }
		static public function get target():Sprite { return __target }
		static public function set target(value:Sprite):void { __target = value }
		
		static public function get background():Sprite { return __background }
		static public function set background(value:Sprite):void { __background = value }
		static public function get lastFocused():InteractiveObject { return __lastFocused }
		static public function get focusIndex():int { return __focusIndex }
		static public function set focusIndex(value:int):void { __focusIndex = value }
		static public function get minFrame():Sprite { return __minFrame }
		static public function set minFrame(value:Sprite):void { __minFrame = value }
		static public function get frame():Sprite { return __frame }
		static public function set frame(value:Sprite):void { __frame = value }
		static public function get basicNav():Sprite { return __basicNav }
		static public function set basicNav(value:Sprite):void { __basicNav = value }
		static public function get depthNav():Sprite { return __depthNav }
		static public function set depthNav(value:Sprite):void { __depthNav = value }
		static public function get spaceNav():Sprite { return __spaceNav }
		static public function set spaceNav(value:Sprite):void { __spaceNav = value }
		
		static public function get externals():ApplicationDomain { return __externals}
		
	}
}