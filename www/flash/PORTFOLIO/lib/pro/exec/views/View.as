package pro.exec.views 
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import of.app.required.context.XContext;
	import pro.exec.ExecuteController;
	import pro.exec.ExecuteModel;
	import pro.exec.ExecuteView;
	import pro.exec.modules.Module;
	import pro.exec.required.ArrowSmart;
	import tools.fl.sprites.BehaviorSmart;
	import tools.fl.sprites.Smart;
	/**
	 * ...
	 * @author saz
	 */
	public class View extends BasicView
	{
		
		private var __module:Module;
		private var __execModel:ExecuteModel;
		private var __execController:ExecuteController;
		private var __execView:ExecuteView;
		private var __content:Sprite;
		
		public function View(module:Module = null) 
		{
			__module = module ;
			__execController = ExecuteController.instance ;
			__execView = __execController.execView ;
			__execModel = __execController.execModel ;
		}
		
		
		public function addToDepthNav(cond:Boolean = true):void 
		{
			var link:BehaviorSmart ;
			var id:String = __module.step.id ;
			var label:String = __module.step.xml.@label.toXMLString() ;
			var depth:String = __module.step.depth ;
			
			if (cond) {
				if (Boolean(XContext.$get('#depth_' + id )[0])) {
					link = XContext.$get('#depth_' + id )[0] ;
				}else {
					var col:uint = execModel.colors.main ;
					var colOver:uint = execModel.colors.mainOver ;
					var extraCol:uint = execModel.colors.extra ;
					var extraColOver:uint = execModel.colors.extraOver ;
					link = XContext.$get(BehaviorSmart).attr({id:'depth_'+ id , name:'depth_'+ id })[0] ;
					var btnHeight:int = execModel.depthNav.item.height ;
					link.focusRect = false ;
					link.tabIndex = ExecuteView.focusIndex + 4000 + depth ;
					var linkTF:TextField = XContext.$get(execModel.simpleNavXML).attr( { id:'depthTF_' + id, name:'depthTF_' + id } ).appendTo(link)[0] ;
					linkTF.text = label ;
					linkTF.autoSize = 'center' ;
					linkTF.x = -linkTF.width >> 1 ;
					link.y = (btnHeight*(depth-1)) ;
					link.mouseChildren = false ;
					
					link.properties.linkTF = linkTF ;
					link.properties.over = function(cond:Boolean = true):void {
						var linkFmt:TextFormat = this.linkTF.defaultTextFormat ;
						linkFmt.align = 'center' ;
						linkFmt.size = 18 ;
						if (cond) {
							linkFmt.color = colOver ;
							this.linkTF.setTextFormat(linkFmt) ;
						}else {
							linkFmt.color = col ;
							this.linkTF.setTextFormat(linkFmt) ;
						}
					}
					link.properties.over(false) ;
					link.properties.resetColor =  function():void {
						col = execModel.colors.main ;
						colOver = execModel.colors.mainOver ;
						this.over(false) ;
					}
					link.properties.enter =  function():void {
						execController.launchSection(__module.step.path.replace(/^ALL\//, '')) ;
					}
					link.buttonMode = true ;
					
				}
				applyDropShadow(link) ;
				depthNav.addChild(link) ;
			}else {
				applyDropShadow(XContext.$get('#depth_' + id )[0], false) ;
				link = XContext.$get('#depth_' + id ).remove()[0] ;
			}
		}
		
		public function removeArrows():void 
		{
			setFocus() ;
			removeArrowBottom() ;
			removeArrowTop() ;
			removeArrowPrev() ;
			removeArrowNext() ;
		}
		public function removeArrowNext():void 
		{
			if (Boolean(XContext.$get('#right')[0] && XContext.$get('#right')[0].stage)) {
				Smart(XContext.$get('#right').remove().attr( { filters:[] } )[0]).destroy() ;
			}
		}
		public function removeArrowPrev():void 
		{
			if (Boolean(XContext.$get('#left')[0] && XContext.$get('#left')[0].stage)) {
				Smart(XContext.$get('#left').remove().attr({filters:[]})[0]).destroy() ;
			}
		}
		public function removeArrowTop():void 
		{
			if (Boolean(XContext.$get('#top')[0] && XContext.$get('#top')[0].stage)) {
				Smart(XContext.$get('#top').remove().attr({filters:[]})[0]).destroy() ;
			}
		}
		public function removeArrowBottom():void 
		{
			if (Boolean(XContext.$get('#bottom')[0] && XContext.$get('#bottom')[0].stage)) {
				Smart(XContext.$get('#bottom').remove().attr({filters:[]})[0]).destroy() ;
			}
		}
		public function arrowTop():void 
		{
			var top:ArrowSmart = XContext.$get(createArrow('top')).appendTo(frame)[0] ;
			top.x = (execModel.frame.width - ((execModel.frame.arrows.size + execModel.frame.arrows.margin) << 1)) >> 1 ;
			top.y = - (100 + 20) - (top.height >> 1) ;
			top.properties.enter = top.properties.passUp = top.properties.leave = execController.launchUp ;
			top.properties.passDown = function():void {
				execController.currentStep.module.goToCurrentItem() ;
			}
			top.properties.prev = function():void {
				execController.currentStep.module.workingStep.prev() ;
			}
			top.properties.next = function():void {
				execController.currentStep.module.workingStep.next() ;
			}
		}
		public function arrowBottom():void 
		{
			var bottom:ArrowSmart = XContext.$get(createArrow('bottom')).appendTo(frame)[0] ;
			bottom.x = (execModel.frame.width - bottom.width) >> 1 ;
			bottom.y = execModel.frame.height + (bottom.height >> 1) + 20;
			bottom.properties.enter = bottom.properties.passDown = execController.currentStep.module.arrowDown ;
			bottom.properties.leave = bottom.properties.passUp = execController.currentStep.module.goToCurrentItem ;
			bottom.properties.prev = function():void {
				execController.currentStep.module.workingStep.prev() ;
			}
			bottom.properties.next = function():void {
				execController.currentStep.module.workingStep.next() ;
			}
		}
		public function arrowPrev():void 
		{
			var left:ArrowSmart = XContext.$get(createArrow('left')).appendTo(frame)[0] ;
			left.x = 0 ;
			left.y = (execModel.frame.height - left.height) >> 1 ;
			left.properties.passUp = execController.currentStep.module.goToCurrentItem ;
			left.properties.passDown = execController.currentStep.module.goToCurrentItem ;
			left.properties.enter = left.properties.prev = function():void {
				execController.currentStep.module.workingStep.prev() ;
			}
			left.properties.next = function():void {
				execController.currentStep.module.workingStep.next() ;
			}
		}
		public function arrowNext():void 
		{
			var right:ArrowSmart = XContext.$get(createArrow('right')).appendTo(frame)[0] ;
			right.x = execModel.frame.width - right.width ;
			right.y = (execModel.frame.height - right.height) >> 1 ;
			
			right.properties.passUp = execController.currentStep.module.goToCurrentItem ;
			right.properties.passDown = execController.currentStep.module.goToCurrentItem ;
			right.properties.enter = right.properties.next = function():void {
				execController.currentStep.module.workingStep.next() ;
			}
			right.properties.prev = function():void {
				execController.currentStep.module.workingStep.prev() ;
			}
		}
		private function createArrow(way:String):Sprite
		{
			var margin:int = execModel.frame.arrows.margin ;
			var size:int = execModel.frame.arrows.size ;
			var color:uint = execModel.colors.main ;
			var colorOver:uint = execModel.colors.mainOver ;
			var topWidth:uint = execModel.frame.arrows.topWidth ;
			var spr:ArrowSmart = $get(ArrowSmart).attr( {
				id:way , name:way, 
				properties: { margin:margin, size:size, color: color, colorOver:colorOver },
				 mouseChildren:false, focusRect: false
			})[0] ;
			spr.properties.way = way ;
			spr.properties.g = spr.graphics ;
			var r:Rectangle ;
			
			switch(spr.properties.way) {
				case 'top' :
					var mar:int = 2 ;
					r  = new Rectangle(0,0,(size+margin) << 1,size+margin) ;
					var shoe:Bitmap = new Bitmap(execModel.simpleNavLogoPNG.bitmapData, 'auto', true) ;
					
					var home:Smart = new Smart() ;
					home.x =  margin + mar ;
					home.y = margin  + mar ;
					home.properties.show = function(cond:Boolean = true):void {
						home.graphics.clear() ;
						home.graphics.beginFill(0xCCCCCC, 0) ;
						home.graphics.moveTo(mar * 2, size-(mar)) ;
						home.graphics.lineTo(size-mar, mar*2) ;
						home.graphics.lineTo((size *2 - mar*4), size-(mar)) ;
						home.graphics.endFill() ;
						home.alpha = int(cond) ;
						
						shoe.filters = [new ColorMatrixFilter(cond?InvertTypeWhiteColorMatrix: BlackAndWhiteColorMatrix)] ;
					}
					home.properties.show(false) ;
					
					shoe.x = size + margin - mar - (shoe.width >> 1);
					shoe.y = (size >> 1) + margin - mar*2;
					
					spr.properties.home = home ;
					spr.tabIndex = ExecuteView.focusIndex + 3000 ;
					spr.addChild(home) ;
					spr.addChild(shoe) ;
				break ;
				case 'bottom' :
					spr.tabIndex = ExecuteView.focusIndex +5000 ;
					r  = new Rectangle(0,0,(size+margin) << 1,size+(margin << 1)) ;
				break ;
				case 'left' :
					spr.tabIndex = ExecuteView.focusIndex ++ ;
					r  = new Rectangle(0,0,size+(margin << 1),(size+margin) << 1) ;
				break ;
				case 'right' :
					spr.tabIndex = ExecuteView.focusIndex + 2000 ;
					r  = new Rectangle(0,0,size+(margin << 1),(size+margin) << 1) ;
				break ;
			}
			spr.properties.r = r ;
			var b:int = execModel.selection.thickness ;
			spr.properties.over =  function(cond:Boolean):void {
				this.g.lineStyle(b, cond? colorOver : color, 1, true, 'none', CapsStyle.ROUND, JointStyle.ROUND, 4) ;
				switch(this.way) {
					case 'top' :
						this.g.moveTo(this.margin, this.margin + this.size) ;
						this.g.lineTo(this.margin + this.size, this.margin) ;
						this.g.lineTo(this.margin + (this.size << 1), this.margin + this.size) ;
						
						this.home.properties.show(cond) ;
					break ;
					case 'bottom' :
						this.g.moveTo(this.margin, this.margin) ;
						this.g.lineTo(this.margin+ this.size, this.margin+this.size) ;
						this.g.lineTo(this.margin + (this.size << 1), this.margin) ;
					break ;
					case 'left' :
						this.g.moveTo(this.margin + this.size, this.margin) ;
						this.g.lineTo(this.margin, this.margin+this.size) ;
						this.g.lineTo(this.margin + this.size, this.margin + (this.size << 1)) ;
					break ;
					case 'right' :
						this.g.moveTo(this.margin, this.margin) ;
						this.g.lineTo(this.margin+ this.size, this.margin+this.size) ;
						this.g.lineTo(this.margin, this.margin + (this.size << 1)) ;
					break ;
				}				
				this.g.endFill() ;
			}
			
			var g:Graphics = spr.graphics ;
			g.beginFill(0xFFFFFFF, 0)  ;
			g.lineStyle() ;
			g.drawRect(r.x, r.y, r.width, r.height) ;
			g.endFill() ;
			applyDropShadow(spr) ;
			spr.properties.over(false) ;
			spr.buttonMode = true ;
			
			spr.properties.resetColor =  function():void {
				color = this.color = execModel.colors.main ;
				colorOver = this.colorOver = execModel.colors.mainOver ;
				
				this.over(false) ;
			}
			return spr ;
		}
		
		public function highlightSelection(g:Graphics, w:int, h:int, cond:Boolean = true):void 
		{
			var a:int = execModel.selection.corner ;
			var b:int = execModel.selection.thickness ;
			var c:int = b >> 1 ;
			g.clear() ;
			g.lineStyle(b, execModel.colors.main,  cond? 1 : 0, true, 'none', CapsStyle.ROUND, JointStyle.ROUND, 4) ;
			// angle TL
			g.moveTo( -c, -c + a ) ;
			g.lineTo( -c , -c ) ;
			g.lineTo( -c + a , -c ) ;
			// angle TR
			g.moveTo( w + c - a, -c ) ;
			g.lineTo( w + c , -c ) ;
			g.lineTo( w + c , -c + a ) ;
			// angle BR
			g.moveTo( w + c , h + c - a) ;
			g.lineTo( w + c , h + c ) ;
			g.lineTo( w + c - a , h + c ) ;
			// angle BL
			g.moveTo( -c + a , h + c) ;
			g.lineTo( -c , h + c ) ;
			g.lineTo( -c , h + c - a ) ;
		}
		public function get execController():ExecuteController { return __execController }
		public function get execView():ExecuteView { return __execView }
		public function get execModel():ExecuteModel { return __execModel }
		public function get module():Module { return __module }
		
		public function get stage():Stage { return BasicView.stage }
		public function set stage(value:Stage):void { BasicView.stage = value }
		public function get target():Sprite { return BasicView.target }
		public function set target(value:Sprite):void { BasicView.target = value }
		public function get spaceNav():Sprite { return BasicView.spaceNav }
		public function set spaceNav(value:Sprite):void { BasicView.spaceNav = value }
		public function get basicNav():Sprite { return BasicView.basicNav }
		public function set basicNav(value:Sprite):void { BasicView.basicNav = value }
		public function get depthNav():Sprite { return BasicView.depthNav }
		public function set depthNav(value:Sprite):void { BasicView.depthNav = value }
		public function get frame():Sprite { return BasicView.frame }
		public function set frame(value:Sprite):void { BasicView.frame = value }
		public function get minFrame():Sprite { return BasicView.minFrame }
		public function set minFrame(value:Sprite):void { BasicView.minFrame = value }
		public function get content():Sprite { return __content }
		public function set content(value:Sprite):void { __content = value }
		static public function get lastFocused():InteractiveObject { return BasicView.lastFocused }
		static public function get focusIndex():int { return BasicView.focusIndex }
		static public function set focusIndex(value:int):void { BasicView.focusIndex = value }
	}
}