package testing 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.tweens.ITween;
	import pro.graphics.TestParticles;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	import tools.math.Random;
	/**
	 * ...
	 * @author saz
	 */
	public class TextFX
	{
		private var __target:Sprite;
		private var mainTw:ITween;
		
		static public const TOTAL_PARTICLES:int = 50;
		
		public function TextFX(tg:Sprite) 
		{
			__target = tg ;
			init() ;
		}
		
		private function init():void 
		{
			trace(this) ;
			
			var smart:Smart = Smart(__target.addChild(createItem())) ;
			smart.addEventListener(MouseEvent.ROLL_OVER, onOver) ;
			smart.addEventListener(MouseEvent.ROLL_OUT, onOver) ;
		}
		
		private function onOver(e:MouseEvent):void 
		{
			var smart:Smart = Smart(e.target) ;
			if (e.type == MouseEvent.ROLL_OVER) {
				launchTweens(smart) ;
				setText(smart) ;
				//trace('over >>', e) ;
			}else {
				launchTweens(smart, false) ;
				setText(smart, false) ;
				//trace('out >>', e) ;
			}
		}
		
		private function setText(smart:Smart, cond:Boolean = true):void 
		{
			var tf:TextField = smart.properties.tf ;
			var fmt:TextFormat = tf.defaultTextFormat ;
			if (cond) {
				fmt.color = 0xFFFFFF;
			}else {
				fmt.color = 0x454545;
			}
			tf.setTextFormat(fmt) ;
		}
		
		private function createItem():Smart
		{
			var smart:Smart = new Smart() ;
			
			// create TextField
			var stf:Sprite = Sprite(smart.addChild(new Sprite())) ;
			
			var tf:TextField = smart.properties.tf = createTextField() ;
			setText(smart) ;
			var margin:int = 5 ;
			tf.x = margin ;
			tf.y = margin ;
			Draw.draw('rect', { g:smart.graphics, color:0x996633, alpha:0 }, 0,0, tf.width + margin * 2, tf.height + margin * 2) ;
			smart.x = 200 ;
			smart.y = 200 ;
			
			stf.addChild(tf) ;
			
			// create output Bmp
			var bmp:Bitmap = smart.properties.bmp = createBitmap(smart) ;
			bmp.y -= 50 ;
			smart.hitArea = stf ;
			smart.mouseChildren = false ;
			// create particles Array
			var particles:Array = createParticles(smart) ;
			
			smart.addChild(bmp) ;
			smart.addChild(stf) ;
			
			
			return smart ;
		}
		
		private function launchTweens(smart:Smart, cond:Boolean = true):void 
		{
			if (cond) {
				var p:Array = smart.properties.particles ;
				var l:int = p.length ;
				var tweens:Array = [] ;
				for (var i:int = 0 ; i < l ; i++ ) {
					var pi:Particle = Particle(p[i]) ;
					var t:ITween = BetweenAS3.to(pi, {x:pi.x} ,1) ;
					tweens[tweens.length] = t ;
					t.stopOnComplete = false ;
					t.onUpdate = onUpdate ;
					t.onUpdateParams = [pi, smart] ;
				}
				mainTw = BetweenAS3.parallelTweens(tweens) ;
				
				mainTw.onUpdate = drawParticles ;
				mainTw.onUpdateParams = [smart] ;
				
				mainTw.stopOnComplete = false ;
				mainTw.play() ;
			}else {
				
				mainTw.stop() ;
				mainTw = null ;
				drawBitmap(smart, false) ;
			}
		}
		
		private function onUpdate(p:Particle, smart:Smart):void 
		{
			var bmp:Bitmap = Bitmap(smart.properties.bmp) ;
			p.moveTo(new Point(Random.gaussian() * 2 + p.x, p.y + 2)) ;
			if (p.y > (bmp.height-4)) {
				p.y = 2 + Random.random()*5 ;
				p.x = 5 + Random.random() * (bmp.width-10) ;
			}
			if (p.y < 2) {
				p.y += 2 + Random.random()*5 ;
				p.x = 5 + Random.random() * (bmp.width-10) ;
			}
			if (p.x < 0 ) {
				p.x = bmp.width ;
			}
			if (p.x > bmp.width) {
				p.x = 0 ;
			}
		}
		
		private function createParticles(smart:Smart):Array
		{
			var p:Array = smart.properties.particles = [] ;
			var b:BitmapData = smart.properties.bmp.bitmapData ; 
			var l:int = TOTAL_PARTICLES ;
			for (var i:int = 0 ; i < l ; i++ ) {
				var particle:Particle = p[p.length] = new Particle(
					5 + (Random.gaussian() * (b.width / 8) + (b.width - 10) / 2), 
					2 + Random.random() * (b.height - 4), 
					2 + Math.random() * 3
				) ;
			}
			drawParticles(smart) ;
			drawBitmap(smart, false) ;
		}
		
		private function drawParticles(smart:Smart):void 
		{
			var b:BitmapData = smart.properties.bmp.bitmapData ;
			var p:Array = smart.properties.particles ;
			var l:int = p.length ;
			
			b.fillRect(new Rectangle(0,0,b.width, b.height),0x00) ;
			
			
			for (var i:int = 0 ; i < l ; i++ ) {
				var particle:Particle = p[i] ;
				particle.drawTo(b) ;
			}
			
			var r:Rectangle = new Rectangle(0, 0, b.width, b.height) ;
			var pt:Point = new Point() ;
			
			//b.applyFilter(b, r, pt, new BlurFilter(2, 10, 3)) ;
			drawBitmap(smart) ;
		}
		
		private function createBitmap(smart:Smart):Bitmap
		{
			var bmp:Bitmap = smart.properties.bmp = new Bitmap(null, 'auto', true) ;
			bmp.bitmapData = new BitmapData(smart.width, smart.height+50, true, 0x0) ;
			drawBitmap(smart) ;
			return bmp ;
		}
		
		private function drawBitmap(smart:Smart, opaque:Boolean = true):void 
		{
			var tf:TextField = smart.properties.tf ;
			var bmp:Bitmap = smart.properties.bmp ;
			var rect:Rectangle = new Rectangle(tf.x, tf.y, tf.width, tf.height) ;
			
			if (!opaque) {
				bmp.bitmapData.fillRect(new Rectangle(0,0,bmp.width, bmp.height),0x0) ;
			}
			//bmp.bitmapData.draw(tf, new Matrix(1,0,0,1,tf.x, tf.y), null, null, null, true) ;
		}
		
		private function createTextField():TextField
		{
			var tf:TextField = new TextField() ;
			var fmt:TextFormat = tf.defaultTextFormat ;
			fmt.font = 'Neo Tech Dacia Regular' ;
			fmt.size = 14 ;
			fmt.align = 'center';
			//tf.wordWrap = true ;
			tf.autoSize = 'left' ;
			fmt.leftMargin = fmt.rightMargin = 15 ;
			tf.defaultTextFormat = fmt ;
			//tf.selectable = false ;
			tf.text = 'ACTION' ;
			return tf ;
		}
	}
}



import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import tools.math.Random;

class Particle {
	////////////////////////////////////////////////// VARS
	private var __x:Number;
	private var __y:Number;
	private var __coords:Point;
	private var __data:BitmapData;
	private var __color:uint;
	private var __size:uint;
	private var __dims:Rectangle;
	////////////////////////////////////////////////// CTOR
	public function Particle(x:Number = 0, y:Number = 0, size:uint = 4, color:uint = 0xD01A1A)
	{
		__x = x ;
		__y = y ;
		__size = size ;
		__color = color ;
		__speed = Random.random() * 2 + 2 ;
		__data = new BitmapData(size, size, false, color) ;
		__coords = new Point(__x, __y) ;
		__dims = new Rectangle(0, 0, size, size) ;
	}
	public function moveTo(p:Point):void {
		__x = p.x ;
		__y = p.y + __speed ;
		__coords = p ;
	}
	public function drawTo(b:BitmapData):void {
		
		b.copyPixels(__data, __dims, __coords) ;
	}
	////////////////////////////////////////////////// GETTERS & SETTERS
	public function get x():Number { return __x }
	public function set x(value:Number):void { __x = value }
	public function get y():Number { return __y }
	public function set y(value:Number):void { __y = value }
}

















