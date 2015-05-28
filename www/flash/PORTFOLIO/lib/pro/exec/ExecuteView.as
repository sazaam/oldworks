package pro.exec 
{
	import fl.motion.ColorMatrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import of.app.required.commands.Command;
	import of.app.required.steps.VirtualSteps;
	import pro.exec.views.BasicView;
	import tools.fl.sprites.BehaviorSmart;
	import tools.grafix.BloopEffect;
	import tools.layer.Layer;
	//import frocessing.shape.FShapeSVG;
	import gs.TweenLite;
	import of.app.required.context.XContext;
	import of.app.required.resize.StageResize;
	import of.app.Root;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	/**
	 * ...
	 * @author saz
	 */
	public class ExecuteView extends BasicView
	{
		private var __model:ExecuteModel;
		private var __controller:ExecuteController;
		private var __bmp:Bitmap;
		
		public function ExecuteView() 
		{
			
		}
		public function init(executeModel:ExecuteModel, executeController:ExecuteController):void 
		{
			__controller = executeController ;
			__model = executeModel  ;
			initClasses() ;
			initStage() ;
			createFrame() ;
			createBack() ;
			createBasicNav() ;
			createDepthNav() ;
			createSpaceNav() ;
		}
		
		private function initClasses():void 
		{
			__externals = Root.user.data.loaded["SWF"]["externals"] ;
		}
		public function render():void 
		{
			stage.dispatchEvent(new Event(Event.RESIZE)) ;
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////// STAGE
		private function initStage():void 
		{
			target = XContext.$get('#'+__model.all.id)[0] ;
			stage = target.stage ;
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////// SPACENAV
		private function createBack():void 
		{
			__background = XContext.$get('#'+__model.background.id)[0] ;
			__background.addEventListener(Event.RESIZE, onBackgroundResize) ;
			StageResize.instance.handle(__background) ;
		}
		
		public function setSectionImage(bitmap:Bitmap = null, cond:Boolean = true):void 
		{
			
			if (cond) {
				__bmp = bitmap ;
				drawBackground(cond) ;
				showBackFrame(cond) ;
			}else {
				showBackFrame(cond) ;
			}
		}
		
		private function onBackgroundResize(e:Event):void 
		{
			drawBackground(false) ;
			drawBackground() ;
		}
		private function drawBackground(cond:Boolean = true):void 
		{
			if (cond) {
				if (__bmp) {
					__bmp = scaleBitmap(__bmp, stage.stageWidth, stage.stageHeight) ;
					__background.addChild(__bmp) ;
				}
			}else {
				if (__bmp) {
					__background.removeChild(__bmp) ;
				}
			}
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////// SPACENAV
		private function createSpaceNav():void 
		{
			spaceNav = XContext.$get(Sprite).attr({id:__model.spaceNav.id, name:__model.spaceNav.id})[0] ;
			Draw.draw('rect', { g:spaceNav.graphics, color:0x000000, alpha:.92 }, 0, 0, stage.stageWidth, stage.stageHeight) ;
			target.addChild(spaceNav) ;
			spaceNav.visible = false ;
			spaceNav.addEventListener(Event.RESIZE, onSpaceNavResize) ;
			StageResize.instance.handle(spaceNav) ;
		}
		private function onSpaceNavResize(e:Event):void 
		{
			Draw.draw('rect', { g:spaceNav.graphics, color:0x000000, alpha:.92 }, 0, 0, stage.stageWidth, stage.stageHeight) ;
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////// BASICNAV
		private function createBasicNav():void 
		{
			basicNav = XContext.$get(Smart).attr( { id:__model.simpleNav.id, name:__model.simpleNav.id } ).appendTo('#nav')[0] ;
			///////////////////////////////// LOGO
			var logo:BehaviorSmart = XContext.$get(BehaviorSmart).attr( { 
				id:__model.simpleNav.logo.id, name:__model.simpleNav.logo.id
			} )[0] ;
			
			var emargement:int = 40 ;
			
			/////////////////////////// COLORS
			var col:uint = __model.colors.main ;
			var colOver:uint = __model.colors.mainOver ;
			var extraCol:uint = __model.colors.extra ;
			var extraColOver:uint = __model.colors.extraOver ;
			
			/////////////////////////// IMG SHOE
			
			var shoe:Bitmap = __model.simpleNavLogoPNG ;
			Draw.draw("rect", { g:logo.graphics, color:col, alpha:1 }, 0, 0, __model.simpleNav.logo.width, __model.simpleNav.logo.height) ;
			logo.addChild(shoe) ;
			logo.x = emargement+ __model.simpleNav.margin ;
			logo.y = __model.simpleNav.margin ;
			logo.mouseChildren = false ;
			logo.focusRect = false ;
			logo.tabIndex = focusIndex ++ ;
			logo.properties.graphics = logo.graphics ;
			logo.properties.over = function(cond:Boolean):void {
				if (cond) {
					Draw.redraw("rect", { g:this.graphics, color:getExtraColOver(), alpha:1 }, 0, 0, __model.simpleNav.logo.width, __model.simpleNav.logo.height) ;
				}else {
					Draw.redraw("rect", { g:this.graphics, color:getCol(), alpha:1 }, 0, 0, __model.simpleNav.logo.width, __model.simpleNav.logo.height) ;
				}
			}
			logo.properties.over(false) ;
			logo.properties.id = __model.simpleNav.logo.id ;
			logo.properties.enter = function():void {
				__controller.launchSection('HOME') ;
			}
			logo.buttonMode = true ;
			basicNav.addChild(logo) ;
			///////////////////////////////// CREATE ITEMS
			var last:BehaviorSmart ;
			for each(var section:XML in __model.sectionsXML.child('section')) {
				var id:String = section.attribute('id')[0].toXMLString() ;
				if (id == 'HOME') continue ;
				var label:String = section.attribute('label')[0].toXMLString() ;
				var index:int = section.childIndex() ;
				var item:BehaviorSmart = XContext.$get(BehaviorSmart).attr( { 
					id:__model.simpleNav.item.name + id , name:__model.simpleNav.item.name + id,
					x: Boolean(last) ?(last.x + last.width) + __model.simpleNav.margin : emargement + __model.simpleNav.margin * 1.5 + __model.simpleNav.logo.width + 15, y: 5 ,
					mouseChildren: false, focusRect: false, tabIndex: focusIndex++
				} )[0] ;
				///////////////////////////////// BACK
				///////////////////////////////// TEXTFIELD
				var tf:TextField = item.properties.textfield = XContext.$get(__model.simpleNavXML)
				.attr( { id:__model.simpleNav.item.tf.name + id , name:__model.simpleNav.item.tf.name + id, text:label.toUpperCase(), x:__model.simpleNav.margin/2, y:__model.simpleNav.margin/4} )
				.appendTo(item)[0] ;
				
				///////////////////////////////// ITEM
				Draw.draw("rect", { g:item.graphics, color:extraColOver, alpha:0}, 0, 0, tf.width + __model.simpleNav.margin, __model.simpleNav.logo.height) ;
				if (index != 0) {
					Draw.draw("rect", { g:basicNav.graphics, color:col, alpha:0 }, item.x - __model.simpleNav.margin/2 - 1  , item.y + tf.y, 1, tf.height) ;
				}
				last = BehaviorSmart(basicNav.addChild(item)) ;
				
				item.properties.over = function(cond:Boolean):void {
					var fmt:TextFormat = this.textfield.getTextFormat() ;
					if (cond) {
						fmt.color = getColOver() ;
					}else {
						fmt.color = getCol() ;
					}
					this.textfield.setTextFormat(fmt) ;
				}
				item.properties.over(false) ;
				
				item.properties.id = id ;
				item.properties.enter = function():void {
					__controller.launchSection(this.id) ;
				}
				item.buttonMode = true ;
				applyDropShadow(item) ;
			}
			var l:int = basicNav.numChildren ;
			Smart(basicNav).properties.draw = function(e:Event = null):void { 
				if (Smart(basicNav).properties.secundary) {
					var child:DisplayObject = basicNav.getChildAt(basicNav.numChildren - 1) ;
					Draw.redraw('rect', { g:basicNav.graphics, color:0xFFFFFF, alpha:0 }, 0, 0, child.x + child.width + 20, logo.height) ;
				}else {
					Draw.redraw('rect', { g:basicNav.graphics, color:0xFFFFFF, alpha:.05 }, 0, 0, stage.stageWidth, __model.simpleNav.margin*2 + logo.height) ;
				}
				
				basicNav.y = stage.stageHeight - logo.height ;
			}
			Smart(basicNav).properties.resetColor = function():void { 
				for (var i:int = 0 ; i < l ; i++ ) {
					BehaviorSmart(basicNav.getChildAt(i)).properties.over(false) ;
				}
			}
			
			basicNav.addEventListener(Event.RESIZE, basicNav.properties.draw) ;
			StageResize.instance.handle(basicNav) ;
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////// BASICNAV
		private function createDepthNav():void 
		{
			depthNav = $get(Smart).attr( { id:__model.depthNav.id, name:__model.depthNav.id, x:__model.minFrame.width >> 1, y: -85 } ).appendTo(minFrame)[0] ;
			
			depthNav.properties.resetColor = function():void {
				var l:int = depthNav.numChildren ;
				for (var i:int = 0 ; i < l ; i++ ) {
					var smart:Smart = Smart(depthNav.getChildAt(0)) ;
					smart.properties.resetColor(false) ;
				}
			}
			
		}
		private function getCol():uint {
			return __model.colors.main ;
		}
		private function getColOver():uint {
			return __model.colors.mainOver ;
		}
		private function getExtraColOver():uint {
			return __model.colors.extraOver ;
		}
		public function execBasicNavOver(s:Sprite, cond:Boolean):void 
		{
			Smart(s).properties.over(cond) ;
		}
		public function execLogoOver(cond:Boolean):void 
		{
			XContext.$get('#' + __model.simpleNav.logo.id)[0].properties.over(cond) ;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////// FRAME
		private function createFrame():void 
		{
			frame = XContext.$get(Sprite).attr( { id:__model.frame.id, name:__model.frame.id } )[0] ;
			frame.visible = false ;
			
			Draw.draw('rect', { g:frame.graphics, color:0xFFFFFF, alpha: 0 }, 0, 0, __model.frame.width, __model.frame.height) ;
			minFrame =  XContext.$get(Sprite).attr({id:__model.minFrame.id, name:__model.minFrame.id})[0] ;
			Draw.draw('rect', { g:minFrame.graphics, color:0xFFFFFF, alpha: 0 }, 0, 0, __model.minFrame.width, __model.minFrame.height) ;
			minFrame.x = (__model.frame.width - __model.minFrame.width) >> 1 ;
			frame.addChild(minFrame) ;
			target.addChild(frame) ;
			frame.addEventListener(Event.RESIZE, onFrameResize) ;
			StageResize.instance.handle(frame) ;
		}
				
		public function showBackFrame(cond:Boolean = true):void 
		{
			if (cond) {
				__background.visible = true ;
				TweenLite.killTweensOf(__background) ;
				TweenLite.to(__background, .25, { alpha: 1 } ) ;
			}else {
				TweenLite.killTweensOf(__background) ;
				TweenLite.to(__background, .25, {alpha: 0, onComplete:function():void {
					__background.visible = false ;
					drawBackground(false) ;
					__bmp = null ;
				}}) ;
			}
		}
		
		public function layerError(layer:Layer, cond:Boolean = true):void 
		{
			if (cond) {
				$get('#universe')[0].visible = false ;
				stage.addChild(layer) ;
				var content404:Sprite = $get(__model.layer404_XML).appendTo(layer)[0] ;
				var titleTF:TextField = TextField(content404.getChildByName('layer_404_title')) ;
				var h3TF:TextField = TextField(content404.getChildByName('layer_404_h3')) ;
				var txtTF:TextField = TextField(content404.getChildByName('layer_404_txt')) ;
				var childline:Shape = new Shape() ;
				childline.x = titleTF.x - 20 ;
				childline.y = h3TF.y + h3TF.height + 20 ;
				Draw.redraw('rect', { g:childline.graphics, color:0x2A2A2A, alpha:.35 }, 0, 0 , layer.width - (childline.x<<1), 1) ;
				
				var txtFmt:TextFormat = txtTF.defaultTextFormat ;
				txtFmt.color = __model.colors.extraOver ;
				var ttlFmt:TextFormat = titleTF.defaultTextFormat ;
				ttlFmt.color = __model.colors.extraOver ;
				ttlFmt.size = 25 ;
				var n:int = txtTF.text.length ;
				var n2:int = titleTF.text.length ;
				
				titleTF.appendText('		 [' + layer.properties.actualPath + ']') ;
				titleTF.setTextFormat(ttlFmt, n2, titleTF.text.length) ;
				txtTF.appendText('> ' + layer.properties.errorPath) ;
				txtTF.setTextFormat(txtFmt, n, txtTF.text.length) ;
				
				applyDropShadow(layer) ;
				content404.addChild(childline) ;
				
			}else {
				stage.removeChild(layer) ;
				applyDropShadow(layer, false) ;
				layer = layer.destroy() ;
				$get('#universe')[0].visible = true ;
				setFocus(lastFocused) ;
			}
		}
		
		public function resetColor():void 
		{
			basicNav.properties.resetColor() ;
			resetArrowsColor() ;
			resetDepthNavColor() ;
		}
		
		private function resetDepthNavColor():void 
		{
			depthNav.properties.resetColor() ;
		}
		
		private function resetArrowsColor():void 
		{
			var left:Smart, right:Smart, top:Smart, bottom:Smart ;
			if (Boolean($get('#left')[0])) {
				left = $get('#left')[0] ;
				if (left.properties) {
					left.properties.resetColor() ;
				}
			}
			if (Boolean($get('#right')[0])) {
				right = $get('#right')[0] ;
				if (right.properties) {
					right.properties.resetColor() ;
				}
			}
			if (Boolean($get('#top')[0])) {
				top = $get('#top')[0] ;
				if (top.properties) {
					top.properties.resetColor() ;
				}
			}
			if (Boolean($get('#bottom')[0])) {
				bottom = $get('#bottom')[0] ;
				if (bottom.properties) {
					bottom.properties.resetColor() ;
				}
			}
		}
		
		private function onFrameResize(e:Event):void 
		{
			frame.x = (stage.stageWidth - __model.frame.width) >> 1 ;
			frame.y = (stage.stageHeight - __model.frame.height) >> 1 ;
		}
		
		public function get stage():Stage { return BasicView.stage }
		public function set stage(value:Stage):void { BasicView.stage = value }
		public function get target():Sprite { return BasicView.target }
		public function set target(value:Sprite):void { BasicView.target = value }
		public function get spaceNav():Sprite { return BasicView.spaceNav }
		public function set spaceNav(value:Sprite):void { BasicView.spaceNav = value }
		public function get basicNav():Sprite { return BasicView.basicNav }
		public function set basicNav(value:Sprite):void { BasicView.basicNav = value }
		public function get frame():Sprite { return BasicView.frame }
		public function set frame(value:Sprite):void { BasicView.frame = value }
		public function get minFrame():Sprite { return BasicView.minFrame }
		public function set minFrame(value:Sprite):void { BasicView.minFrame = value }
		static public function get focusIndex():int { return BasicView.focusIndex }
		static public function set focusIndex(value:int):void { BasicView.focusIndex = value }
	}
}