package flashgrafix 
{
	import asSist.$;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import frocessing.core.F5Graphics3D;
	import frocessing.display.F5MovieClip3D;
	import frocessing.f3d.F3DModel;
	import frocessing.f3d.models.F3DCube;
	import frocessing.f3d.models.F3DPlane;
	import frocessing.f3d.models.F3DSphere;
	import frocessing.geom.FNumber3D;
	import gs.TweenLite;
	import mvc.behavior.commands.Wait;
	import saz.geeks.graphix.deco.Typographeur;
	import saz.helpers.layout.layers.Layer;
	import saz.helpers.layout.layers.LayerSystem;
	import saz.helpers.loadlists.loaders.AllLoader;
	import saz.helpers.math.Constraint;
	import saz.helpers.math.Percent;
	import saz.helpers.math.Random;
	import saz.helpers.text.Text3D;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestLoader extends Sprite
	{
		public var FONTS:Array = [] ;
		public var XMLS:Array = [] ;
		public var SWF:Array = [] ;
		private var layerSystem:LayerSystem;
		private var ind:int;
		private var p:F3DCube;
		private var v:F3DPlane;
		private var sph:F3DSphere;
		private var planes:Array;
		private var togoAngle:int;
		private var cubeClip:F5MovieClip3D;
		
		public function TestLoader() 
		{
			$(stage).attr( { scaleMode: "noScale", align: "TL" } ) ;
			alpha = 0 ;
			$(this).bind(Event.ADDED_TO_STAGE, onStage) ; 
		}
		
		private function onStage(e:Event):void
		{
			if (AllLoader.inited) {
				AllLoader.resume() ;
				AllLoader.loader.addEventListener( Event.COMPLETE, onFinishLoading ) ;
			}else {
				var allLoader:AllLoader = new AllLoader(this, AllLoader.loaderGraphics) ;
				AllLoader.loader.addEventListener( Event.COMPLETE, onFinishLoading ) ;
				allLoader.launch() ;
			}
			$(this).unbind(Event.ADDED_TO_STAGE, onStage) ;
		}
		
		private function onFinishLoading(e:Event):void
		{
			XMLS = AllLoader.content.XMLS ;
			FONTS = AllLoader.content.FONTS ;
			SWF = AllLoader.content.SWF ;
			trace("main COMPLETE") ;
			var xml:XML = AllLoader.content.XMLS[0] as XML ;
			$(xml).appendTo(this) ;
			layerSystem = new LayerSystem([new Layer("sazaam",new F5MovieClip3D()), new Layer("ornorm", new Sprite())], 0xFFFFFF, .8) ;
			intro() ;
		}
		private function intro():void
		{
			//trace(new FONTS["IMPACT"]().fontName)
			trace($('#sazaam'))
			$('#sazaam').each(function(i:int, el:TextField) {
					//var tf1:TextFormat = el.getTextFormat() ;
					//var tf2:TextFormat = new TextFormat(Font(new FONTS["IMPACT"]()).fontName,155,0xFFFFFF,true) ;
					//tf2.bold = true ;
					//el.setTextFormat(tf1, 0, 3) ;
					//el.setTextFormat(tf2, 3, el.text.length) ;
			})
			
			$('#enter').bind(MouseEvent.CLICK, onTextClicked) ;
			TweenLite.to(this, .4, { alpha:1 } ) ;
		}
		
		private function onTextClicked(e:MouseEvent):void
		{
			$('#enter').unbind(MouseEvent.CLICK, onTextClicked) ;
			var s:TextField = $('#sazaam')[0]  as TextField ;
			var f = s.filters[0] ;
			TweenLite.to(f, 1, { blurX:0, blurY:0, onUpdate:function() { s.filters = [f] }, onUpdate:function() { s.filters = [] }} ) ;
			//layerSystem.show("sazaam") ;
			cubeClip = addChildAt(new F5MovieClip3D(),0) as F5MovieClip3D ;
			
			//setCube() ;
			//setLogo() ;
			setCard() ;
			//setSphere() ;
			//setPlanes() ;
		}
		
		private function setLogo():void
		{
			
		}
		
		

		private function setPlanes():void
		{
			planes = [] ;
			
			var size:int = 200 ;
			var totw:int = stage.stageWidth ;
			var toth:int = stage.stageHeight ;
			var cols:int = totw / size ;
			var rows:int = toth / size ;
			var length = cols * rows ;
			
			var fm3d:F5MovieClip3D = cubeClip ;
			var t:Class = SWF[0].loaderInfo.applicationDomain.getDefinition('stone') ;
			var bmpStone:BitmapData = new t(100, 100) as BitmapData ;
			
			var g:F5Graphics3D = fm3d.fg ;
			v = new F3DPlane(200, 200, 6, 6) ;
			v.setColor(0x0, .7) ;
			//v.setTexture(bmpStone, bmpStone);
			
			g.beginDraw();
					g.noLineStyle() ;
					g.translate(size/2,size/2) ;
					//g.translate(stage.stageWidth/2,stage.stageHeight/2) ;
					for (var i:int = 0 ; i < length ; i++ )
					{
						var v2:F3DModel = v.copy() ;
						v2.position(int(i % cols) * (size), int(i / cols) * (size), 1) ;
						g.model(v2);
						planes.push(v2) ;
					}
			g.endDraw();
			fm3d.addEventListener(MouseEvent.CLICK,onPlanesClicked)
		}
		
		private function onPlanesClicked(e:MouseEvent):void 
		{
			ind = 0 ;
			togoAngle = planes.length*2 ;
			addEventListener(Event.ENTER_FRAME, onFrame)
		}
		
		private function onFrame(e:Event):void 
		{
			var _x:int = stage.stageWidth - mouseX ;
			var _y:int = stage.stageHeight - mouseY ;
			
			var fm3d:F5MovieClip3D = cubeClip ;
			var g:F5Graphics3D = fm3d.fg ;
			var size:int = 200 ;
			g.beginDraw();
				g.noLineStyle() ;
				g.translate(size/2,size/2) ;
				for (var j:int = 0 ; j < planes.length ; j++ )
				{
					var v:F3DModel = F3DModel(planes[j]) ;
					if (j == ind) {
						v.rotateX(2/4);
					}else if(j < ind && j >=  ind - planes.length/2){
						v.rotateX(1/4);
						v.rotateY(1 / 15);
						//v.x += 5 ;
						//v.yow(1/4)
						//v.postureY = new FNumber3D(1/4,1 / 15,1 / 15) ;
					}
					g.model(v);
				}
			g.endDraw();
			if (ind == togoAngle) {
				removeEventListener(Event.ENTER_FRAME, onFrame) ;
			}else {
				ind++ ;
			}
		}
		
		
		
		
		
		
		
		
		
		
		private function setCard():void 
		{
			var front:Class = SWF[0].loaderInfo.applicationDomain.getDefinition('frontCard') ;
			var back:Class = SWF[0].loaderInfo.applicationDomain.getDefinition('backCard') ;
			var bmpFront:BitmapData = new front(277, 116) as BitmapData ;
			var bmpBack:BitmapData = new BitmapData(277, 116, false, 0x0) ;
			var invertedBack:BitmapData = new back(277, 116) as BitmapData ;

			//var flippedMatrix:Matrix = new Matrix(1, 0, 0, -1, 0, 116);
			var flippedMatrix:Matrix = new Matrix(-1, 0, 0, 1, 277, 0);
			//flippedMatrix
			bmpBack.draw(new Bitmap(invertedBack, "auto", true ),flippedMatrix) ;
			//p = new F3DCube(277, 116, 0, 6, 6, 6) ;
			v = new F3DPlane(277,116, 6, 6) ;
			//p = new F3DCube(277,116, 0, 6, 6, 6) ;
			//p.setTexture(bmpStone, bmpStone);
			v.setTexture(bmpFront,bmpBack)
			v.material.backFace = true ; 
			var fm3d:F5MovieClip3D = cubeClip;
			var g:F5Graphics3D = F5Graphics3D (fm3d.fg) ;
			
			addEventListener(Event.ENTER_FRAME, function(e:Event){
				var _x:int = (stage.stageWidth / 2) - mouseX ;
				var _y:int = (stage.stageHeight / 2) - mouseY ;
					g.beginDraw();
					g.noLineStyle()
						g.translate(stage.stageWidth / 2, stage.stageHeight / 2) ;
						//g.camera(0,0,0,0,0,0,0,0,0)
						
						//g.rotateY(_x / 100) ;
						//g.rotateX( _y / 700) ;
						//g.rotateY(ind / 70) ;
						//g.rotateX(-ind / 30) ;
						v.rotateY( Percent.percent( -_x ,stage.stageWidth)/2 )
						//v.rotateX(.05)
						v.rotateX( Percent.percent( _y ,stage.stageHeight)/2)
						g.model(v);
						//g.model(p);
					g.endDraw();
				if(ind < 359)
				ind++
				else {
					ind++
				}
			});
		}
		
		
		private function setSphere():void 
		{
			var t:Class = SWF[0].loaderInfo.applicationDomain.getDefinition('stone') ;
			var bmpStone:BitmapData = new t(100, 100) as BitmapData ;
			sph = new F3DSphere(80, 20) ;
			sph.setTexture(bmpStone, bmpStone) ;
			var fm3d:F5MovieClip3D = cubeClip;
			addEventListener(Event.ENTER_FRAME, function(e:Event){
				var g:F5Graphics3D = fm3d.fg ;
				var _x:int = stage.stageWidth - mouseX ;
				var _y:int = stage.stageHeight - mouseY ;
					g.beginDraw();
					g.noLineStyle()
						g.translate(stage.stageWidth/2,stage.stageHeight/2) ;
						g.rotateY(ind / 70) ;
						//g.rotateX(-ind / 30) ;
						g.model(sph);
					g.endDraw();
				if(ind < 359)
				ind++
				else {
					ind++
				}
			});
		}	
		
		
		private function setCube():void 
		{
			var t:Class = SWF[0].loaderInfo.applicationDomain.getDefinition('stone') ;
			var bmpStone:BitmapData = new t(100, 100) as BitmapData ;
			p = new F3DCube(200, 200, 200, 6, 6, 6) ;
			
			//var Typo:Typographeur = new Typographeur("L’association 1KSABLE") ;
			//trace(Typo)
			//t.type = "pixel" ;
			//t.type = "box" ;
			//Typo.type = "text" ;
			//var thresh:int = 256 ;
			//var thresh:int = 300 ;
			//Typo.threshold = thresh ;
			//Typo.flipValues() ;
			//trace(Typo) ;
			//t.prepare(bmpd)
			//passe le bmpd au typographeur
			//t.fromBitmap( bmpd, 1, 10, 5, 1) ;
			//t.fromBitmap( bmpd, 1, 10, 1, 5) ;
			//Typo.fromBitmap( bmpd, 1,10, 2, 20,true) ;
			
			p.setTexture(bmpStone, bmpStone);
			
			var fm3d:F5MovieClip3D = cubeClip;
			addEventListener(Event.ENTER_FRAME, function(e:Event){
				var g:F5Graphics3D = fm3d.fg ;
				var _x:int = stage.stageWidth - mouseX ;
				var _y:int = stage.stageHeight - mouseY ;
					g.beginDraw();
					g.noLineStyle()
						g.translate(stage.stageWidth/2,stage.stageHeight/2) ;
						g.rotateY(ind / 70) ;
						g.rotateX(-ind / 30) ;
						g.model(p);
					g.endDraw();
				if(ind < 359)
				ind++
				else {
					ind++
				}
			});
		}
		
		
	}
	
}