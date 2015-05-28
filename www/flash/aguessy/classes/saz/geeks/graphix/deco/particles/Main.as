package {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	public class Main extends Sprite {
		
		private var bmp:Bitmap;
		private var bmpData:BitmapData;
		private var bmpBack:Bitmap;
		private var bmpDataBack:BitmapData;
		private var bmpPerlin:BitmapData;
		private var blur:BlurFilter;
		private var _particles:Array;
		private var timer:Timer;
		
		private var fpsClip:MovieClip
		private var fps:int = 0;
		
		private var numParticles:int = 5000;
		
		
		public function Main():void	{

			// creates a new five-second Timer
			var timer:Timer = new Timer(1000, 9999);
			// designates listeners for the interval event and the completion event
			timer.addEventListener(TimerEvent.TIMER, onTick);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			// starts the timer ticking
			timer.start();

			bmpPerlin = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x000000);
			bmpPerlin.perlinNoise(100, 100, 3, Math.round(Math.random()*100), false, true);
			addChildAt(new Bitmap(bmpPerlin), 0);
			
			bmpDataBack = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x000000);
			bmpBack = new Bitmap(bmpDataBack);
			addChildAt(bmpBack, 1);

			bmpData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			bmp = new Bitmap(bmpData);
			bmp.blendMode = "add";
			addChildAt(bmp, 2);
			
			_particles = [];
			blur = new BlurFilter(4, 4, 3);
			
			// generate particles
			for(var i:int=0; i<numParticles; i++) {
				var p:Particle = new Particle(stage.stageWidth/2, stage.stageHeight/2);
				_particles.push(p);
			}
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			
			fpsClip = new FpsTimer();
			addChild(fpsClip);
			fpsClip.x = 10;
			fpsClip.y = 10;
			fpsClip.txt.text = "0";
		}
		
		private function onClick(evt:MouseEvent):void {
			bmpPerlin.perlinNoise(100, 100, 3, Math.round(Math.random()*100), false, true);
		}
		
		private function onKeyPress(evt:KeyboardEvent):void {
			bmpBack.visible = !bmpBack.visible;
		}
		
		private function onTick(evt:TimerEvent):void {
			// displays the tick count so far
			// The target of this event is the Timer instance itself.
			//trace("tick " + evt.target.currentCount);
			fpsClip.txt.text = fps;
			fps = 0;
		}
		
		private function onTimerComplete(evt:Event):void {
			trace("Time's Up!");
		}
		
		private function onEnterFrame(evt:Event):void {
			
			++fps;
			
			bmpData.fillRect(bmpData.rect, 0x00000000);
			
			var p:Particle;
/*
			if(_particles.length < numParticles) {
				p = new Particle(stage.stageWidth/2, stage.stageHeight/2);
				_particles.push(p);
			}
*/
			var i:int = _particles.length;
			while(--i > -1) {
				p = _particles[i];
				bmpData.setPixel32(p.x, p.y, p.color);
				p.move(bmpPerlin.getPixel(p.x, p.y));
/*
				if(p.life == 0) {
					_particles.splice(i, 1);
					delete p;
				}
*/
			}

			bmpDataBack.draw(bmpData, new Matrix(), new ColorTransform(), "add");
			bmpDataBack.applyFilter(bmpDataBack, bmpData.rect, new Point(0, 0), blur);
		}
	}
	
	public class Particle {
		
		private var w:uint = 600;
		private var h:uint = 350;
		
		public var x:Number;
		public var y:Number;
		public var vx:Number;
		public var vy:Number;
		public var color:uint = 0xFF1FA539;
		public var life:uint;
		
		public function Particle(_x:Number, _y:Number):void {
			x = _x;
			y = _y;
			vx = 5*(Math.random()-Math.random());
			vy = 5*(Math.random()-Math.random());
			life = 500+Math.round(Math.random()*500);
		}
		
		public function move(_value:uint):void {
			
			var r:uint = _value >> 16;
			var g:uint = _value >> 8 & 255;
			var b:uint = _value & 255;
			
			vx += (r-b)/100;
			vy += (g-b)/100;
			
			// clip
			vx = Math.min(vx, 5);
			vy = Math.min(vy, 5);
			vx = Math.max(vx, -5);
			vy = Math.max(vy, -5);
			
			x += vx;
			y += vy;
			
			if(x < 0 || x > w) {
				vx *= -1;
			}
			
			if(y < 0 || y > h) {
				vy *= -1;
			}

			//life -= 1;
			r = (x / w) * 255;
			g = (y / h) * 255;
			b = Math.abs(Math.round((vx+vy)))*10;
			color = (255 << 24 | r << 16 | g << 8 | b);
		}
	}
}
