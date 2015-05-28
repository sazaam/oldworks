package aguessy.custom.launch.graph3D 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import gs.TweenLite;
	import naja.model.control.context.Context;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.model.control.resize.StageResizer;
	import naja.model.Root;
	import naja.model.XUser;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Nav3DGraphics 
	{
		private var user:XUser ;
		private var __nav3D:Nav3D ;
		internal var __nav:Sprite ;
		internal var __mc:Sprite;
		private var idArrowsNav:uint;
		
		public function Nav3DGraphics() 
		{
			user = Root.user ;
		}
		public function init(_nav3D:Nav3D):void
		{
			__nav3D = _nav3D ;
			__nav = Context.$get("#nav3D")[0] ;
			
			init3D() ;
			init2D() ;
			
		}
		public function init2D():void
		{
			initLogo() ;
			initArrows() ;
			initFullScreen() ;
			initKeyboard() ;
		}
		

		
		private function initLogo():void
		{
			var logoBmp:Bitmap = user.model.data.loaded["IMG"]["logo"] ;
			var logo:Sprite = Context.$get("#logo")[0] ;
			user.model.data.objects["logo"] = logo ;
			logo.blendMode = "invert" ;
			logo.addChild(logoBmp) ;
			logo.addEventListener(MouseEvent.CLICK, __nav3D.onNavClicked) ;
		}
		private function initArrows():void
		{
			var arrows:Sprite = Context.$get(Sprite).attr( { id:"ARROWS", name:"ARROWS" } )[0] ;
			
			var right:Sprite = Sprite(arrows.addChild(getBmpArrow("right"))) ;
			var left:Sprite = Sprite(arrows.addChild(getBmpArrow("left"))) ;
			var top:Sprite = Sprite(arrows.addChild(getBmpArrow("top"))) ;
			var bottom:Sprite = Sprite(arrows.addChild(getBmpArrow("bottom"))) ;
			__nav.addChild(arrows) ;
			right.addEventListener(MouseEvent.CLICK, __nav3D.onNavClicked) ;
			left.addEventListener(MouseEvent.CLICK, __nav3D.onNavClicked) ;
			bottom.addEventListener(MouseEvent.CLICK, __nav3D.onNavClicked) ;
			top.addEventListener(MouseEvent.CLICK, __nav3D.onNavClicked) ;
			top.visible = false ;
			arrows.alpha = 0 ;
			__nav.addEventListener(MouseEvent.ROLL_OVER,onOver)
			__nav.addEventListener(MouseEvent.ROLL_OUT,onOver)
		}
		
		private function initFullScreen():void
		{
			//var r:Sprite = Root.root ;
			//var fullscreen:TextField = Context.$get(user.model.config.textfields[0].*[0]).attr( { id:"fullscreen", name:"fullscreen",alpha:.35 } )[0] ;
			//fullscreen.text = "FULLSCREEN" ;
			//StageResizer.instance.handle(fullscreen) ;
			//Context.$get(fullscreen).bind(Event.RESIZE,onFullScreenResize).bind(MouseEvent.ROLL_OVER,onFullScreenOver).bind(MouseEvent.ROLL_OUT,onFullScreenOver).bind(MouseEvent.CLICK,onFullScreen).appendTo(r) ;
		}
		
		private function onFullScreen(e:MouseEvent):void
		{
			
		}
		
		private function onFullScreenResize(e:Event):void
		{
			var tf:TextField = TextField(e.currentTarget) ;
			tf.x = Root.root.stage.stageWidth - tf.width - 20 ;
			tf.y = 20 ;
		}
		
		private function onFullScreenOver(e:MouseEvent):void
		{
			var tf:TextField = TextField(e.currentTarget) ;
			if (e.type == MouseEvent.ROLL_OVER) {
				tf.alpha = .7 ; 
			}else {
				tf.alpha = .35 ;
			}
		}
		
		private function initKeyboard():void
		{
			Root.root.stage.addEventListener(KeyboardEvent.KEY_DOWN, __nav3D.onKeyDowned) ;
		}		
		private function onOver(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) {
				if (idArrowsNav) clearTimeout(idArrowsNav) ;
				appearArrows() ;
			}else{
				idArrowsNav = setTimeout(appearArrows,1000,false) ;
			}
		}
		
		private function appearArrows(cond:Boolean = true):void
		{
			var arrows:Sprite = Context.$get("#ARROWS")[0] ;
			if (cond) {
				TweenLite.to(arrows,.4,{alpha:1}) ;
			}else {
				TweenLite.to(arrows,.4,{alpha:0}) ;
			}
		}
		
		private function getBmpArrow(orientation:String = "right"):Sprite
		{
			var original:BitmapData = Bitmap(user.model.data.loaded["IMG"]["arrow"]).bitmapData ;
			var temp:BitmapData = new BitmapData(16, 17, true, 0xFF6600) ;
			var s:Sprite = Context.$get(Sprite).attr({id:"arrow_"+orientation,name:orientation})[0] ; 
			var output:Bitmap = new Bitmap(temp, "auto", true) ;
			var mx:Matrix = new Matrix() ;
			switch(orientation) {
				case 'top':
					mx.rotate(Math.PI/180*-90) ;
					mx.translate(0,16) ;
					s.x = 111 ;
					s.y = 75 ;
				break ;
				case 'bottom':
					mx.rotate(Math.PI/180*90) ;
					mx.translate(16,0) ;
					s.x = 111 ;
					s.y = 290 ;
				break ;
				case 'right':
					s.x = 175 ;
					s.y = 120 ;
				break ;
				case 'left':
					mx.scale(-1,1) ;
					mx.translate(16,0) ;
					s.x = 50 ;
					s.y = 120 ;
				break ;
			}
			temp.draw(original,mx,null,'normal',null,true) ;
			s.addChild(output) ;
			s.buttonMode = true ;
			s.blendMode = "invert" ;
			return s ;
		}
		
		public function init3D():void
		{
			var sMask:Class = user.model.data.loaded["SWF"]["clips"].loaderInfo.applicationDomain.getDefinition('sazaam') ;
			var mmask:Sprite = new sMask() ;
			__mc= new Sprite() ;
			mmask.addChild(__mc) ;
			var m:Sprite = mmask["maskk"];
			mmask.x = 50 ;
			mmask.y = 70 ;
			m.cacheAsBitmap = true ;
			__mc.cacheAsBitmap = true ;
			__mc.mask = m ;
			__mc.x = (800 >> 1) + (mmask.width >> 1) +2 ;
			__mc.y = (600 >> 1) + 41 ;
			__nav.addChild(mmask) ;
		}
	}
	
}