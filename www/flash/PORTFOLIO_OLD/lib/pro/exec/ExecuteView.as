package pro.exec 
{
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import frocessing.shape.FShapeSVG;
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
	public class ExecuteView 
	{
		private var __model:ExecuteModel;
		
		private var __stage:Stage;
		private var __target:Sprite;
		private var __spaceNav:Sprite;
		private var __basicNav:Sprite;
		private var __frame:Sprite;
		private var __minFrame:Sprite;
		static private var __focusIndex:int = -1;
		
		public function ExecuteView() 
		{
			
		}
		public function init(executeModel:ExecuteModel):void 
		{
			__model = executeModel  ;
			initStage() ;
			createFrame() ;
			createBasicNav() ;
			createSpaceNav() ;
		}
		
		public function render():void 
		{
			__stage.dispatchEvent(new Event(Event.RESIZE)) ;
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////// STAGE
		private function initStage():void 
		{
			__target = Root.root ;
			__stage = __target.stage ;
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////// SPACENAV
		private function createSpaceNav():void 
		{
			__spaceNav = XContext.$get(Sprite).attr({id:__model.spaceNav.id,name:__model.spaceNav.id})[0] ;
			Draw.draw('rect', { g:__spaceNav.graphics, color:0x000000, alpha:.92 }, 0, 0, __stage.stageWidth, __stage.stageHeight) ;
			__target.addChild(__spaceNav) ;
			__spaceNav.visible = false ;
			__spaceNav.addEventListener(Event.RESIZE, onSpaceNavResize) ;
			StageResize.instance.handle(__spaceNav) ;
		}
		private function onSpaceNavResize(e:Event):void 
		{
			Draw.draw('rect', { g:__spaceNav.graphics, color:0x000000, alpha:.92 }, 0, 0, __stage.stageWidth, __stage.stageHeight) ;
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////// BASICNAV
		private function createBasicNav():void 
		{
			__basicNav = XContext.$get(Sprite).attr( { id:__model.simpleNav.id, name:__model.simpleNav.id } )[0] ;
			///////////////////////////////// LOGO
			var logo:Smart = XContext.$get(Smart).attr( { 
				id:__model.simpleNav.logo.id, name:__model.simpleNav.logo.id, 
				mouseChildren: false, focusRect: false, tabIndex: __focusIndex++
			} )[0] ;
			var logo_svg:XML = __model.simpleNavLogoXML ;
			var fshape:FShapeSVG = new FShapeSVG(logo_svg);
			var shoebox:Sprite = Sprite(fshape.toSprite()) ;
			var mainCont:Sprite = Sprite(shoebox.getChildAt(0)) ;
			var shoeCont:Sprite = Sprite(mainCont.getChildAt(0)) ;
			var shoe:Sprite = Sprite(shoeCont.getChildAt(1)) ;
			Draw.draw("rect", { g:logo.graphics, color:__model.simpleNav.item.tf.color, alpha:1 }, 0, 0, __model.simpleNav.logo.width, __model.simpleNav.logo.height) ;
			logo.addChild(shoe) ;
			shoe.x += __model.simpleNav.logo.shoeX ;
			shoe.y += __model.simpleNav.logo.shoeY ;
			logo.x = __model.simpleNav.margin ;
			logo.y = __model.simpleNav.margin ;
			logo.properties.graphics = logo.graphics ;
			logo.properties.over = function(cond:Boolean):void {
				if (cond) {
					Draw.redraw("rect", { g:this.graphics, color:__model.simpleNav.item.tf.colorOver, alpha:1 }, 0, 0, __model.simpleNav.logo.width, __model.simpleNav.logo.height) ;
				}else {
					Draw.redraw("rect", { g:this.graphics, color:__model.simpleNav.item.tf.color, alpha:1 }, 0, 0, __model.simpleNav.logo.width, __model.simpleNav.logo.height) ;
				}
			}
			
			__basicNav.addChild(logo) ;
			///////////////////////////////// CREATE ITEMS
			var last:Smart ;
			for each(var section:XML in __model.sectionsXML.child('section')) {
				var id:String = section.attribute('id')[0].toXMLString() ;
				if (id == 'HOME') continue ;
				var label:String = section.attribute('label')[0].toXMLString() ;
				var index:int = section.childIndex() ;
				var item:Smart = XContext.$get(Smart).attr( { 
					id:__model.simpleNav.item.name + id , name:__model.simpleNav.item.name + id,
					x: Boolean(last) ?(last.x + last.width) + __model.simpleNav.margin : __model.simpleNav.margin*1.5 + __model.simpleNav.logo.width, y: __model.simpleNav.margin,
					mouseChildren: false, focusRect: false, tabIndex: __focusIndex++
				} )[0] ;
				///////////////////////////////// BACK
				var back:Shape = item.properties.back = XContext.$get(Shape).attr({name:'back', alpha:0}).appendTo(item)[0] ;
				///////////////////////////////// TEXTFIELD
				var tf:TextField = item.properties.textfield = XContext.$get(__model.simpleNavXML)
				.attr( { id:__model.simpleNav.item.tf.name + id , name:__model.simpleNav.item.tf.name + id, text:label, x:__model.simpleNav.margin/2, y:__model.simpleNav.margin/4} )
				.appendTo(item)[0] ;
				///////////////////////////////// ITEM
				Draw.draw("rect", { g:item.properties.back.graphics, color:0xFFFFFF, alpha:1 }, 0, 0, tf.width + __model.simpleNav.margin, __model.simpleNav.logo.height) ;
				if (index != 0) {
					Draw.draw("rect", { g:__basicNav.graphics, color:__model.simpleNav.item.tf.color, alpha:.2 }, item.x - __model.simpleNav.margin/2 - 1  , item.y + tf.y, 1, tf.height) ;
				}
				last = Smart(__basicNav.addChild(item)) ;
				
				item.properties.over = function(cond:Boolean):void {
					var fmt:TextFormat = this.textfield.getTextFormat() ;
					if (cond) {
						fmt.color = __model.simpleNav.item.tf.colorOver ;
					}else {
						fmt.color = __model.simpleNav.item.tf.color ;
					}
					this.textfield.setTextFormat(fmt) ;
				}
			}
			
			Draw.draw('rect', { g:__basicNav.graphics, color:0xFFFFFF, alpha:.15 }, 0, 0, __basicNav.width + __model.simpleNav.margin*2, __model.simpleNav.margin*2 + logo.height) ;
			__target.addChild(__basicNav) ;
			__basicNav.addEventListener(Event.RESIZE, onBasicNavResize) ;
			StageResize.instance.handle(__basicNav) ;
		}
		private function onBasicNavResize(e:Event):void 
		{
			__basicNav.x = __model.simpleNav.x ;
			__basicNav.y = __stage.stageHeight - __basicNav.height - __model.simpleNav.y ;
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
			__frame = XContext.$get(Sprite).attr({id:__model.frame.id,name:__model.frame.id})[0] ;
			Draw.draw('rect', { g:__frame.graphics, color:0xFFFFFF, alpha: 0 }, 0, 0, __model.frame.width, __model.frame.height) ;
			__minFrame =  XContext.$get(Sprite).attr({id:__model.minFrame.id, name:__model.minFrame.id})[0] ;
			Draw.draw('rect', { g:__minFrame.graphics, color:0xFFFFFF, alpha: 0 }, 0, 0, __model.minFrame.width, __model.minFrame.height) ;
			__minFrame.x = (__model.frame.width - __model.minFrame.width) >> 1 ;
			__frame.addChild(__minFrame) ;
			__target.addChild(__frame) ;
			__frame.addEventListener(Event.RESIZE, onFrameResize) ;
			StageResize.instance.handle(__frame) ;
		}
		private function onFrameResize(e:Event):void 
		{
			__frame.x = (__stage.stageWidth - __model.frame.width) >> 1 ;
			__frame.y = (__stage.stageHeight - __model.frame.height) >> 1 ;
		}
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////// HOME
		public function home(cond:Boolean = true):void 
		{
			var content:Sprite ;
			var left:Smart ;
			var right:Smart ;
			if (cond) {
				content = XContext.$get(Sprite).attr( { id:'contentHome', name:'contentHome' } ).appendTo(__minFrame)[0] ;
				content.alpha = 0 ;
				left = XContext.$get(__frame.addChild(createArrow('left'))).bind(MouseEvent.ROLL_OVER, onArrowOver).bind(MouseEvent.ROLL_OUT, onArrowOver)[0] ;
				right = XContext.$get(__frame.addChild(createArrow('right'))).bind(MouseEvent.ROLL_OVER, onArrowOver).bind(MouseEvent.ROLL_OUT, onArrowOver)[0] ;
				left.x = 0 ;
				right.x = __model.frame.width - right.width ;
				left.y = right.y = (__model.frame.height - left.height) >> 1 ;
				TweenLite.to(content, .25, { alpha:1, 
				onUpdate:function():void {
					left.alpha = right.alpha = content.alpha ;
				}})
			}else {
				content = XContext.$get('#contentHome')[0] ;
				left = XContext.$get('#left').unbind(MouseEvent.ROLL_OVER, onArrowOver).unbind(MouseEvent.ROLL_OUT, onArrowOver)[0] ;
				right = XContext.$get('#right').unbind(MouseEvent.ROLL_OVER, onArrowOver).unbind(MouseEvent.ROLL_OUT, onArrowOver)[0] ;
				TweenLite.to(content, .25, { alpha:0, onComplete:function():void {
					XContext.$get(left).remove().attr({filters:[]}) ;
					XContext.$get(right).remove().attr({filters:[]}) ;
					XContext.$get(content).remove() ;
				}, 
				onUpdate:function():void {
					left.alpha = right.alpha = content.alpha ;
				}})
			}
		}
		
		public function fillHome(articles:XML):void 
		{
			var content:Sprite = XContext.$get('#contentHome')[0] ;
			for each(var article:XML in articles.*) {					
				trace(article.toXMLString() ) ;
				var index:int = article.childIndex() ;
				var art:Smart = new Smart() ;
				Draw.draw('rect', { g:art.graphics, color:0xFFFFFF, alpha:.15 }, 0, 0, __model.minFrame.width, __model.minFrame.height) ;
				art.x = index * (art.width + 1)  ;
				content.addChild(art) ;
			}
		}
		
		public function setHomeCurrent(ind:int):void 
		{
			
		}
		
		private function onArrowOver(e:MouseEvent):void 
		{
			var arrow:Smart = Smart(e.target) ;
			arrow.properties.over(e.type == MouseEvent.ROLL_OVER) ;
		}
		
		private function createArrow(way:String):Sprite
		{
			var arrMargin:int = __model.frame.arrows.margin ;
			var arrSize:int = __model.frame.arrows.size ;
			var color:uint = __model.frame.arrows.color ;
			var colorOver:uint = __model.frame.arrows.colorOver ;
			var spr:Smart = XContext.$check(Smart, way).attr( {
				id:way , name:way, 
				properties: { margin:arrMargin, size:arrSize, color: color, colorOver:colorOver },
				 mouseChildren:false, focusRect: false, tabIndex: __focusIndex++
			})[0] ;
			spr.properties.way = way ;
			spr.properties.g = spr.graphics ;
			spr.properties.over =  function(cond:Boolean):void {
				this.g.lineStyle(1, cond? this.colorOver : this.color, 1, true, 'none', CapsStyle.SQUARE, JointStyle.MITER, 4) ;
				if (this.way == 'left') {
					this.g.moveTo(this.margin + this.size, this.margin) ;
					this.g.lineTo(this.margin, this.margin+this.size) ;
					this.g.lineTo(this.margin+this.size, this.margin+this.size*2) ;
				}else {
					this.g.moveTo(this.margin, this.margin) ;
					this.g.lineTo(this.margin+ this.size, this.margin+this.size) ;
					this.g.lineTo(this.margin, this.margin+this.size*2) ;
				}
				this.g.endFill() ;
			}
			var g:Graphics = spr.graphics ;
			g.beginFill(0xFFFFFFF, 0)  ;
			g.lineStyle() ;
			g.drawRect(0,0,arrSize+arrMargin*2,arrSize*2+arrMargin*2)
			g.endFill() ;
			applyDropShadow(spr) ;
			spr.properties.over(false) ;
			return spr ;
		}
		
		private function applyDropShadow(spr:DisplayObject):void 
		{
			var drop:DropShadowFilter = new DropShadowFilter(1, 90, 0xFFFFFF, 1, 1, 1, 2, 3) ;
			spr.filters = spr.filters.concat(drop) ;
		}
		
		
		public function get stage():Stage { return __stage }
		public function get target():Sprite { return __target }
		public function get spaceNav():Sprite { return __spaceNav }
		public function get basicNav():Sprite { return __basicNav }
		public function get frame():Sprite { return __frame }
		public function get minFrame():Sprite { return __minFrame }
	}
}