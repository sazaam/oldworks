package saz.geeks.sounds
{
	
	import flash.errors.*;
	import flash.geom.*;
	import flash.display.*;
	import flash.filters.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.utils.*;
	import flash.external.*;
	/**
	* @author saz
	*/
	public class SoundWave
	{
		private var channel			:SoundChannel
		private var control			:SoundTransform
		private var noFFTbytes		:ByteArray
		private var snd				:Sound
		private var req				:URLRequest
		private var lp				:Number
		private var rp				:Number
		private var output			:BitmapData
		private var outputBis		:BitmapData
		private var scene			:Sprite
		private var displace		:Matrix
		private var step			:Number
		private var steps			:int
		private var darken			:ColorTransform
		private var add				:ColorTransform
		private var bmp				:Bitmap
		private var bmpBis			:Bitmap
		private var filter			:BitmapFilter
		private var rect			:Rectangle
		private var pt				:Point
		private var rectForEffect	:Rectangle
		private var colors			:Array
		private var ratios			:Array
		private var alphas			:Array
		private var matrix			:Matrix
		private var angle			:Number
		private var gradient		:Array
		private var volumeending	:Number = 1

		
		
		
		
		

		public var wave:Sprite
		public var waveMiddle:Number
		public var maskk:Sprite
		public var source:String = ""

		
		public function SoundWave(_wave:Sprite,_source:String)
		{
			wave = _wave
			waveMiddle = wave.height/2
			output 					= new BitmapData(wave.width, wave.height, false, 0 );
			outputBis				= new BitmapData(wave.width, wave.height, false, 0 );
			darken 					= new ColorTransform( 1, 1, 1, 1, 0, -2, -3, 0 );
			add 					= new ColorTransform( 0,0, 1, 1, -1, -1, 0, 0 );
			displace 				= new Matrix();		
			steps					= 256;
			
			snd 					= new Sound();

			channel 				= new SoundChannel();
			
			// 
			initGraphics()
			
			if (_source) {
				load(_source)
				play()
			}
		}
		
		private function initGraphics():void
		{
			
			scene 					= new Sprite();
			//scene.blendMode 		= BlendMode.ADD;			
			wave.addChild(scene);
			//
			//bmpBis 					= new Bitmap( outputBis );
			//bmpBis.blendMode 		= BlendMode.ADD;
			//wave.addChild( bmpBis );
			bmp 					= new Bitmap( output );
			bmp.blendMode 			= BlendMode.ADD;
			wave.addChild( bmp );
			
			filter 					= new BlurFilter(2, 2, 2);
			rect					= new Rectangle(0,0,wave.width, wave.height);
			pt						= new Point(0, 0);
			rectForEffect 			= new Rectangle (0, 0, 1, 0);
			gradient = generateRadient();
			//
			colors = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
			alphas = [100, 0, 100, 0];
			ratios = [0, 85, 160, 255];
			matrix = new Matrix();
			matrix.createGradientBox ( wave.width, 1, 0, 0, 0);
			//
			wave.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		public function load(_source:String = null):void {
			trace(_source)
			source = _source || source
			req 					= new URLRequest(source);
			snd.load(req);
			//snd.addEventListener(Event.ID3,onID3)
		}
		//
		//private function onID3(e:Event):void 
		//{
			//trace("SOURCE : "+source)
		//}
		//
		public function play():void {
			channel = snd.play();
			//channel.addEventListener(Event.SOUND_COMPLETE , replay);
			volume(.7)
		}
		public function stop():void
		{
			snd.close()
		}
		public function volume(_newVol:Number):void
		{
			control = channel.soundTransform
			control.volume = _newVol
			channel.soundTransform = control
		}
		
		
		private function replay(e:Event):void {
			channel = snd.play();
		}
		
		public function onEnterFrame(e:Event):void {

			noFFTbytes 		= new ByteArray();	
			lp 				= channel.leftPeak;
			rp 				= channel.rightPeak;
			
			alphas[0] = rp;
			alphas[1] = lp/2;
			alphas[2] = lp;
			alphas[3] = rp / 3;
			
			
			
			SoundMixer.computeSpectrum(noFFTbytes, false, 2);
			
			effectTwo();
			effectOne();
			
			output.scroll(2.5, 0);
			outputBis.scroll(2, 0);
			output.draw(scene);
			//
			output.applyFilter(output, rect, pt, filter);
			output.draw( output, displace, add, BlendMode.NORMAL, null, true );
			outputBis.applyFilter(outputBis, rect, pt, filter);
			outputBis.draw( outputBis, displace, add, BlendMode.NORMAL, null, true );
			
		}
		private function effectOne() {
			var g:Graphics = scene.graphics;
			g.clear();
			g.lineStyle (2, 0x0);
			g.lineGradientStyle ( 'linear', colors, alphas, ratios, matrix, 'pad', 'linearRGB', 0.1);
			
			var myPoints:Array = new Array();
			var i:int = 64;
			try {
				while ( --i > -1 ) {
					noFFTbytes.position = i * 32;					
					var offset:Number = noFFTbytes.readFloat()*100;
					var myObj:Object = { x :  ( wave.width/64 )*i, y : waveMiddle+(-offset) };		
					myPoints[i] = myObj;	
				}
			} catch ( err:EOFError ) {trace("trop loin")}
			
			var arrayMidpoints:Array = new Array();
			for (var j:int = 1; j< myPoints.length; j++ ) {
				var midPointX:Number = ( myPoints[j].x + myPoints[j-1].x )/2
				var midPointY:Number = ( myPoints[j].y + myPoints[j-1].y )/2
				var midPointsObj:Object = { x : midPointX, y : midPointY };
				arrayMidpoints[j-1] = midPointsObj;
			}
			g.moveTo ( arrayMidpoints[0].x, arrayMidpoints[0].y );
			for (var k:int = 1; k< myPoints.length-1; k++ ) {
				g.curveTo ( myPoints[k].x, myPoints[k].y, arrayMidpoints[k].x, arrayMidpoints[k].y );
			}
		}
		
		
		private function effectTwo() {
			var i:Number = 128;
			try {
				while ( --i > -1 ) {
					noFFTbytes.position = i * 16;					
					var offset:int = noFFTbytes.readFloat()*(rp*200);
					rectForEffect.x = (8 * i);
					if ( offset >= 0 ) {
						rectForEffect.y = waveMiddle-offset;
						rectForEffect.height = offset;
						outputBis.fillRect ( rectForEffect, gradient[i]);
					} else {
						rectForEffect.y = waveMiddle;
						rectForEffect.height = -offset;
						outputBis.fillRect ( rectForEffect, gradient[i] )
					};
				}
			} catch (err:EOFError) {trace("trop loin")}
		}
		
		
		
		private function generateRadient ():Array{
			
			var gradient:Array = new Array();
			
			var shape:Shape = new Shape();
			var bitmapGradient:BitmapData = new BitmapData ( 256, 1, true, 0);
			
			//var colors: Array = [ 0x580600, 0xFFD3AB, 0xDB0202];
			var colors: Array = [0x003E99, 0x003E99, 0x003E99]; 
			var alphas: Array = [ 20, 30, 80 ];
			var ratios: Array = [ 20, 68, 192 ]; 
			
			var matrix: Matrix = new Matrix();
			
			matrix.createGradientBox( 128, 1, 0, 0 );
			
			shape.graphics.beginGradientFill( 'linear', colors, alphas, ratios, matrix, SpreadMethod.REPEAT );
			shape.graphics.drawRect( 0, 0, 256, 1 );
			shape.graphics.endFill();
			
			bitmapGradient.draw( shape );
			
			for( var i: int = 0 ; i < 256 ; i++ ) gradient[i] = bitmapGradient.getPixel32( i, 0 );
			
			return gradient;
			
		}
	}
}