package aguessy.custom.launch.graph3D 
{
	import aguessy.custom.launch.NewsItemSteps;
	import aguessy.custom.load.geeks.AguessyLink;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import fro.display.FroRenderer;
	import frocessing.core.F5Graphics3D;
	import frocessing.f3d.models.F3DCube;
	import frocessing.f3d.models.F3DPlane;
	import frocessing.geom.FNumber3D;
	import gs.easing.Back;
	import gs.easing.Bounce;
	import gs.TweenLite;
	import naja.model.control.context.Context;
	import naja.model.control.resize.StageResizer;
	import naja.model.Root;
	import org.libspark.utils.ArrayUtil;
	import saz.helpers.sprites.Smart;
	import naja.model.steps.VirtualSteps;
	import sketchbook.colors.ColorUtil;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Graph3DView
	{
		internal var __viewPort:FroRenderer ;
		internal var __fg:F5Graphics3D ;
		internal var __target:DisplayObject ;
		private var __rendering:Boolean ;
		internal var __items:Array ;
		private var __ind:int ;
		private var defaultColor:uint = 0x777777 ;
		private var defaultHighlightColor:uint = 0xaaaaaa ;
		internal var sectionColor:uint = 0x159159;
		private var __itemSize:int ;
		private var middleWidth:Number = 400 ;
		private var middleHeight:Number = 300 ;
		internal var __totalAvailable:int ;
		internal var __currentCube:F3DCube ;
		private var __sections:Array ;
		private var __length:int ;
		private var __currentPosition:int ;
		private var __g3D:Graph3D;
		private var sizeLength:Number = .5;
		private var barHeight:int = 19 ;
		private var __nextIndY:int;
		private var __currentColor:uint;
		private var __sizeBlock:int;
		
		public function Graph3DView() 
		{
			__viewPort = new FroRenderer() ;
		}
		
		public function init3D(_tg:F5Graphics3D, graph3D:Graph3D):void
		{
			__g3D = graph3D ;
			__fg = _tg ;
			initItems() ;
		}
		
		public function reset():void
		{
			var l:int = __items.length ;
			for( var i:int = 0 ; i < l ; i++ )
			{
				var cube:F3DCube = F3DCube(__items[i]) ;
				__currentCube = null ;
				highlight(cube,false) ;
				TweenLite.to(cube, .3, { scaleZ:0 } ) ;
			}
		}
		
		internal function render(cond:Boolean = true):void
		{
			if (cond) {
				__target.addEventListener(Event.ENTER_FRAME, draw) ;
				__rendering = true ;
			}else {
				__target.removeEventListener(Event.ENTER_FRAME, draw) ;
				__rendering = true ;
			}
		}
		
		private function draw(e:Event):void 
		{
			var l:int = __items.length ;
			for( var i:int = 0 ; i < l ; i++ )
			{
				var p:F3DCube = F3DCube(__items[i]) ;
				var fg:F5Graphics3D = p.userData.graphics3D ;
				fg.beginDraw() ;
				fg.rotateX( -1.2) ;
				fg.model(p) ;
				fg.endDraw();
			}
			if (__ind == 359) __ind = -1 ;
			__ind++ ;
		}
		
		private function initItems():void
		{
			__itemSize = 10 ;
			__totalAvailable = 7 ;
			__items = [] ;
			__currentPosition = int(__totalAvailable / 2) ;
			__sections = [] ;
			
			var l:int = __totalAvailable ;
			
			for( var i:int = 0 ; i < l ; i++ )
			{
				var sh:Sprite = new Sprite() ;
				Context.$get(sh).attr({id:"graphItem_" + i,name:"graphItem_" + i}) ;
				var fgShape:F5Graphics3D = new F5Graphics3D(sh.graphics, middleWidth << 1, middleHeight << 1) ;
				var p:F3DCube
				if (i < 3) {
					Sprite(__target).addChild(sh) ;
					p = new F3DCube(__itemSize, __itemSize, __itemSize) ;
				}else if (i > 3) {
					Sprite(__target).addChildAt(sh, 0) ;
					p = new F3DCube(__itemSize, __itemSize, __itemSize) ;
				}else {
					Sprite(__target).addChild(sh) ;
					p = new F3DCube(__itemSize, __itemSize, __itemSize) ;
				}
				sh.addEventListener(MouseEvent.CLICK,__g3D.__nav3D.onNavClicked) ;
				sh.addEventListener(MouseEvent.ROLL_OVER,onRoll) ;
				sh.addEventListener(MouseEvent.ROLL_OUT,onRoll) ;
				fgShape.colorMode("hsv", 425, 1, 1, 1) ;
				fgShape.noStroke() ;
				fgShape.ortho() ;
				
				p.material.backFace = true ;
				var X:int, Y:int, Z:int;
				var coords:Object = getCoords(i, l) ;
				X = coords.x ;
				Y = coords.y ;
				Z = coords.z ;
				
				p.x = X ;
				p.y = Y ;
				p.z = Z ;
				
				p.userData = { color: defaultColor, index: i,mc:sh,graphics3D:fgShape } ;
				
				getColors(p) ;
				var f:Object = p.userData.faces ;
				
				p.setColors(f.front, f.right, f.back, f.left, f.top, f.bottom) ;
				p.rotateZ(.75)
				__items.push(p) ;
			}
		}
		
		internal function setCubeColor(col:* = null,index:int = -1):void
		{
			if (index == -1) index = __g3D.__currentIndex ;
			var p:F3DCube = F3DCube(__items[index]) ;
			if (col is uint) {
				p.userData.color = col ;
				__currentColor = col ;
			}else {
				p.userData.color = defaultHighlightColor ;
			}
			getColors(p) ;
			var f:Object = p.userData.faces ;
			p.setColors(f.front, f.right, f.back, f.left, f.top, f.bottom) ;
		}
		
		private function onRoll(e:MouseEvent):void 
		{
			var sh:Sprite = Sprite(e.currentTarget) ;
			var s:String = sh.name ;
			var i:int = int(s.substr(s.lastIndexOf('_') + 1, s.length - 1)) ;
			if (e.type == MouseEvent.ROLL_OVER) {
				highlight(__items[i]) ;
			}else {
				highlight(__items[i],false) ;
			}
		}
		
		public function variate(i:int,length:int,xml:XML = null):void
		{
			var sh:Sprite = Context.$get("#graphItem_" + i)[0] ;
			var cube:F3DCube = F3DCube(__items[i]) ;
			var params:Object = {} ;
			if (xml) {
				params = { scaleZ:length!=0? length * sizeLength : sizeLength } ;
			}else {
				params = { scaleZ: 0 } ;
			}
			
			TweenLite.to(cube, .3, params ) ;
		}
		
		internal function highlight(m:Object,cond:Boolean = true):void
		{
			var tint:uint ;
			var p:F3DCube ;
			var index:int
			if (m is F3DCube) {
				p = F3DCube(m) ;
				index = p.userData.index ;
			}else {
				index = int(m)
				p = __items[index];
			}
			var sh:Sprite = Context.$get("#graphItem_" + index)[0] ;
			if (cond == true) {
				getColors(p,7) ;
			}else {
				getColors(p) ;
			}
			var f:Object = p.userData.faces ;
			p.setColors(f.front, f.right, f.back, f.left, f.top, f.bottom) ;
		}
		
		
		internal function addHover(id:String, __currentIndex:int, d:int, cond:Boolean) :void
		{
			var mc:Sprite, tf:TextField ;
			var nav:Sprite = Context.$get("#nav3D")[0] ;
			if (cond) {
				if (d!=3) {
					mc = Context.$get(Sprite).attr( { id:"OVERITEM", name:"OVERITEM" } )[0] ;
					tf = Context.$get(Root.user.model.config.textfields[0].*[1]).attr( { id:"OVERITEM_TEXT", name:"TEXT" } )[0] ;
					tf.text = id.toUpperCase() ;
					if (d == 0) {
						mc.x = 35 ;
						mc.y = 70 ;
					}
					else {
						mc.x = 199 ;
						mc.y = 70 + (barHeight*(d)) ;
					}
					mc.blendMode = "invert" ;
					mc.addChild(tf) ;
					Root.root.addChild(mc) ;
				}else {
					
				}
			}else {
				try{
					Context.$get("#OVERITEM").remove() ;
				}catch (e:Error)
				{
					
				}
			}
		}
		
		private function toVerticalString(s:String):String
		{
			var str:String = s.replace('_', ' ') ;
			var p:Array = str.match(/(.){1}/gi) ;
			return p.join('\n') ;
		}
		
		
		private function getColors(p:F3DCube,d:Number = 0):void
		{
			var pObj:Object = p.userData ;
			var tint:uint = pObj.color ;
			
			var tintRGB:Object = ColorUtil.getRGB(tint),frontRGB:Object,rightRGB:Object, backRGB:Object, leftRGB:Object, topRGB:Object, bottomRGB:Object ;
			tintRGB = ColorUtil.RGB2HSB(tintRGB.r, tintRGB.g, tintRGB.b+d) ;
			frontRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s, tintRGB.b+d-20) ;
			topRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s,  tintRGB.b+d) ;
			leftRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s,  tintRGB.b+d-10) ;
			rightRGB =ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s, tintRGB.b+d+5) ;
			bottomRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s,  tintRGB.b+d-5) ;
			backRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s,  tintRGB.b+d-15) ;
			
			var resultFront:uint = frontRGB.r << 16 | frontRGB.g << 8 | frontRGB.b ;
			var resultRight:uint = rightRGB.r << 16 | rightRGB.g << 8 | rightRGB.b ;
			var resultLeft:uint = leftRGB.r << 16 | leftRGB.g << 8 | leftRGB.b ;
			var resultTop:uint = topRGB.r << 16 | topRGB.g << 8 | topRGB.b ;
			var resultBottom:uint = bottomRGB.r << 16 | bottomRGB.g << 8 | bottomRGB.b ;
			var resultBack:uint = backRGB.r << 16 | backRGB.g << 8 | backRGB.b ;
			
			pObj.faces = {front:resultFront,right:resultRight,back:resultBack,left:resultLeft,top:resultTop,bottom:resultBottom} ;
		}
		private function getCoords(i:int,l:int):Object
		{
			var pos:Object = { } ;
			
			var x:Number, y:Number, z:Number,startx:Number, starty:Number ;
			var max:Number = 3 ;
			startx = 0 ;
			starty = 0;
			var half:Number = __itemSize >> 1 ;
			var sim:Number = __itemSize * .8 ;
			if (i < max) {
				x = startx + (sim * -(max - i)) ;
				y = starty + ((max - i) * sim) ;
				z = 0 ;
			}else if(i > max) {
				x = startx + (sim * -(max-i)) ;
				y = starty + ( -(max - i) * sim) ;
				z = 0 ;
			}else {
				x = startx ;
				y = starty ;
				z = 0 ;
			}
			
			pos.x = x ;
			pos.y = y ;
			pos.z = z
			
			return pos ;
		}
		
		
		
		// NAV MOVING
		public function levelOne(cond:Boolean):void {
			
			var nav:Sprite = Context.$get("#nav3D")[0] ;
			var topArrow:Sprite = Context.$get("#arrow_top")[0] ;
			if (cond) {
				sizeLength = 1 ;
				topArrow.visible = true ;
				TweenLite.to(nav,.3,{y:20,ease:Back.easeOut})
			}else {
				sizeLength = .5 ;
				topArrow.visible = false ;
				TweenLite.to(nav,.3,{y:0,ease:Back.easeOut})
			}
		}
		
		
		
		//	NAV FILLING
		///////////////////////////////////////////////////////////////////////////////// MEDIAS
		public function addMediasInfos(infos:XML):void
		{
			
		}
		
		public function removeMediasInfos():void
		{
			
		}
		
		///////////////////////////////////////////////////////////////////////////////// NEWS
		public function addNewsInfos(infos:XML):void 
		{
			var s:Sprite = Context.$get(Root.user.model.config.sprites[0].*[1]).attr({id:"NEWS",name:"NEWS"})[0] ;
			s.x = 199 ;
			s.y = __nextIndY ;
			
			var o:Object = { } ;
			
			for each(var info:XML in infos.*) {
				var n:String = info.localName() ;
				switch(info.localName()) {
					case 'event' :
						o.event = info.@date.toXMLString() ;
						Context.$get('#' + n).text(o[n].replace(/&amp;/gi, "&")) ;
					break ;
					case 'link' :
						o.link = __g3D.__nav3D.currentStep.xml.@usename.toXMLString().replace("&amp;","&")
						if (infos.link[0].hasOwnProperty('@href')) {
							var toGoLink:String = infos.link[0].@href.toXMLString() ;
							var tft:TextField = Context.$get('#' + n).bind(MouseEvent.MOUSE_OVER,onLink).bind(MouseEvent.MOUSE_OUT,onLink).bind(MouseEvent.CLICK, function(e:MouseEvent):void {
								navigateToURL(new URLRequest(toGoLink), '_blank') ;
							})[0] ;
						}
						Context.$get('#' + n).text(o[n].replace(/&amp;/gi, "&")) ;
					break ;
					case 'resume' :
						o.resume = info.toString() ;
						var tf:TextField = Context.$get('#' + n)[0] ;
						tf.htmlText = replaceTextForSpecialChar(o[n]) ;
						tf.autoSize = "left" ;
					break ;
				}
				
			}
			
			s.blendMode = "invert" ;
			
			Root.root.addChild(s) ;
		}
		
		
		public function removeNewsInfos():void 
		{
			try 
			{
				Context.$get("#NEWS").remove() ;
			}catch (e:Error)
			{
				
			}
		}
		///////////////////////////////////////////////////////////////////////////////// PORTFOLIO
		
		public function addPortfolioInfos(infos:XML):void 
		{
			var s:Sprite = Context.$get(Root.user.model.config.sprites[0].*[0]).attr({id:"INFOS",name:"INFOS"})[0] ;
			s.x = 199 ;
			s.y = __nextIndY ;
			
			var o:Object = { } ;
			var last:TextField ;
			for each(var info:XML in infos.*) {
				var n:String = info.localName() ;
				switch(n) {
					case 'date' :
						o.date = info.@year.toXMLString() ;
					break ;
					case 'usename' :
						o.usename = info.toString() ;
					break ;
					case 'editor' :
						o.editor = info.toString().toUpperCase() ;
						if (info.hasOwnProperty('@href')) {
							var link:String = info.@href.toXMLString() ;
							var tft:TextField = Context.$get('#' + n).bind(MouseEvent.MOUSE_OVER,onLink).bind(MouseEvent.MOUSE_OUT,onLink).bind(MouseEvent.CLICK, function(e:MouseEvent):void {
								navigateToURL(new URLRequest(link), '_blank') ;
							})[0] ;
							tft.autoSize = "left" ;
							
						}
						last = Context.$get('#' + n).text(o[n].replace(/&amp;/gi,"&"))[0] ;
					break ;
					case 'cat' :
						o.cat = info.toString() ;
					break ;
					case 'materials' :
						o.materials = info.toString() ;
					break ;
				}
				if (n != "editor" && n!= "usename") {
					var textF:TextField = Context.$get('#' + n).text(o[n].replace(/&amp;/gi, "&"))[0] ;
					var l:int = last.numLines ;
					var min:Number = 19 ;
					textF.y = last.y + (l==1 ? min : 19+((l-1)*10)) ;
					last = textF ;
				}
				
			}
			
			s.blendMode = "invert" ;
			
			Root.root.addChild(s) ;
		}
		
		private function onLink(e:MouseEvent):void
		{
			var tf:TextField = TextField(e.currentTarget) ;
			if (e.type == MouseEvent.MOUSE_OVER) {
				var s:AguessyLink = Context.$get(AguessyLink).attr( { id:"HOVER", name:"HOVER" } )[0] ;
				s.init(tf) ;
				s.blendMode = 'invert' ;
				var cont:Sprite ;
				if (__g3D.__nav3D.currentStep is NewsItemSteps) {
					cont = Context.$get("#NEWS")[0] ;
				}else {
					cont = Context.$get("#INFOS")[0] ;
				}
				cont.addChildAt(s,0) ;
			}else {
				Context.$get("#HOVER").attr({blendMode:"normal"}).remove() ;
			}
		}
		
		
		public function removePortfolioInfos():void 
		{
			try 
			{
				Context.$get("#INFOS").remove() ;
			}catch (e:Error)
			{
				
			}
		}
		
		public function addSubSection(i:int,str:String,cond:Boolean):void
		{
			var s:Sprite
			if (cond) {
				s = Context.$get(Sprite).attr({id:"SUBITEM_"+i,name:"SUBITEM_"+i})[0] ;
				s.graphics.beginBitmapFill(Root.user.model.data.objects["motif"],null,true,true) ;
				s.graphics.drawRect(0,0,160,15) ;
				s.graphics.endFill() ;
				s.blendMode = "invert" ;
				var title:Sprite = Context.$get("#TITLE")[0] ;
				s.x =  199 ;
				s.y =  title.y + barHeight * (i - 1) ;
				__nextIndY = s.y + 19 ;
				var tf:TextField = Context.$get(Root.user.model.config.textfields[0].*[0]).attr({id:"SUBTITLE_TEXT_"+__g3D.__nav3D.currentStep.depth,name:"TEXT"})[0] ;
				tf.appendText(str.replace('_',' ').toUpperCase()) ;
				s.addChild(tf) ;
				Context.$get(s).bind(MouseEvent.CLICK,__g3D.__nav3D.onNavClicked).appendTo(Root.root) ;
			}else {
				try 
				{
					Context.$get("#SUBITEM_" + i).unbind(MouseEvent.CLICK,__g3D.__nav3D.onNavClicked).remove() ;
				}catch (e:Error)
				{
					
				}
			}
		}
		
		
		// TEXT FILLING
		public function addTextPage(step:VirtualSteps, cond:Boolean):void
		{
			var ref:String = String(step.id) ;
			if (cond) {
				var page:Sprite = Context.$get(Sprite).bind(Event.RESIZE, redrawPage).attr( { id:"PAGE", name:"PAGE", x:360, y:70+(barHeight*step.depth), blendMode:"invert" } ).appendTo(Root.root)[0] ;
				var pageInside:Sprite = Context.$get(Sprite).attr( { id:"PAGEINSIDE", name:"PAGEINSIDE" } ).appendTo(page)[0] ;
				StageResizer.instance.handle(page) ;
			}else {
				try 
				{
					var pageQ:* = Context.$get("#PAGE") ;
					StageResizer.instance.unhandle(pageQ[0]) ;
					pageQ.unbind(Event.RESIZE, redrawPage).remove() ;
				}catch (e:Error)
				{
					
				}
			}
		}
		
		public function redrawPage(e:Event = null):void
		{
			var mc:Sprite = Context.$get("#PAGE")[0] ;
			var mcInside:Sprite = Context.$get("#PAGEINSIDE")[0] ;
			var f:Graphics = mc.graphics ;
			f.clear() ;
			f.beginBitmapFill(Root.user.model.data.objects["motif"], null, true, true) ;
			var r:Rectangle = new Rectangle(0, 0, mc.stage.stageWidth - int(mc.x) - 30, mc.stage.stageHeight - int(mc.y) - 30) ;
			f.drawRect(r.x,r.y,r.width,r.height) ;
			f.endFill() ;
			if (__g3D.__nav3D.currentStep.id != "MEDIAS") {
				mc.scrollRect = r ;
				checkForContainedSprites() ;
			}
		}
		
		public function checkForContainedSprites():void
		{
			var mc:Sprite = Context.$get("#PAGE")[0] ;
			var mcInside:Sprite = Context.$get("#PAGEINSIDE")[0] ;
			var l:int = mcInside.numChildren ;
			
			var r:Rectangle = mc.getRect(mcInside) ;
			for (var i:int = 0; i < l ; i++ ) {
				var bitch:Smart = Smart(mcInside.getChildAt(i)) ;
				var tf:TextField = TextField(Sprite(bitch.getChildAt(0)).getChildAt(0)) ;
				var r2:Rectangle = new Rectangle(int(bitch.x+tf.x),int(bitch.y+tf.y),int(tf.width),int(tf.height)) ;
				var b:Boolean = r.containsRect(r2) ;
				TweenLite.to(bitch,.2,{alpha:b?bitch.properties.alpha:0})
			}
		}
		
		public function fillTextPage(step:VirtualSteps, page:XML, cond:Boolean):void
		{
			var ref:String = String(step.id) ;
			var i:int = page.childIndex() ;
			var mc:Sprite = Context.$get("#PAGE")[0] ;
			var mcInside:Sprite = Context.$get("#PAGEINSIDE")[0] ;
			if (cond) {
				var x:XML = page['flash.display.Sprite'][0] ;
				var ss:Sprite = Context.$get(x)[0] ;
				var s:Smart = Context.$get(Smart).attr( { id:ref + "_" + i, name:ref + "_" + i } ).append(ss)[0] ;
				var tf:TextField = TextField(ss.getChildAt(0)) ;
				tf.htmlText = replaceTextForSpecialChar(tf.htmlText) ;
				tf.autoSize = "left" ;
				__sizeBlock = s.width + 10 ;
				if (i > 0) {
					var prev:Sprite = Context.$get("#" + ref + "_" + String(i-1))[0] ;
					s.x = prev.x + __sizeBlock ;
				}else {
					
				}
				s.properties = { x:s.x,alpha:s.alpha } ;
				mcInside.addChild(s) ;
			}else {
				try 
				{
					Context.$get("#" + ref + "_" + i).remove() ;
				}catch (e:Error)
				{
					
				}
			}
			
		}
		
		public function replaceTextForSpecialChar(str:String):String
		{
			str = str.replace(/(\t)/gx, "") ;
			str = str.replace(/(\n)/gi, "") ;
			return str ;
		}
		
		
		// NAV FILLING
		public function addTitle():void
		{
			var port:Sprite = Context.$get(Sprite).attr({id:"TITLE",name:"TITLE"})[0] ;
			port.graphics.beginBitmapFill(Root.user.model.data.objects["motif"],null,true,true) ;
			port.graphics.drawRect(0,0,325,15) ;
			port.graphics.endFill() ;
			port.blendMode = "invert" ;
			port.x = 35 ;
			port.y = 70 ;
			var tf:TextField = Context.$get(Root.user.model.config.textfields[0].*[0]).attr({id:"TITLE_TEXT",name:"TEXT"})[0] ;
			port.addChild(tf) ;
			Context.$get(port).bind(MouseEvent.CLICK,__g3D.__nav3D.onNavClicked) ;
			Root.root.addChild(port) ;
		}
		public function fillTitle(s:String):void
		{
			var tf:TextField = Context.$get("#TITLE_TEXT")[0] ;
			tf.appendText(s) ;
		}
		public function removeTitle():void
		{
			Context.$get("#TITLE_TEXT").remove() ;
			Context.$get("#TITLE").unbind(MouseEvent.CLICK,__g3D.__nav3D.onNavClicked).remove() ;
		}
		
		public function get nextIndexY():int { return __nextIndY }
		
	}
	
}