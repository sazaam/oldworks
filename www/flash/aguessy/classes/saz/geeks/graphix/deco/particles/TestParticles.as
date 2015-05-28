package saz.geeks.graphix.deco.particles 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import caurina.transitions.Tweener
	import saz.helpers.math.Random
	import caurina.transitions.*
	import caurina.transitions.properties.*
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class TestParticles extends Sprite{

		private var bmp:Bitmap;
		private var bmpData:BitmapData;
		private var bmpBack:Bitmap;
		private var bmpDataBack:BitmapData;
		private var bmpPerlin:BitmapData;
		private var blur:BlurFilter;
		private var blur2:BlurFilter;
		private var shade:DropShadowFilter;
		private var _particles:Array;
		
		private var numParticles:int = 20000;
		private var Times:int;
		private var CLIP:Sprite;
		
		
		public function TestParticles():void	{
			FilterShortcuts.init()
			
		
			CLIP = addChild(new Sprite()) as Sprite
			Tweener.addTween(CLIP, {_DropShadow_alpha:1,_DropShadow_angle:90,_DropShadow_strength:5,_DropShadow_quality:3,_DropShadow_color:0x000000,_DropShadow_blurX:80,_DropShadow_blurY:80,_DropShadow_distance:0,_DropShadow_inner:true} );
			CLIP.blendMode = BlendMode.ADD
			//bmpPerlin = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x000000);
			bmpPerlin = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x000000);
			//bmpPerlin.perlinNoise(100, 100, 3, Math.round(Math.random()*100), false, true);
			
			//bmpPerlin.perlinNoise(800, 600, 1, 1, false, true);
			bmpPerlin.perlinNoise(Random.gaussian()*800, Random.gaussian()*600, 1, Random.gaussian(), false, true,7,false);
			
			
			CLIP.addChild(new Bitmap(bmpPerlin));
			
			bmpDataBack = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x000000);
			bmpBack = new Bitmap(bmpDataBack);
			CLIP.addChild(bmpBack);

			bmpData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			bmp = new Bitmap(bmpData);
			bmp.blendMode = "add";
			CLIP.addChild(bmp);
			_particles = [];
			blur = new BlurFilter(4, 4, 2);
			//shade = new DropShadowFilter(0,90,0,1,50,50,1,2,true);
			//blur2 = new BlurFilter(50, 50, 1);
			
			// generate particles
			for(var i:int=0; i<numParticles; i++) {
				var p:Particle = new Particle(stage.stageWidth/2, stage.stageHeight/2);
				//var p:Particle = new Particle(Random.gaussian()*(stage.stageWidth/2), Random.gaussian()*(stage.stageHeight/2));
				//var p:Particle = new Particle(0, stage.stageHeight/2);
				_particles.push(p);
			}
			addEventListener(Event.ENTER_FRAME, onFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		}
		
		private function onKeyPress(evt:KeyboardEvent):void {
			bmpBack.visible = !bmpBack.visible;
		}
		
		private function onFrame(evt:Event):void {
			bmpData.fillRect(bmpData.rect, 0x00000000);
			
			if (Times % 100 == 1){
				bmpPerlin.perlinNoise(Random.gaussian()*800, Random.gaussian()*600, 1, Random.gaussian(),false, true,7,false);
			}
			
			var p:Particle;
/*
			if(_particles.length < numParticles) {
				p = new Particle(stage.stageWidth/2, stage.stageHeight/2);
				_particles.push(p);
			}
*/
			var i:int = _particles.length;
			while(--i > -1) {
				p = _particles[i] as Particle;
				bmpData.setPixel32(p.x, p.y, p.color);
				p.move(bmpPerlin.getPixel(p.x, p.y));
				//p.move(bmpPerlin.getPixel(Random.uniform()[0]*p.x, Random.uniform()*p.y));
				//bmpPerlin.set
/*
				if(p.life == 0) {
					_particles.splice(i, 1);
					delete p;
				}
*/
			}
			
			//bmpDataBack.draw(bmpData, new Matrix(), new ColorTransform(), "add");
			bmpDataBack.applyFilter(bmpData, bmpData.rect, new Point(0, 0), blur);
			Times ++
		}
	}
}