package cv.grafix 
{
	import asSist.$;
	import asSist.TwoWayBinding;
	import cv.deposit.Deposit;
	import cv.exec.Executer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.geom.Matrix ;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modules.foundation.Type;
	
	import frocessing.core.F5Graphics3D;
	import frocessing.display.F5MovieClip3D ; F5MovieClip3D ;
	import frocessing.f3d.F3DModel;
	import frocessing.f3d.models.F3DCube;
	import frocessing.f3d.models.F3DPlane;
	import frocessing.f3d.models.F3DSphere;
	import frocessing.geom.FNumber3D;
	
	import gs.easing.Expo;
	import gs.TweenLite;
	import saz.geeks.graphix.deco.Typographeur;
	import saz.helpers.layout.rects.SmartRect;
	import saz.helpers.math.Percent;
	import saz.helpers.sprites.Smart;
	import saz.helpers.stage.StageProxy;
	import saz.helpers.text.TextFill;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Graphix 
	{
		//////////////////////STRUCTURE
		private var aaa_structure:XML = <flash.display.Sprite id="all" name="all">
																		<flash.display.Sprite id="background" name="background" />
																		<flash.display.Sprite id="grid" name="grid" />
																		<flash.display.Sprite id="content" name="content" />
																		<flash.display.Sprite id="space" name="space" >
																			<frocessing.display.F5MovieClip3D id="spacebackground" name="spacebackground" />
																			<flash.display.Sprite id="nav3D" name="nav3D" y="30" />
																			<flash.display.Sprite id="spacenav" name="spacenav" />
																		</flash.display.Sprite>
																		<flash.display.Sprite id="logo" name="logo" />
																		<flash.display.Sprite id="nav" name="nav" y="30" />
																		<frocessing.display.F5MovieClip3D id="card" name="card" visible="false" />
																	</flash.display.Sprite> ;
		//////////////////////TEXTFORMATS
		private var aaa_nav_item_tf:XML = <flash.text.TextField name="txt" gridFitType="pixel" antiAliasType="advanced" selectable="false" x="20" text="image" autoSize="right" width="180" multiline="true">
																		<defaultTextFormat>
																			<flash.text.TextFormat font="Arno Pro" letterSpacing="1" align="center" size="12"  color="0xFFFFFF" />
																		</defaultTextFormat>
																	</flash.text.TextField> ;
		///////////////////////VARS
		public var resizables:Array ;
		private var oldSectionItem:int;
		private var typographor:Typographeur;
		private var v:F3DPlane ;
		private var cardOpen:Boolean ;
		private var ind:int ;
		
		private var nav3DSections:Array = [] ;
		public var nav3D:Navigation3DSection;
		///////////////////////////////////////////////////CTOR
		public function Graphix() 
		{
		}
		///////////////////////////////////////////////////INIT
		public function init():Graphix
		{
			
			StageProxy.init(Executer.target.stage) ;
			
			resizables = [] ;
			$(aaa_structure).appendTo(Executer.target) ;
			
			createSpaceNav() ;
			createLogo() ;
			createBackground() ;
			
			//$("#DEBUGTXT").attr( {text:$("#background") } ) ;
			
			initCard() ;
			
			posElems() ;
			enableLayer(false) ;
			
			return this ;
		}
		/////////////////////////////////////////////////////////////////////	SET CARD
		public function initCard():void{
		
			var front:Class = Deposit.cardA ;
			var back:Class = Deposit.cardB ;
			var bmpFront:BitmapData = new front(277, 116) as BitmapData ;
			var bmpBack:BitmapData = new BitmapData(277, 116, false, 0x0) ;
			var invertedBack:BitmapData = new back(277, 116) as BitmapData ;
			var flippedMatrix:Matrix = new Matrix(-1, 0, 0, 1, 277, 0);
			
			bmpBack.draw(new Bitmap(invertedBack, "auto", true ),flippedMatrix) ;
			
			v = new F3DPlane(277,116, 6, 6) ;
			v.setTexture(bmpFront,bmpBack)
			v.material.backFace = true ;
		}
		private function onCardFrame(e:Event):void
		{
			var fm3d:F5MovieClip3D = $('#card')[0] as F5MovieClip3D ;
			var g:F5Graphics3D = F5Graphics3D (fm3d.fg) ;
			var st:Stage = StageProxy.stage ;
			var _x:int = (st.stageWidth / 2) - st.mouseX ;
			var _y:int = (st.stageHeight / 2) - st.mouseY ;
				g.beginDraw() ;
				g.noLineStyle() ;
					g.translate(st.stageWidth / 2, st.stageHeight / 2) ;
					v.rotateY( Percent.percent( -_x ,st.stageWidth)/2 ) ;
					v.rotateX( Percent.percent( _y ,st.stageHeight)/2) ;
					g.model(v) ;
				g.endDraw() ;
			if(ind < 359)
			ind++
			else {
				ind++
			}
		}
		public function setCard(cond:Boolean):void 
		{
			var fm3d:F5MovieClip3D = $('#card')[0] as F5MovieClip3D ;
			if(cond)
			{
				fm3d.addEventListener(Event.ENTER_FRAME, onCardFrame) ;
			}else
			{
				fm3d.removeEventListener(Event.ENTER_FRAME, onCardFrame) ;
			}
			fm3d.visible = cond ;
		}
		/////////////////////////////////////////////////////////////////////	CREATE GRID
		public function createGrid():void
		{
			$("#grid Bitmap").remove() ;
			var grid:Sprite = $('#grid')[0] ;
			typographor = new Typographeur(new Deposit.FontEurostile() as Font ) ;
			//var bmp:Bitmap = new Bitmap(new BitmapData(StageProxy.stageRect.width, StageProxy.stageRect.height,false,0xFFFFFF)) ;
			var bmp:Bitmap = new Bitmap(new BitmapData(100, 100,false,0xFFFFFF)) ;
			typographPage(bmp) ;
		}
		private function typographPage(_bitmap:Bitmap):void
		{
			var multiplier:Number = .25 ;
			var bmpd:Bitmap = _bitmap ;
			var thumbBmp:BitmapData = bmpd.bitmapData ;
			var t:Typographeur = typographor ;
			t.type = "pixel" ;
			var thresh:int = 300 ;
			t.threshold = thresh ;
			t.flipValues() ;
			t.fromBitmap(thumbBmp, .5, 10, 1, 1) ;
			t.addEventListener(Event.CONNECT, onTypo) ;
			t.process() ;
		}
		
		private function onTypo(e:Event):void 
		{
			var grid:Sprite = $('#grid')[0] ;
			var t:Typographeur = Typographeur(e.currentTarget) ;
			var v:Sprite = new Sprite() ;
			var w:int = StageProxy.stageRect.width , h:int = StageProxy.stageRect.height ;
			var size:int =  100 ;
			var cols:int = (w / size)+1, rows:int = (h / size)+1 ;
			
			var length = cols * rows ;
			
			var temp:Bitmap = new Bitmap(new BitmapData(size,size, true, 0x0), "auto", true ) ;
			temp.bitmapData.draw(t) ;
			temp.cacheAsBitmap = true ;
			
			for (var i:int = 0; i < length ; i++ ) {
				var bmp:Bitmap = new Bitmap(temp.bitmapData, "auto", true ) ;
				$(bmp).attr({x:int(i % cols) * (size),y: int(i / cols) * (size)}).appendTo(v) ;
			}
			
			
			var output:Bitmap = new Bitmap(new BitmapData(w,h, true, 0x0), "auto", true ) ;
			output.bitmapData.draw(v) ;
			output.cacheAsBitmap = true ;
			
			
			grid.alpha = .25 ;
			grid.blendMode = BlendMode.SCREEN;
			//grid.blendMode = BlendMode.MULTIPLY ;
			//grid.blendMode = BlendMode.DARKEN;
			grid.addChild(output) ;
		}
		///////////////////////////////////////////////////RESIZE & POSITION
		public function onStageResized(e:Event):void
		{
			posElems(e) ;
		}
		public function posElems(e:Event = null):void
		{
			var arr:Array = resizables, l:int = arr.length ;
			for (var i = 0; i < l ; i++ ) {
				pos(Sprite(arr[i])) ;
			}
		}
		private function pos(el:Sprite):void
		{
			var X:Number, Y:Number
			switch (el.name)
			{
				case 'background' :
					drawBackground() ;
					el.dispatchEvent(new Event(Event.RESIZE)) ;
				break ;
				case 'space' :
					drawLayer() ;
				break ;
				case 'logo' :
					X = int((StageProxy.stageRect.width) - (el.width)) ;
				break ;
				case 'spacenav' :
					X = !Executer.controller.stepOnePassedThrough ? int((StageProxy.stageRect.width >> 1) - (el.width >> 1)) : 0 ;
					Y = !Executer.controller.stepOnePassedThrough ? int((StageProxy.stageRect.height >> 1) - (el.height >> 1)) : int((StageProxy.stageRect.height - 20) - (el.height)) ;
				break ;
				case 'arrowsnav3D' :
					var left:Sprite = $("#space3Dleft")[0], right:Sprite = $("#space3Dright")[0] ;
					var top:Sprite = $("#space3Dtop")[0], bottom:Sprite = $("#space3Dbottom")[0] ;
					var back:TextField = $("#backtostepone")[0], go:TextField = $("#launch")[0] ;
					var before:TextField = $("#before")[0], after:TextField = $("#after")[0] ;
					
					$(left).attr( {x:StageProxy.stage.stageWidth / 4 + left.width, y:(StageProxy.stage.stageHeight >> 1)-(left.height>> 1) } ) ;
					$(right).attr( {x:StageProxy.stage.stageWidth / 4 * 3, y:(StageProxy.stage.stageHeight >> 1)-(right.height>> 1) } ) ;
					$(top).attr( {  x:(StageProxy.stage.stageWidth / 2), y:(StageProxy.stage.stageHeight / 4) - (top.height*2)} ) ;
					$(bottom).attr( {  x:(StageProxy.stage.stageWidth / 2), y:(StageProxy.stage.stageHeight / 4 * 3) + bottom.height } ) ;
					
					$(back).attr( { x:left.x + 10 , y:left.y + ((left.height / 2) - back.height / 2)} ) ;
					$(go).attr( { x:right.x - (go.width + 10 ) , y:right.y + ((right.height / 2) - go.height / 2) } ) ;
					$(before).attr( { x:top.x + 20 , y:top.y - (top.height)  } ) ;
					$(after).attr( { x:bottom.x + 20 , y:bottom.y } ) ;

				break ;
				default :
					//X = 100
					//Y = 140
				break ;
			}
			with (el) {
				if (X) x = X ;
				if (Y) y = Y ;
			}
		}
		
		private function drawBackground():void
		{
			var background:Sprite = Sprite($("#background")[0]) ;
			background.graphics.clear() ;
			background.graphics.beginFill(0x0,0) ;
			background.graphics.drawRect(0,0,StageProxy.stageRect.width,StageProxy.stageRect.height) ;
			background.graphics.endFill() ;
		}
		///////////////////////////////////////////////////LOGO & BACKGROUND
		private function createBackground():void
		{
			resizables.push(Sprite($("#background")[0])) ;
		}
		public function createLogo():void
		{
			$(Deposit.Logo).attr( { id:"logoInside",name:"logoInside" } ).appendTo($("#logo")) ;
			resizables.push(Sprite($("#logo").attr( { buttonMode:true } ).bind(MouseEvent.CLICK,onLogoClicked)[0])) ;
		}
		private function onLogoClicked(e:MouseEvent):void
		{
			if(!Executer.controller.spaceNavOpened)
			{
				cardOpen = !cardOpen ;
				setCard(cardOpen) ;
			}
		}
		///////////////////////////////////////////////////SPACEBAR NAV
		public function createSpaceNav():void
		{
			var nav:Sprite = Sprite($("#spacenav")[0]) ;
			resizables.push(Sprite($("#space")[0])) ;
			resizables.push(nav) ;
			$("#spacenav").attr({x:int((StageProxy.stageRect.width >> 1) - (nav.width >> 1)),y:int((StageProxy.stageRect.height >> 1) - (nav.height >> 1))}) ;
		}
		public function spaceNavStepTwo():void
		{
			var nav:Sprite = $("#spacenav")[0] ;
			TweenLite.to(nav, .4, {ease:Expo.easeOut, x:0 , y:int((StageProxy.stageRect.height - 20) - (nav.height)) } ) ;
		}
		public function spaceNavStepOne(tween:Boolean):void
		{
			var nav:Sprite = $("#spacenav")[0] ;
			var to:Object = {ease:Expo.easeOut, x:int((StageProxy.stageRect.width >> 1) - (nav.width >> 1))  , y:int((StageProxy.stageRect.height >> 1) - (nav.height >> 1)) } ;
			if (tween)$(nav).attr( to ) ;
			else TweenLite.to(nav, .4, to) ;
		}
		///////////////////////////////////////////////////////////////////SECTIONS 3D NAV
		public function createSections3DNavItem(_node:XML):void
		{
			nav3DSections.push(new Navigation3DSection().init(_node)) ;
		}
		///////////////////////////////////////////////////////////////////SECTIONS NAV
		public function createSectionsNavItem(_node:XML):void
		{
			var i:int = _node.childIndex() ;
			var navItem:Sprite = new Sprite() ;
			var navGraphics:Shape = navItem.addChild(new Shape()) as Shape ;
			var tf:TextField = $(aaa_nav_item_tf).appendTo(navItem)[0] as TextField , fmt:TextFormat = tf.getTextFormat() ;
			tf.x = 165 ;
			$(tf).attr( {text:_node.@id.toXMLString().toUpperCase() +"   "+int(i+1)} ) ;
			tf.setTextFormat(fmt) ;
			navGraphics.graphics.beginFill(0xFFFFFF,.5) ;
			navGraphics.graphics.drawRect(0,9,tf.x-30,1) ;
			navGraphics.graphics.endFill() ;
			navGraphics.alpha = 0 ;
			$(navItem).attr( { buttonMode:true , mouseChildren:false , id:"navItem_" + i, name:"navItem_" + i , y:(25 * i) } ).appendTo($("#spacenav")).bind(MouseEvent.CLICK, onItemSelect) ;
			if (!Boolean(_node.parent().*[i + 1] is XML)) {
				var nav:Sprite = $("#spacenav")[0] ;
				nav.graphics.lineStyle(1, 0xFFFFFF, .4, true, "none", CapsStyle.SQUARE, JointStyle.MITER) ;
				nav.graphics.moveTo(nav.width+14,0) ;
				nav.graphics.lineTo(nav.width+14,int(nav.height)) ;
				nav.graphics.endFill() ;
			}
		}
		
		private function onItemSelect(e:MouseEvent):void
		{
			Executer.controller.onNavItemSelect(e) ;
		}
		
		public function enableNav(cond:Boolean = true):void
		{
			if (cond) {
				cardOpen = !cardOpen ;
				setCard(false) ;
				Executer.controller.awaitingSection = Executer.controller.selectedSection ;
				showCurrentNavItem() ;
			}else {
				Executer.controller.awaitingSection = -1 ;
			}
			$("#logo").attr( { buttonMode:!cond } ) ;
		}
		public function setNav3D(cond:Boolean = true ):void
		{
			
			nav3D = nav3DSections[Executer.controller.awaitingSection] ;
			if (!nav3D) return ;
			if(cond) {
				nav3D.create(F5MovieClip3D($("#spacebackground")[0])) ;
			} else {
				nav3D.kill() ;
			}
		}
		public function killOldAwaitingSection():void
		{
			setNav3D(false) ;
		}
		public function showCurrentNavItem():void
		{
			var spr:Sprite = $("#spacenav Sprite")[Executer.controller.awaitingSection] ;
			var arrowRight:Sprite;
			if (!Boolean($("#spacenavright")[0])) {
				arrowRight = new (Type.getClass($("#arrowright")[0],Deposit.SWF["clips"].loaderInfo.applicationDomain))() ;
				$(arrowRight).attr( { id:"spacenavright",x:spr.width + 20,y:2 } ) ;
			}else {
				arrowRight = $("#spacenavright")[0] ;
			}
			spr.addChild(arrowRight) ;
			highlight(spr) ;
		}
		private function highlight(_spr:Sprite, cond:Boolean = true ):void
		{
			var sh:Shape = _spr.getChildAt(0) as Shape ;
			if (cond) {
				_spr.alpha = 1 ;
				$(sh).attr( { x:25 ,scaleX:0, alpha:0 } );
				TweenLite.to(sh, .4, { scaleX:1, alpha:1,onStart:cleanBullshit,onComplete:cleanBullshit ,ease:Expo.easeOut} ) ;
				oldSectionItem = _spr.parent.getChildIndex(_spr) ;
			}else {
				_spr.alpha = .5 ;
				$(sh).attr( { scaleX:0, alpha:0 } ) ;
			}
		}
		private function cleanBullshit():void
		{
			$("#spacenav Sprite").each(function(i:int, el:Sprite) {
				if (i != Executer.controller.awaitingSection) highlight(el,false) ;
			}) ;
		}
		///////////////////////////////////////////////////////////////////LAYER
		public function enableLayer(cond:Boolean = true,_time:Number = 0):void
		{
			var layer:Sprite = $("#space")[0] ;
			if (_time != 0) {
				if (cond) {
					displayLayer(cond)  ;
					TweenLite.to(layer, _time, { alpha: 1 } ) ;
				}
				else
					TweenLite.to(layer, _time, { alpha: 0, onComplete:function() { displayLayer(cond) }} )
			}else {
				layer.alpha = 0 ;
				displayLayer(cond)  ;
			}
		}
		private function drawLayer():void
		{
			var layer:F5MovieClip3D = $("#spacebackground")[0] ;
			layer.graphics.clear() ;
			layer.graphics.beginFill(0x121212,.92) ;
			layer.graphics.drawRect(0,0,StageProxy.stageRect.width,StageProxy.stageRect.height) ;
			layer.graphics.endFill() ;
		}
		private function displayLayer(cond:Boolean):void
		{
			if(cond) drawLayer() ;
			$("#space").attr( { visible:cond } ) ;
			enableNav(cond) ;
		}
		///////////////////////////////////////////////////LAUNCH
		private function setCurrent(_num:Object = null):void
		{
			Executer.controller.selectedSection = isNaN(int(_num))? -1 : int(_num) ;
		}
		public function launchSection(_num:int):void
		{
			setCurrent(_num) ;
		}
		public function killSection():void
		{
			setCurrent(null);
		}
	}
}