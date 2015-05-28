package cv.grafix 
{
	
	import asSist.$ ;
	import cv.deposit.Deposit ;
	import cv.exec.Executer ;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary ;
	import flash.display.Bitmap ;
	import flash.display.BitmapData ;
	import flash.display.Stage ;
	import flash.events.Event ;
	import flash.geom.Matrix ;
	import frocessing.core.F5Graphics3D ;
	import frocessing.display.F5MovieClip3D ;
	import frocessing.f3d.F3DModel ;
	import frocessing.f3d.models.F3DCube ;
	import frocessing.f3d.models.F3DPlane ;
	import frocessing.f3d.models.F3DSphere ;
	import frocessing.geom.FNumber3D ;
	import gs.TweenLite;
	import modules.foundation.Type;
	import org.libspark.utils.ArrayUtil;
	import sketchbook.colors.ColorUtil;

	import saz.helpers.loadlists.loaders.E.LoadEvent ;
	import saz.helpers.loadlists.loaders.E.LoadProgressEvent ;
	import saz.helpers.loadlists.loaders.MultiLoader ;
	import saz.helpers.loadlists.loaders.MultiLoaderRequest ;
	import saz.helpers.loadlists.loaders.XLoader ;
	import saz.helpers.math.Percent;
	import saz.helpers.sprites.Smart ;
	import saz.helpers.stage.StageProxy ;

	/**
	 * ...
	 * @author saz
	 */
	public class Navigation3DSection 
	{
		
		//////////////////////STRUCTURE
		private var aaa_structure:XML = <flash.display.Sprite id="all" name="all">
																		<flash.display.Sprite id="background" name="background" />
																		<flash.display.Sprite id="grid" name="grid" />
																		<flash.display.Sprite id="content" name="content" />
																		<flash.display.Sprite id="space" name="space" >
																			<frocessing.display.F5MovieClip3D id="spacebackground" name="spacebackground" />
																			<flash.display.Sprite id="spacenav" name="spacenav" />
																		</flash.display.Sprite>
																		<flash.display.Sprite id="logo" name="logo" />
																		<flash.display.Sprite id="nav" name="nav" y="30" />
																		<frocessing.display.F5MovieClip3D id="card" name="card" visible="false" />
																	</flash.display.Sprite> ;
		//////////////////////TEXTFORMATS
		private var aaa_nav_3D_item_tf:XML = <flash.text.TextField name="txt" gridFitType="pixel" antiAliasType="advanced" selectable="false" text="image" autoSize="left" width="200" multiline="true">
																		<defaultTextFormat>
																			<flash.text.TextFormat font="Arno Pro" letterSpacing="1" align="left" size="15"  color="0xFFFFFF" />
																		</defaultTextFormat>
																	</flash.text.TextField> ;
		///////////////////////VARS
		private static var THUMBS:Dictionary = new Dictionary() ;
		
		private var node:XML ;
		private var fm3d:F5MovieClip3D ;
		private var requests:Array = [] ;
		private var results:Array = [] ;
		public var planes:Array = [] ;
		private var xLoader:XLoader ; 
		public var awaitingProject:int;
		private var extraPlane:F3DCube;
		///////////////////////////////////////////////////CTOR
		public function Navigation3DSection() 
		{
			xLoader = new XLoader() ;
			awaitingProject = 1 ;
		}
		///////////////////////////////////////////////////NAVIGATE
		public function navigateTo(_num:int):void
		{
			if (Executer.controller.enabled == false) return ;
			
			if (!planes || planes.length == 0) return ;
			trace(planes.length)
			var projectsLength:int = planes.length ;
			
			var upwards:Boolean = _num > 0 ;
			extraPlane = F3DCube(upwards ? planes[0] : planes[2]  );
			upwards ? planes.push(planes.shift()) : planes.unshift(planes.pop()) ;
			
			awaitingProject = planes[1].userData.index ;
			
			var from0:Object = upwards? { x:52 , y:52 } : { x:52 , y:-500 } ;
			var to0:Object = upwards? { x:52 ,y:-52 } : { x:52 ,y:-52 } ;
			var from1:Object = upwards? { x:-52 , y:52 } : { x:52 , y:-52 } ;
			var to1:Object = upwards? { x:52 ,y:52 } : { x:52 ,y:52 } ;
			var from2:Object = upwards? { x:-500 , y:52 } : { x:52 , y:52 } ;
			var to2:Object = upwards? { x: -52 , y:52 } : { x: -52 , y:52 } ;
			
			//var fromExtra:Object = upwards? { x:-52 , y:-52 } : { x:52 , y:52 } ;
			var toExtra:Object = upwards? { y:-(StageProxy.stage.stageWidth) } : { x:-(StageProxy.stage.stageWidth) } ;
			//$(extraPlane).attr(fromExtra) ;
			toExtra.onComplete = function():void {
				extraPlane = null ;
			}
			TweenLite.to(extraPlane, .8 , toExtra) ;
			
			
			
			var tweeningP:F3DCube = F3DCube(planes[1]) ;
			$(tweeningP).attr(from1) ;
			TweenLite.to(tweeningP, .4, to1 ) ;
			var tweeningP0:F3DCube = F3DCube(planes[0]) ;
			$(tweeningP0).attr(from0) ;
			TweenLite.to(tweeningP0, upwards ? .12 : .4, to0) ;
			var tweeningP2:F3DCube = F3DCube(planes[2]) ;
			$(tweeningP2).attr(from2) ;
			TweenLite.to(tweeningP2, upwards ? .4 : .12, to2) ;
		}
		public function prev():void
		{
			navigateTo( -1 ) ;
		}
		public function next():void
		{
			navigateTo( 1 ) ;
		}
		///////////////////////////////////////////////////INIT
		public function init(_node:XML):Navigation3DSection
		{
			node = _node ;
			for each(var project:XML in node.project) 
			{		
				var reqID:String = project.@thumb.toXMLString() ;
				requests.push(new MultiLoaderRequest(reqID, project.childIndex(), null)) ;
				
				if (!THUMBS[reqID] && !(THUMBS[reqID] is BitmapData)) {
					results.push(new BitmapData(100, 100, false, 0x333333)) ;
					xLoader.add(requests[project.childIndex()]) ;
				}else {
					results.push(BitmapData(THUMBS[reqID])) ;
				}
			}
			return this ;
		}
		///////////////////////////////////////////////////CREATE
		public function create(_fm3d:F5MovieClip3D):void
		{
			fm3d = _fm3d ;
			
			init3d();
			if (results.every(function(el:BitmapData, i:int, arr:Array ):Boolean { return Boolean(el != THUMBS[el]) } ) == true) {
				xLoader.addEventListener(LoadProgressEvent.PROGRESS, onThumbProgress) ;
				xLoader.addEventListener(LoadEvent.COMPLETE, onThumbComplete) ;
				xLoader.loadAll() ;
			}
			
			setArrows(true) ;
			Executer.controller.enabled = false ;
			fm3d.addEventListener(Event.ENTER_FRAME, onFrame3d) ;
			var g:F5Graphics3D = F5Graphics3D (fm3d.fg) ;
			var o:Object = { z:3 } ;
			var p:F3DCube  = planes[0];
			
			TweenLite.to(o, .5, { z:0, onUpdate:function() { 
				planes[0].rotationY = planes[1].rotationY = planes[2].rotationY = o.z ;
			}, onComplete:function() {
				Executer.controller.enabled = true ;
			} } ) ;
		}
		
		private function setArrows(cond:Boolean = true):void
		{
			if (Executer.controller.enabled == false) return ;
			var arrowsNav:Sprite , arrowLeft:Sprite ,arrowRight:Sprite,arrowTop:Sprite ,arrowBottom:Sprite  ;
			var back:TextField, go:TextField, before:TextField, after:TextField ;
			if (cond) {
				if (!Boolean($('#arrowsnav3D')[0])) {
					arrowsNav = $(Sprite).attr( { id:"arrowsnav3D",name:"arrowsnav3D" } )[0] ;
					arrowLeft = new (Type.getClass($("#arrowright")[0],Deposit.SWF["clips"].loaderInfo.applicationDomain))() ;
					$(arrowLeft).attr( { id:"space3Dleft", name:"space3Dleft", scaleX:-3, scaleY:3, x:StageProxy.stage.stageWidth / 4 + arrowLeft.width, y:(StageProxy.stage.stageHeight >> 1)-(arrowLeft.height>> 1) } ).appendTo(arrowsNav) ; ;
					arrowRight = new (Type.getClass($("#arrowright")[0],Deposit.SWF["clips"].loaderInfo.applicationDomain))() ;
					$(arrowRight).attr( { id:"space3Dright", name:"space3Dright", scaleX:3, scaleY:3, x:StageProxy.stage.stageWidth / 4 * 3, y:(StageProxy.stage.stageHeight >> 1)-(arrowRight.height>> 1) } ).appendTo(arrowsNav) ; ;
					arrowTop = new (Type.getClass($("#arrowup")[0],Deposit.SWF["clips"].loaderInfo.applicationDomain))() ;
					$(arrowTop).attr( { id:"space3Dtop", name:"space3Dtop", scaleX:1, scaleY:-1, x:(StageProxy.stage.stageWidth / 2), y:(StageProxy.stage.stageHeight / 4) - (arrowTop.height*2)} ).appendTo(arrowsNav) ; ;
					arrowBottom = new (Type.getClass($("#arrowdown")[0],Deposit.SWF["clips"].loaderInfo.applicationDomain))() ;
					$(arrowBottom).attr( { id:"space3Dbottom", name:"space3Dbottom", scaleX:1, scaleY:1, x:(StageProxy.stage.stageWidth / 2), y:(StageProxy.stage.stageHeight/4*3 )+ arrowBottom.height  } ).appendTo(arrowsNav) ; ;
					
					aaa_nav_3D_item_tf.@text = "BACK" ;
					back = $(aaa_nav_3D_item_tf)[0] ;
					$(back).attr( { id:"backtostepone", name:"backtostepone", x:arrowLeft.x + 10 , y:arrowLeft.y + ((arrowLeft.height / 2) - back.height / 2) + 2 } ).appendTo(arrowsNav) ;
					aaa_nav_3D_item_tf.@text = "LAUNCH" ;
					aaa_nav_3D_item_tf.@autoSize = "right" ;
					go = $(aaa_nav_3D_item_tf)[0] ;
					$(go).attr( { id:"launch", name:"launch", x:arrowRight.x - (go.width + 10 ) , y:arrowRight.y + ((arrowRight.height / 2) - go.height / 2) + 2 } ).appendTo(arrowsNav) ;
					aaa_nav_3D_item_tf.*[0].*[0].@size = "12" ;
					aaa_nav_3D_item_tf.@text = "PREVIOUS" ;
					before = $(aaa_nav_3D_item_tf)[0] ;
					$(before).attr( { id:"before", name:"before", x:arrowTop.x + 20 , y:arrowTop.y - (arrowTop.height)  } ).appendTo(arrowsNav) ;
					aaa_nav_3D_item_tf.@text = "NEXT" ;
					after = $(aaa_nav_3D_item_tf)[0] ;
					$(after).attr( { id:"after", name:"after", x:arrowBottom.x + 20 , y:arrowBottom.y + 2 } ).appendTo(arrowsNav) ;
					
					$(arrowsNav).attr( { alpha:0 } ).appendTo($("#nav3D")[0]) ;
					arrowsNav.addEventListener(MouseEvent.CLICK,onNav3DClicked)
					Executer.graphix.resizables.push(arrowsNav) ;
				}else {
					arrowsNav = $('#arrowsnav3D').attr( { alpha:0 } )[0] ;
				}
				TweenLite.to(arrowsNav,.3,{alpha:.5})
			}else {
				TweenLite.to($('#arrowsnav3D')[0], .4, { alpha:0 } ) ;
			}
		}
		
		private function onNav3DClicked(e:MouseEvent):void 
		{
			switch(e.target.name)
			{
				case "before" :
				case "space3Dtop" :
					Executer.controller.graphix.nav3D.prev() ;
				break ;
				case "after" :
				case "space3Dbottom" :
					Executer.controller.graphix.nav3D.next() ;
				break ;
				case "backtostepone" :
				case "space3Dleft" :
					Executer.controller.stepOne() ;
				break ;
				case "launch" :
				case "space3Dright" :
					Executer.controller.launchSelectedProject() ;
				break ;
			}
		}
		///////////////////////////////////////////////////INIT3D
		private function init3d():void
		{
			for(var i:int = 0, l:int = requests.length ; i<l ; i++)
			{
				var bmp:BitmapData = BitmapData(results[i]) ;
				var p:F3DCube = new F3DCube(100, 100, 20, 6, 6) ;
				if(i == 1) $(p).attr({x:52,y:52}) ; 
				else if(i == 0) $(p).attr({x:52,y:-52}) ;
				else if (i == 2) $(p).attr( { x: -52, y:52 } ) ;
				
				var bmpSides:BitmapData = new BitmapData(100, 100, false, Deposit.projectColor);
				p.userData = { bmp:bmp, color:Deposit.projectColor, index: i } ;
				//p.rotateAxis() ;
				getFaces(p) ;
				var f:Object = p.userData.faces ;
				p.setTextures(f.front, f.right, f.back, f.left, f.top, f.bottom) ;
				planes.push(p) ;
			}
		}
		
		private function getFaces(p:F3DCube):void
		{
			var pObj:Object = p.userData ;
			var tint:uint = Deposit.projectColor ;
			//var 
			var tintRGB:Object = ColorUtil.getRGB(tint),rightRGB:Object, backRGB:Object, leftRGB:Object, topRGB:Object, bottomRGB:Object ;
			tintRGB = ColorUtil.RGB2HSB(tintRGB.r, tintRGB.g, tintRGB.b) ;
			
			rightRGB =ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s, 90) ;
			leftRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s, 50) ;
			topRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s, 75) ;
			bottomRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s, 30) ;
			backRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s, 60) ;
			
			var resultRight:uint = rightRGB.r << 16 | rightRGB.g << 8 | rightRGB.b ;
			var resultLeft:uint = leftRGB.r << 16 | leftRGB.g << 8 | leftRGB.b ;
			var resultTop:uint = topRGB.r << 16 | topRGB.g << 8 | topRGB.b ;
			var resultBottom:uint = bottomRGB.r << 16 | bottomRGB.g << 8 | bottomRGB.b ;
			var resultBack:uint = backRGB.r << 16 | backRGB.g << 8 | backRGB.b ;
			
			pObj.faces = {front:pObj.bmp,right:new BitmapData(20, 100, false, resultRight),back:new BitmapData(100, 100, false, resultBack),left:new BitmapData(20, 100, false, resultLeft),top:new BitmapData(100, 20, false, resultTop),bottom:new BitmapData(100, 20, false, resultBottom)} ;
		}
		///////////////////////////////////////////////////ONFRAME3D
		private function onFrame3d(e:Event):void
		{
			var g:F5Graphics3D = F5Graphics3D (fm3d.fg) ;
			g.imageSmoothing = true ;
			var st:Stage = StageProxy.stage ;
			
				g.beginDraw() ;
				g.colorMode("hsv");
				g.noLineStyle() ;
					var _x:int = (st.stageWidth / 2) - st.mouseX ;
					var _y:int = (st.stageHeight / 2) - st.mouseY ;
					var j:Number = Percent.percent( -_x ,StageProxy.stage.stageWidth)/2 ;
					var k:Number = Percent.percent( _y ,StageProxy.stage.stageHeight)/2 ;
					g.translate(StageProxy.stage.stageWidth >> 1, StageProxy.stage.stageHeight >> 1) ;
					g.rotateY(j) ;
					g.rotateX(k) ;
					//g.rotateX(.84);
					g.rotate(-.8);
					for (var i:int = 0,l:int = planes.length ; i<l ; i++ )
					{
						var p:F3DCube = F3DCube(planes[i]) ;
						var pObj:Object = p.userData ;
						if (pObj.loaded) {
							getFaces(p) ;
							var f:Object = pObj.faces ;
							p.setTextures(f.front, f.right, f.back, f.left, f.top, f.bottom) ;
						}
						if (pObj.defColor != Deposit.projectColor) {
							pObj.color = Deposit.projectColor ;
							getFaces(p) ;
							var f2:Object = pObj.faces ;
							p.setTextures(f2.front, f2.right, f2.back, f2.left, f2.top, f2.bottom) ;
						}
						if (i<3) {
							g.model(p) ;
						}
					}
					if(extraPlane) g.model(extraPlane) ;
				g.endDraw() ;
		}
		///////////////////////////////////////////////////LOADING EVENTS HANDLERS
		private function onThumbProgress(e:LoadProgressEvent):void
		{
			//trace("YO TA REUM") ;
		}
		private function onThumbComplete(e:LoadEvent):void
		{
			var thumb:Bitmap = e.currentTarget.loader.getResponseById(e.req.id) ;
			var bmp:BitmapData = thumb.bitmapData ;
			THUMBS[bmp] = bmp ;
			results[e.index] = bmp ;
			var p:F3DCube = planes[e.index] ;
			p.userData.loaded = true ;
			p.userData.bmp = bmp ;
		}
		///////////////////////////////////////////////////KILL
		public function kill():void
		{
			awaitingProject = 1 ;
			
			if (fm3d) {
				setArrows(false) ;
				var g:F5Graphics3D = F5Graphics3D (fm3d.fg) ;
				g.beginDraw() ;
				g.noLineStyle() ;
				g.endDraw() ;
			}
			closeLoadings() ;
			planes = [] ;
		}
		private function closeLoadings():void
		{
			removeLoadingEvents() ;
		}
		private function removeLoadingEvents():void
		{
			if (xLoader && xLoader.hasEventListener(LoadEvent.COMPLETE) ) xLoader.removeEventListener(LoadEvent.COMPLETE , onThumbComplete) ;
			if (xLoader && xLoader.hasEventListener(LoadProgressEvent.PROGRESS) ) xLoader.removeEventListener(LoadProgressEvent.PROGRESS , onThumbProgress) ;
			if (fm3d && fm3d.hasEventListener(Event.ENTER_FRAME) ) fm3d.removeEventListener(Event.ENTER_FRAME,onFrame3d) ;
		}
	}
}