package tools.grafix 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gs.TweenLite;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Back;
	import org.libspark.betweenas3.tweens.ITween;
	
	/**
	 * ...
	 * @author saz
	 */
	public class BloopEffect 
	{
		private var __params:Object;
		
		public function BloopEffect(_input:DisplayObject, _segmentW:int, _segmentH:int = 0) 
		{
			__params = { width :_input.width, height:_input.height, segmentW:_segmentW, segmentH:_segmentH == 0 ? _segmentW : _segmentH, output:new Sprite()} ;
			init() ;
			setBitmap(_input) ;
		}
		
		public function setBitmap(input:DisplayObject):BloopEffect
		{
			if (input is Bitmap) {
				__params.input = __params.bmp = new Bitmap(Bitmap(input).bitmapData.clone(), 'auto', true) ;
			}else if (input is DisplayObject) {
				__params.input = __params.bmp = toBitmap(input) ;
			}
			__params.x = input.x ;
			__params.y = input.y ;
			__params.bmp.x = __params.x ;
			__params.bmp.y = __params.y ;
			draw() ;
			return this ;
		}
		
		public function toBitmap(s:DisplayObject):Bitmap
		{
			var bmp:Bitmap = new Bitmap(new BitmapData(s.width, s.height, true, 0x0), "auto", true) ;
			
			var m:Matrix = new Matrix() ;
			var r:Rectangle = s.getRect(s) ;
			m.translate( -r.x, -r.y) ;
			r.offset(-r.x, -r.y) ;
			bmp.bitmapData.draw(s, m, null, null, r, true) ;
			
			return bmp ;
		}
		
		private function init():void
		{
			__params.segmentation = new Segment(__params.width, __params.height, __params.segmentW, __params.segmentH) ;
		}
		public function show(x:Number, y:Number, delayMult:Number = -1, closure:Function = null, ...args:Array):void
		{
			if(!__params.output.hasEventListener(Event.ENTER_FRAME)) __params.output.addEventListener(Event.ENTER_FRAME, onFrame) ;
			anim.apply(null, [x, y, false, delayMult, closure].concat(args)) ;
		}
		public function hide(x:Number, y:Number, delayMult:Number = -1, closure:Function = null, ...args:Array):void
		{
			if(!__params.output.hasEventListener(Event.ENTER_FRAME)) __params.output.addEventListener(Event.ENTER_FRAME, onFrame) ;
			anim.apply(null, [x, y, true, delayMult, closure].concat(args)) ;
		}
		public function reset():void
		{
			for (j = 0; j <= __params.segmentH ; j++) {
				for (i = 0; i <= __params.segmentW ; i++) {
					__params.segmentation.vertex[j][i] = new Point( __params.width  >> 1,  __params.height  >> 1) ;
				}
			}
			draw() ;
			__params.hidden = true ;
		}
		public function toggle(x:Number, y:Number, delayMult:Number = -1, closure:Function = null, ...args:Array):void
		{
			if (!__params.hidden) hide.apply(null, [x, y, delayMult, closure].concat(args)) else show.apply(null, [x, y, delayMult, closure].concat(args)) ;
		}
		private function onFrame(e:Event):void 
		{
			draw() ;
		}
		private function anim(x:Number, y:Number,cond:Boolean = true, delayMult:Number = -1, f:Function = null, ...args:Array):void
		{
			if (delayMult == -1) delayMult = 40 ;
			
			var tweens:Array = [] ;
			var i:int, j:int ;
			
			var px:Number = __params.segmentW * (x / __params.width) ;
			var py:Number = __params.segmentH * (y / __params.height) ;
			if (cond) {
				// OUT
				for (j = 0; j <= __params.segmentH ; j++) {
					for (i = 0; i <= __params.segmentW ; i++) {
						__params.segmentation.vertex[j][i] = new Point(i * __params.width / __params.segmentW, j * __params.height /__params.segmentH) ;
						delay = Math.sqrt((i - px) * (i - px) + (j - py) * (j - py)) / delayMult ;
						tweens.push(
							BetweenAS3.delay(
								BetweenAS3.tween(__params.segmentation.vertex[j][i], {
									x : px * __params.width / __params.segmentW,
									y : py * __params.height / __params.segmentH
								},null, delay, Back.easeOut),
								delay / 2))
					}
				}
				
				__params.hidden = true ;
			}else {
				// BACK IN
				var max:Number = 0 ;
				for (j = 0; j <= __params.segmentH ; j++) {
					for (i = 0; i <= __params.segmentW ; i++) {
					__params.segmentation.vertex[j][i] = new Point(px * __params.width / __params.segmentW, py * __params.height / __params.segmentH) ;
					delay = Math.sqrt((i - px) * (i - px) + (j - py) * (j - py)) ;
					max = Math.max(max, delay) ;
					}
				}
				for (j = 0 ; j <= __params.segmentH ; j++) {
					for (i = 0; i <= __params.segmentW ; i++) {
						delay = (max - Math.sqrt((i - px) * (i - px) + (j - py) * (j - py))) / delayMult ;
						tweens.push(
							BetweenAS3.delay(
								BetweenAS3.tween(__params.segmentation.vertex[j][i], {
									x : i * __params.width / __params.segmentW,
									y : j * __params.height / __params.segmentH
								},null, delay, Back.easeOut),
								delay / 2))
					}
				}
				__params.hidden = false ;
			}
			var itw:ITween = BetweenAS3.parallelTweens(tweens) ;
			
			itw.onComplete = function():void {
				if (__params.output.hasEventListener(Event.ENTER_FRAME)) __params.output.removeEventListener(Event.ENTER_FRAME, onFrame) ;
				if (Boolean(f)) f.apply(this, args) ;
			}
			itw.play() ;
		}
		
		public function appendTo(s:DisplayObjectContainer):Sprite
		{
			return Sprite(s.addChild(__params.output)) ;
		}
		public function removeFrom(s:DisplayObjectContainer):void
		{
			s.removeChild(__params.output) ;
		}
        public function draw():void 
		{
			var vertices:Vector.<Number> = new Vector.<Number>() ;
			var indices:Vector.<int> = __params.segmentation.indices ;
			var uvtData:Vector.<Number> = __params.segmentation.uvDatas ;
			
			for (var j:int = 0 ; j <= __params.segmentH ; j++ ) {
				for (var i:int = 0 ; i <= __params.segmentW ; i++ ) {
					var pt:Point = __params.segmentation.vertex[j][i] ;
					vertices.push(pt.x, pt.y) ;
				}
			}
			
			var g:Graphics = __params.output.graphics ;
			g.clear() ;
			g.beginBitmapFill(__params.bmp.bitmapData) ;
			g.drawTriangles(vertices, indices, uvtData) ;
			g.endFill() ;
        }
		
		public function destroy():BloopEffect 
		{
			__params = destroyParams() ;
			
			return null ;
		}
		
		private function destroyParams():Object
		{
			for (var i:String in __params) {
				delete params[i] ;
			}
			return null ;
		}
		
		public function get params():Object { return __params }
		public function get input():DisplayObject { return __params.input }
		public function set input(value:DisplayObject):void { setBitmap(value) }
		public function get output():Sprite { return __params.output }
		public function get segmentation():Segment { return __params.segmentation }
		public function get hidden():Boolean { return __params.hidden }
		
		public function get bmp():Sprite { return __params.bmp}
		
	}
	
}