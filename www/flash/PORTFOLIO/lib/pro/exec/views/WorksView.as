package pro.exec.views 
{
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import gs.easing.Expo;
	import gs.easing.Strong;
	import gs.TweenLite;
	import of.app.required.context.XContext;
	import of.app.required.loading.XAllLoader;
	import of.app.required.steps.VirtualSteps;
	import of.app.Root;
	import of.app.XConsole;
	import pro.exec.ExecuteController;
	import pro.exec.ExecuteModel;
	import pro.exec.ExecuteView;
	import pro.exec.modules.WorksModule;
	import pro.extras.IPlugable;
	import tools.fl.sprites.BehaviorSmart;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	/**
	 * ...
	 * @author saz
	 */
	public class WorksView extends View
	{
		
		private var __idTimeout:uint;
		
		public function WorksView(module:WorksModule) 
		{
			super(module) ;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////// WORKS
		public function works(cond:Boolean = true):void 
		{
			if (cond) {
				content = setContent() ;
				frame.alpha = 0 ;
				frame.visible = true ;
				TweenLite.killTweensOf(frame) ;
				TweenLite.to(frame, .25, { alpha:1})
			}else {
				
				content = getContent() ;
				TweenLite.killTweensOf(frame) ;
				TweenLite.to(frame, .25, { alpha:0, onComplete:function():void {
					frame.visible = false ;
					content.parent.removeChild(content) ;
					content = setContent(false) ;
				}})
			}
		}
		
		private function setContent(cond:Boolean = true):Sprite 
		{
			if (cond) {
				return XContext.$get(Sprite).attr({id:'contentWorks', name:'contentWorks'}).appendTo(minFrame)[0] ;
			}else {
				return null ;
			}
		}
		private function getContent():Sprite 
		{
			return XContext.$get('#contentWorks')[0] ;
		}
		
		public function boostSmart(article:XML, smart:Smart):Smart 
		{
			var names:Array = ['prev', 'current', 'next'] ;
			var total:int = names.length ;
			var midHeight:int = execModel.frame.height >> 1 ;
			var id:String = article.attribute('id')[0].toXMLString() ;
			var index:int = article.childIndex() ;
			var label:String = article.attribute('label')[0].toXMLString() ;
			var accroche:String = article.child('h3')[0] ;
			var hiddenXML:XML = article.child('hidden')[0] ;
			var loadUrl:String = hiddenXML.child('load')[0].attribute('url')[0].toXMLString() ;
			
			smart.name = id ;
			smart.tabChildren = false ;
			////////////////// ZONES
			
			var margin:int = 10 ;
			var marginBlock:int = 20 ;
			var marginTxtX:int = 10 ;
			var marginTxtY:int = 20 ;
			
			var top:int = midHeight ;
			var totalSize = 600 ;
			var baseUnitWidth:int = (execModel.minFrame.width-(marginBlock*2) - (margin*(total - 1))) / total ;
			var unitSize:int = baseUnitWidth ;
			var restSize:int = totalSize - unitSize ;
			var unitHeight:int = 240 ;
			
			var col:uint = execModel.colors.main ;
			var colOver:uint = execModel.colors.mainOver ;
			var extraCol:uint = execModel.colors.extra ;
			var extraColOver:uint = execModel.colors.extraOver ;
			
			
			for (var i:int = 0 ; i < total ; i++ ) {
				var name:String = names[i] ;
				var child:BehaviorSmart = new BehaviorSmart() ;
				child.focusRect = false ;
				child.buttonMode = true ;
				child.name = name ;
				smart.properties[name] = child ;
				var childline:Shape = new Shape() ;
				child.addChild(childline) ;
				child.x = marginBlock + (unitSize + margin) * i ;
				child.y = midHeight ;
				var childHeight:int ;
				var tfXML:XML ;
				switch(name) {
					case 'prev' :
						childHeight = 100 ;
						tfXML = execModel.titleTFXML ;
						child.tabIndex = ExecuteView.focusIndex ++ ;
					break ;
					case 'current' :
						childHeight = unitHeight + (childHeight >> 1) ;
						//smart.properties
						tfXML = execModel.centerTitleTFXML ;
						child.tabIndex = ExecuteView.focusIndex ++ ;
					break ;
					case 'next' :
						childHeight = 100 ;
						tfXML = execModel.fakeTitleTFXML ;
						child.tabIndex = ExecuteView.focusIndex ++ ;
					break ;
				}
				Draw.draw('rect', { g:child.graphics, color:col, alpha:0 }, 0, -50, unitSize, childHeight) ;
				//////////////// CHILDTF
				var childTF:TextField = XContext.$get(tfXML).attr( { id:'childTF_' + id } ).appendTo(child)[0] ;
				childTF.mouseEnabled = false ;

				var childFmt:TextFormat = childTF.defaultTextFormat ;
				childFmt.color = col ;
				childTF.wordWrap = true ;
				childTF.width = unitSize - (marginTxtX << 1) ;
				childTF.x = marginTxtX ;
				//////////////// CHILDACCROCHETF
				var align:String = childTF.defaultTextFormat.align ;
				var childAccrocheTF:TextField = XContext.$get(tfXML).appendTo(child)[0] ;
				childAccrocheTF.mouseEnabled = false ;
				var accFmt:TextFormat = childTF.getTextFormat() ;
				accFmt.size = 14 ;
				accFmt.color = col ;
				//childAccrocheTF.defaultTextFormat = accFmt ;
				//childAccrocheTF.autoSize = 'right' ;
				childAccrocheTF.wordWrap = true ;
				childAccrocheTF.width = unitSize - (marginTxtX << 1) ;
				childAccrocheTF.text = accroche ;
				childAccrocheTF.y = marginTxtY ;
				childAccrocheTF.x = marginTxtX ;
					
				if (name == 'current') {
					//////////////// HIDDEN
					var hidden:Sprite = new Sprite() ;
					//hidden.mouseEnabled = false ;
					//hidden.mouseChildren = false ;
					Draw.draw('rect', { g:hidden.graphics, color:col, alpha:0 }, 0, 0 , unitSize, unitHeight) ;
					var hiddenLine:Shape = new Shape() ;
					hiddenLine.y = unitHeight ;
					var hiddenCont:Sprite = new Sprite() ;
					hiddenCont.mouseChildren = false ;
					Draw.draw('rect', { g:hidden.graphics, color:col, alpha:0 }, 0, 0 , unitSize, unitHeight) ;
					hiddenLine.y = unitHeight ;
					hidden.addChild(hiddenLine) ;
					hidden.alpha = 0 ;
					hidden.addChild(hiddenCont) ;
					child.addChildAt(hidden, 0) ;
					
					child.properties.hiddenLine = hiddenLine ;
					child.properties.hiddenCont = hiddenCont ;
					
					
					//////////////// SELECTED
					var selected:Shape = new Shape() ;
					hidden.addChild(selected) ;
					
					//////////////// LINK
					var btnHeight:int = 25 ;
					var link:BehaviorSmart = XContext.$get(BehaviorSmart).attr({ id:'enterWorks_' + id, name:'enterWorks_' + id})[0] ;
					link.focusRect = false ;
					link.tabIndex = ExecuteView.focusIndex ++ ;
					var linkTF:TextField = XContext.$get(execModel.linkTFXML).attr({ name:'TF'}).appendTo(link)[0] ;
					linkTF.text = 'Enter' ;
					var w:int = linkTF.width ;
					var h:int = linkTF.height ;
					link.x = (unitSize - linkTF.width) >> 1 ;
					link.y =  unitHeight + marginBlock ;
					link.mouseChildren = false ;
					link.buttonMode = true ;
					link.properties.linkTF = linkTF ;
					link.properties.fill = function(col:uint = 0 , cond:Boolean = true):void {
						var g:Graphics = link.graphics ;
						g.clear() ;
						if (cond) {
							g.beginFill(col, .93) ;
							g.lineTo(w, 0) ;
							g.lineTo(w, h) ;
							g.lineTo(w/2, h+10) ;
							g.lineTo(0, h) ;
							g.endFill() ;
						}
					}
					link.properties.over = function(cond:Boolean = true):void {
						var linkFmt:TextFormat = this.linkTF.defaultTextFormat ;
						link.graphics.clear() ;
						if (cond) {
							this.fill(extraColOver) ;
							linkFmt.color = colOver ;
							this.linkTF.setTextFormat(linkFmt) ;
						}else {
							this.fill(col, false) ;
							linkFmt.color = col ;
							this.linkTF.setTextFormat(linkFmt) ;
						}
						
					}
					link.properties.over(false) ;
					///////// DOWN & UP , ENTER & ESCAPE
					link.properties.enter = function():void {
						execController.launchDown(module.workingStep.currentStep.id) ;
					}
					link.properties.passDown = function():void {
						execController.launchDown(module.workingStep.currentStep.id) ;
					}
					link.properties.leave = function():void {
						execController.launchUp() ;
					}
					link.properties.passUp = function():void {
						setFocus('top') ;
					}
					link.properties.prev = function():void {
						module.workingStep.prev()
					}
					link.properties.next = function():void {
						module.workingStep.next()
					}
					
					hidden.addChild(link) ;
					
					
					child.properties.selected = selected ;
					Draw.redraw('rect', { g:hiddenLine.graphics, color:col, alpha:.35 }, 0, 0 , unitSize, 1) ;
				
					child.properties.highlightSelected = function(cond:Boolean = true):void {
						highlightSelection(this.selected.graphics, unitSize, unitHeight, cond) ;
					}
					child.properties.highlightSelected() ;
					//hiddenCont.filters = [COLOR_BW] ;
				}
				Draw.redraw('rect', { g:childline.graphics, color:col, alpha:.35 }, 0, 0 , unitSize, 1) ;
				// finalize CHILD
				child.properties.child = child ;
				child.properties.childTF = childTF ;
				child.properties.childAccrocheTF = childAccrocheTF ;
				child.properties.childAccrocheFmt = accFmt ;
				child.properties.childFmt = childFmt ;
				child.properties.childline = childline ;
				child.properties.hidden = hidden ;
				child.properties.hiddenCont = hiddenCont ;
				
				child.properties.link = link ;
				child.properties.fill =  function(ttl:String = '', accr:String = ''):void {
					if (ttl != '' || accr != '') {
						this.childTF.text = ttl ;
						this.childTF.setTextFormat(this.childFmt) ;
						this.childTF.y = - this.childTF.height - marginTxtY ;
						this.childAccrocheTF.text = accr ;
						this.childAccrocheTF.setTextFormat(this.childAccrocheFmt) ;
					}else {
						this.childTF.text = '' ;
						this.childAccrocheTF.text = '' ;
					}
				}
				child.properties.over =  function(cond:Boolean):void {
					if (cond) {
						if (this.selected) {
							
						}else {
							this.child.alpha = 1 ;
						}
					}else {
						if (this.selected) {
							
						}else {
							this.child.alpha = .35 ;
						}
					}
				}
				
				child.properties.over(false) ;
				
				
				///////// ENTER & ESCAPE
				child.properties.enter =  function():void {
					switch(this.child.name) {
						case 'prev' :
							execController.launchPrev() ;
							setFocus('enterWorks_'+ module.workingStep.currentStep.id) ;
						break ;
						case 'current' :
							//setFocus(this.link) ;
							execController.launchDown(module.workingStep.currentStep.id) ;
						break ;
						case 'next' :
							execController.launchNext() ;
							setFocus('enterWorks_'+ module.workingStep.currentStep.id) ;
						break ;
					}
				}
				child.properties.passUp =  child.properties.leave = function():void {
					execController.launchUp() ;
				}
				child.properties.prev =  function():void {
					execController.launchPrev() ;
				}
				child.properties.next =  function():void {
					execController.launchNext() ;
				}
				child.properties.passDown = function():void {
					switch(this.child.name) {
						case 'prev' :
							//execController.launchPrev() ;
							//setFocus('enterWorks_'+ module.workingStep.currentStep.id) ;
							setFocus('#bottom') ;
						break ;
						case 'current' :
							setFocus(this.link) ;
						break ;
						case 'next' :
							//execController.launchNext() ;
							//setFocus('enterWorks_'+ module.workingStep.currentStep.id) ;
							setFocus('#bottom') ;
						break ;
					}
				}
				applyDropShadow(child) ;
				smart.addChild(child) ;
			}
			
			// finalize SMART
			smart.y = -50 ;
			smart.visible = false ;
			smart.alpha = 0 ;
			smart.properties.hiddenCont = smart.properties.current.properties.hiddenCont ;
			smart.properties.smart = smart ;
			smart.properties.loadUrl = '../img/'+loadUrl ;
			
			///////////////////////// SHOW
			
			var _w:int = unitSize ;
			var _h:int = unitHeight ;
			var itemW:int = 3 ;
			var itemH:int = 3 ;
			var rectangleCont:Rectangle = new Rectangle(0, 0 ,_w, _h) ;
			smart.properties.open = function(e:Event):void {
				var FroLoadingClass:Class = externals.getDefinition('pro.exec.external.FroLoader') ;
				smart.properties.loadFro = new (FroLoadingClass as Class)(rectangleCont, 10, itemW, itemH, null, NaN, extraColOver) ;
				smart.properties.hiddenCont.addChild(smart.properties.loadFro) ;
			}
			
			smart.properties.cleanLoadings = function( completeClosure:Function, e:Event = null):void {
				smart.properties.loader.contentLoaderInfo.removeEventListener(Event.OPEN, smart.properties.open) ;
				smart.properties.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeClosure) ;
				smart.properties.loader.unload() ;
				smart.properties.loader.unloadAndStop(true) ;
				smart.properties.loader = null ;
			}
			smart.properties.complete = function(e:Event):void {
				var response:DisplayObject = DisplayObject(smart.properties.loader.content) ;
				smart.properties.cleanLoadings(arguments.callee, e) ;
				
				var bmp:Bitmap = Bitmap(response) ;
				var FXLoadingClass:Class = externals.getDefinition('pro.exec.external.CircularMotionZoomFX') ;
				smart.properties.loadFX = new (FXLoadingClass as Class)(bmp.bitmapData, rectangleCont) ;
				smart.properties.hiddenCont.addChild(smart.properties.loadFX) ;
				smart.properties.loadFX['start']() ;
				smart.properties.hiddenCont.removeChild(smart.properties.loadFro) ;
				smart.properties.loadFro = null ;
			}
			smart.properties.xload = function(cond:Boolean = true):void {
				var cont:Sprite = this.current.properties.hiddenCont ;
				if (cond) {
					this.loader = new Loader() ;
					this.loader.contentLoaderInfo.addEventListener(Event.OPEN, this.open) ;
					this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.complete) ;
					this.loader.load(new URLRequest(this.loadUrl)) ;
				}else {
					if (this.loader) {
						this.cleanLoadings(this.complete) ;
						if (this.loadFro) {
							this.hiddenCont.removeChild(this.loadFro) ;
							this.loadFro = null ;
						}
					}else {
						if (this.loadFX) {
							this.hiddenCont.removeChild(this.loadFX) ;
							this.loadFX = null ;
						}
					}
				}
			}
			
			
			smart.properties.showHidden = function(cond:Boolean = true):void {
				if (!cond) smart.properties.xload(false) ;
				TweenLite.killTweensOf(smart.properties.current.properties.hidden) ;
				TweenLite.to(smart.properties.current.properties.hidden, .15, { alpha:int(cond) , onComplete:function():void { 
					if (cond) smart.properties.xload() ; 
				}} ) ;
			}
			smart.properties.show = function(cond:Boolean = true):void {
				var smart:Smart = this.smart ;
				var prevChild:Smart = this.prev ;
				var curChild:Smart = this.current ;
				var nextChild:Smart = this.next ;
				var startX:int = 0 ;
				var endX:int = 0 ;
				
				if (cond) {
					prevChild.properties.fill(this.step.getPrev().userData.label, this.step.getPrev().userData.accroche) ;
					curChild.properties.fill(this.step.currentStep.userData.label, this.step.currentStep.userData.accroche) ;
					nextChild.properties.fill(this.step.getNext().userData.label, this.step.getNext().userData.accroche) ;
					smart.visible = true ;
					smart.tabChildren = true ;
					if(this.step) smart.x = this.step.way == 'forward' ? 40 : - 40 ;
					TweenLite.killTweensOf(smart) ;
					TweenLite.to(smart, .3, {ease:Expo.easeOut, alpha: 1, x: startX, onComplete:function(...args:Array):void {
						__idTimeout = setTimeout( smart.properties.showHidden , 250) ;
					}}) ;
					setFocus(this.current.properties.link) ;
				}else {
					clearTimeout(__idTimeout) ;
					smart.properties.showHidden(false) ;
					smart.tabChildren = false ;
					TweenLite.killTweensOf(smart) ;
					TweenLite.to(smart, .3, {ease:Expo.easeOut, alpha: 0, x: this.step.way == 'forward'? endX - 40 : endX + 40 , onComplete:function():void {
						if(smart.properties) smart.x = smart.properties.step.way == 'forward'? 40 : - 40 ;
						smart.visible = false ;
					}}) ;
					prevChild.properties.fill() ;
					curChild.properties.fill() ;
					nextChild.properties.fill() ;
					
					setFocus() ;
				}
			}
			content.addChild(smart) ;
			return smart ;
		}
	}
}