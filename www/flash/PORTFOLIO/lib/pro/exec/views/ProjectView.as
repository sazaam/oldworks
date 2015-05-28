package pro.exec.views 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import gs.easing.Expo;
	import gs.TweenLite;
	import of.app.required.context.XContext;
	import of.app.required.resize.StageResize;
	import of.app.required.steps.VirtualSteps;
	import pro.exec.modules.ProjectModule;
	import pro.exec.steps.CustomStep;
	import tools.fl.sprites.BehaviorSmart;
	import tools.fl.sprites.Smart;
	import tools.geom.matrix.GridMatrix;
	import tools.grafix.BloopEffect;
	import tools.grafix.Draw;
	
	/**
	 * ...
	 * @author saz
	 */
	public class ProjectView extends View 
	{
		private var __max:int;
		private var __currentIndex:int = -1;
		private var wraps:Array;
		private var __smarts:Array;
		private var __visibles:Array;
		private var __thumbs:Array;
		private var __imgLoader:Loader;
		private var __currentBitmap:Bitmap;
		private var __loaderAnim:Sprite;
		private var __imageAnim:Sprite;
		private var idTimeout:uint;
		private var __alreadyDisplayedOnce:Boolean;
		private var __currentSmart:Smart;
		
		public function ProjectView(module:ProjectModule) 
		{
			super(module) ;
		}
		public function treatWorksInside(cond:Boolean = true):void 
		{
			var nav:Sprite ;
			var parentContent:Sprite = XContext.$get('#contentInsideWorks')[0] ;
			var background:Sprite = XContext.$get('#background')[0] ;
			var colorMatrixFilter:ColorMatrixFilter =  new ColorMatrixFilter(BlackAndWhiteColorMatrix);
			if (cond) {
				WorksInsideView(CustomStep(module.step.parent).module.view).centerFromOutSide(module.step.parent.gates.merged.indexOf(module.step.parent.gates[module.step.id]))
				CustomStep(module.step.parent).module.workingStep.launch(module.step.id) ;
				TweenLite.killTweensOf(parentContent, true) ;
				TweenLite.to(parentContent, .3, { alpha:0, onComplete:function():void {
					parentContent.visible = false ;
				}})
				
				//background.filters = [colorMatrixFilter] ;
				
				Smart(basicNav).properties.secundary = true ;
				Smart(basicNav).properties.draw() ;
				
				
				removeArrowBottom() ;
				removeArrowNext() ;
				removeArrowPrev() ;
			}else {
				arrowPrev() ;
				arrowNext() ;
				arrowBottom() ;
				
				Smart(basicNav).properties.secundary = false ;
				Smart(basicNav).properties.draw() ;
				
				//background.filters = [] ;
				TweenLite.killTweensOf(parentContent, true) ;
				parentContent.visible = true ;
				TweenLite.to(parentContent, .45, { alpha:1, onComplete:function():void {
					
				}})
				// need to set back focus
				setFocus(WorksInsideView(CustomStep(module.step.parent).module.view).getCurrent() ) ;
			}
		}
		private function setContent(cond:Boolean = true):Sprite 
		{
			if (cond) {
				return $get(Sprite).attr({id:'contentProject', name:'contentProject'}).appendTo('#anim')[0] ;
			}else {
				return $get('#contentProject').remove()[0] ;
			}
		}
		private function getContent():Sprite 
		{
			return XContext.$get('#contentProject')[0] ;
		}
		public function project(cond:Boolean = true):void 
		{
			if (cond) {
				trace('Opening Project', module.step.id) ;
				content = setContent() ;
				//applyDropShadow(content) ;
				//applyInnerShadow(content) ;
			}else {
				trace('Closing Project', module.step.id) ;
				content = getContent() ;
				//applyDropShadow(content, false) ;
				//applyInnerShadow(content, false) ;
				content = setContent(false) ;
			}
		}
		
		public function boostSmart(panel:XML, smart:Smart, total:int):Smart 
		{
			var slidePanel:Sprite = $get('#slidePanel')[0] ;
			var thumbsCont:Sprite = $get('#thumbsContainer')[0] ;
			var loadUrl:String = '../img/'+panel.attribute('url')[0].toXMLString() ;
			var thumbUrl:String = '../img/'+panel.attribute('thumb')[0].toXMLString() ;
			var index:int = panel.childIndex() ;
			var id:int = panel.attribute('id')[0].toXMLString() ;
			
			
			var unitWidth:int = 50 ;
			var unitHeight:int = 26 ;
			var unitSpace:int = 5 ;
			
			
			smart.properties.index = index ;
			smart.properties.loadUrl = loadUrl ;
			smart.properties.thumbUrl = thumbUrl ;
			smart.properties.smart = smart ;
			
			
			
			
			var thumb:BehaviorSmart = 
				smart.properties.thumb = $get(BehaviorSmart).attr( { 
					buttonMode:true, tabIndex: focusIndex++ , name: 'thumb_' + index,
					x:(unitWidth + unitSpace) * index
				} ).appendTo(thumbsCont)[0] ;
			thumb.properties.smart = smart ;
			thumb.properties.thumb = thumb ;
			thumb.properties.draw = function(col:uint, alpha:Number = 1):void {
				Draw.redraw('rect', { g:this.thumb.graphics, color:col, alpha:alpha }, 0, unitHeight, unitWidth, unitHeight*2) ;
			}
			thumb.properties.draw(execModel.colors.extraOver, 1) ;
			thumb.properties.setScrollRect = function(cond:Boolean = true):void {
				var t:Smart = this.thumb ;
				TweenLite.killTweensOf(t, true) ;
				if (cond) {
					TweenLite.to(t, .25, { y: -7 } ) ;
				}else {
					TweenLite.to(t, .25, { y:0 } ) ;
				}
			}
			thumb.properties.over = function(cond:Boolean = true):void {
				if (cond) {
					if (!this.selected) this.thumb.alpha = 1 ;
					this.setScrollRect(true) ;
				}else {
					this.setScrollRect(false) ;
					if (!this.selected) this.thumb.alpha = .4 ;
				}
			}
			thumb.properties.select = function(cond:Boolean = true):void {
				if (cond) {
					this.over() ;
					this.selected = true ;
				}else {
					this.selected = false ;
					this.over(false) ;
				}
			}
			thumb.properties.over(false) ;
			
			thumb.properties.enter = function():void {
				module.workingStep.closeCurrentStep() ;
				module.workingStep.launch(this.smart.properties.index) ;
			}
			
			thumb.properties.leave = function():void {
				module.arrowUp() ;
			}
			
			thumb.properties.passUp = function():void {
				if (slidePanel.properties.opened) {
					slidePanel.properties.open(false) ;
				}
			}
			
			thumb.properties.passDown = function():void {
				if (!slidePanel.properties.opened) {
					slidePanel.properties.open() ;
				}else {
					if (slidePanel.properties.links is Array) {
						setFocus(slidePanel.properties.links[0]) ;
					}
				}
			}
			
			thumb.properties.prev = function():void {
				module.arrowPrev() ;
			}
			
			thumb.properties.next = function():void {
				module.arrowNext() ;
			}
			
			thumb.properties.loadThumb = function(url:String = null, cond:Boolean = true):void {
				var loader:Loader 
				if (cond) {
					loader = this.loader = new Loader() ;
					Loader(loader).mouseEnabled = false ;
					this.thumb.addChild(loader) ;
					loader.load(new URLRequest(url)) ;
				}else {
					loader = this.loader ;
					this.thumb.removeChild(loader) ;
					loader.unload() ;
					loader = null ;
				}
			}
			thumb.properties.loadThumb(thumbUrl) ;
			
			__thumbs.push(thumb) ;
			smart.properties.select = function(cond:Boolean = true):void {
				if (cond) {
					select(this.smart) ;
					setFocus(this.thumb)
				}else {
					select(this.smart, false) ;
					setFocus() ;
				}
			}
			return smart ;
		}
		
		private function select(smart:Smart, cond:Boolean = true):void 
		{
			var thumbsCont:Smart = $get('#thumbsContainer')[0] ;
			var thumb:Smart = smart.properties.thumb ;
			var index:int = smart.properties.index ;
			
			if (cond) {
				var v:Array = __visibles || [].concat(__smarts.slice(index, index + __max)) ;
				var dif:int = index - __currentIndex ;
				var ind:int = v.indexOf(smart) ;
				var newInd:int , r:Rectangle ;
				if (module.workingStep.way == 'forward') {
					if (ind == -1) {
						r = thumbsCont.scrollRect ;
						if (index == 0) {
							newInd  = (__currentIndex + dif) ;
							r.x =  (thumb.width + 5) * newInd ;
							thumbsCont.scrollRect = r ;
							v = [].concat(__smarts.slice(index, index + __max)) ;
						}else {
							newInd = (__currentIndex + dif) - (__max - 1) ;
							r.x =  (thumb.width + 5) * newInd ;
							thumbsCont.scrollRect = r ;
							v = [].concat(__smarts.slice(index -(__max - 1), index + 1)) ;
						}
					}
					
				}else{
					if (ind == -1) {
						r = thumbsCont.scrollRect ;
						if (index == __thumbs.length - 1) {
							newInd = (__currentIndex + dif) - (__max - 1) ;
							r.x =  (thumb.width + 5) * newInd ;
							thumbsCont.scrollRect = r ;
							v = [].concat(__smarts.slice(index -(__max - 1), index + 1)) ;
						}else {
							newInd  = (__currentIndex + dif) ;
							r.x =  (thumb.width + 5) * newInd ;
							thumbsCont.scrollRect = r ;
							v = [].concat(__smarts.slice(index, index + __max)) ;
						}
					}
					
				}
				__currentIndex = index ;
				__visibles = v ;
				clearTimeout(idTimeout) ;
				if (__imgLoader) {
					try 
					{
						__imgLoader.close() ;
					}catch (err:Error)
					{
						
					}
					cleanLoadings() ;
				}
				
				// froNav
				var slidePanel:Smart = $get('#slidePanel')[0] ;
				var froNav:Sprite = slidePanel.properties.froNav ;
				froNav['select'](index) ;
				
				idTimeout = setTimeout(loadImage, 600, smart) ;
			}else {
				clearTimeout(idTimeout) ;
			}
		}
		
		private function loadImage(smart:Smart):void 
		{
			if (smart != __currentSmart) {
				var url:String = smart.properties.loadUrl ;
				__imgLoader = new Loader() ;
				__imgLoader.contentLoaderInfo.addEventListener(Event.OPEN, onImageOpen) ;
				__imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete) ;
				
				__imgLoader.load(new URLRequest(url)) ;
			}
			__currentSmart = smart ;
		}
		
		private function onImageOpen(e:Event):void
		{
			loaderAnim() ;
		}
		
		private function loaderAnim(cond:Boolean = true):void 
		{
			var anim:Sprite  = $get('#anim')[0] ;
			if (cond) {
				var itemW:int = 3 ;
				var itemH:int = 3 ;
				var rectangleCont:Rectangle = new Rectangle(0, 0 ,100, 100) ;
				var FroLoadingClass:Class = externals.getDefinition('pro.exec.external.FroLoader') ;
				__loaderAnim = new (FroLoadingClass as Class)(rectangleCont, 10, itemW, itemH, null, NaN, execModel.colors.extraOver) ;
				anim.addChild(__loaderAnim) ;
			}else {
				if (__loaderAnim && __loaderAnim.parent) {
					anim.removeChild(__loaderAnim) ;
				}
				__loaderAnim = null ;
			}
		}
		
		private function onImageComplete(e:Event):void
		{
			treatBitmap(e.target.content) ;
			cleanLoadings() ;
		}
		
		private function treatBitmap(bmp:Bitmap):void
		{
			
			bmp.smoothing = true ;
			animImage(bmp) ;
			__currentBitmap = bmp ;
		}
		
		private function animImage(bmp:Bitmap):void 
		{
			var anim:Sprite = $get('#anim')[0] ;
			var image:Bitmap = $get('#image')[0] ;
			
			var tmp:Bitmap = new Bitmap(image.bitmapData.clone(), 'auto', true) ;
			setBitmapData(tmp, bmp) ;

			
			__imageAnim['bitmapData'] = tmp.bitmapData ;
			__imageAnim.blendMode = 'overlay' ;
			__imageAnim['start'](function():void {
				setBitmapData(image, bmp) ;
				__imageAnim.blendMode = 'overlay' ;
				__imageAnim['kill']() ;
			}) ;
		}
		
		private function redrawImage(bmp:Bitmap = null):void 
		{
			var anim:Sprite = $get('#anim')[0] ;
			var image:Bitmap = $get('#image')[0] ;
			setBitmapData(image, bmp) ;
		}
		
		private function setBitmapData(target:Bitmap, original:Bitmap = null):BitmapData
		{
			var temp:Bitmap = original || __currentBitmap ;
			var coords:Rectangle = getCoords(temp.bitmapData, stage.stageWidth, stage.stageHeight) ;
			target.bitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x0) ;
			target.bitmapData.draw(temp, new Matrix(coords.width / temp.bitmapData.width, 0, 0, coords.height / temp.bitmapData.height, coords.x, coords.y), null, null, null, true) ;
			return target.bitmapData ;
		}
		
		private function cleanLoadings():void
		{
			loaderAnim(false) ;
			if (__imgLoader) {
				__imgLoader.contentLoaderInfo.removeEventListener(Event.OPEN, onImageOpen) ;
				__imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageOpen) ;
				__imgLoader.unload() ;
				__imgLoader = null ;
			}
		}
		
		public function backProject(cond:Boolean = true):void 
		{
			var image:Bitmap ;
			
			if (cond) {
				var CircularMotionZoomFXClass:Class = externals.getDefinition('pro.exec.external.CircularMovementFX') ;
				
				image = $get(new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, true, 0xFF3300), 'auto', true)).attr( { id:'image' }).appendTo('#anim')[0] ;
				__imageAnim = $get(new (CircularMotionZoomFXClass as Class)(null, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight))).appendTo('#anim')[0] ;
				__imageAnim.addEventListener(Event.RESIZE, onImageAnimResize) ;
				StageResize.instance.handle(__imageAnim) ;
			}else {
				image = $get('#image')[0] ;
				StageResize.instance.unhandle(__imageAnim) ;
				__imageAnim.removeEventListener(Event.RESIZE, onImageAnimResize) ;
				$get(__imageAnim).remove() ;
				$get(image).remove() ;
			}
		}
		
		private function onImageAnimResize(e:Event):void 
		{
			//__imageAnim['size'](stage.stageWidth, stage.stageHeight) ;
			__imageAnim['dimensions'] = new Rectangle(0,0, stage.stageWidth, stage.stageHeight) ;
			__imageAnim.scrollRect = __imageAnim['dimensions'] ;
			redrawImage() ;
		}
		
		
		
		public function navProject(cond:Boolean = true):void 
		{
			var slidePanel:Smart , thumbsNav:Smart , thumbsCont:Smart, froNav:Sprite;
			if (cond) {
				var margin:int = execModel.grid.margin ;
				var color:uint = execModel.project.tf.color ;
				
				// SLIDEPANEL
				slidePanel = $get(Smart).attr( { id:'slidePanel', name:'slidePanel' } ).appendTo('#slidenav')[0] ;
				slidePanel.properties.redraw = function(e:Event = null):void {
					Draw.redraw('rect', { g:slidePanel.graphics, color:0x1c1c1c, alpha:.85 }, 0, 0, stage.stageWidth, 350) ;
					slidePanel.properties.locY = slidePanel.properties.opened? stage.stageHeight - 30 - 310 : stage.stageHeight - 30 ;
					slidePanel.y = slidePanel.properties.locY ;
					slidePanel.properties.thumbsNav.x = (stage.stageWidth - thumbsNav.width) >> 1 ; 
				}
				slidePanel.properties.open = function(cond:Boolean = true):void {
					TweenLite.killTweensOf(slidePanel) ;
					if (cond) {
						this.opened = true ;
						secondNav() ;
						TweenLite.to(slidePanel, .25, {ease:Expo.easeOut, y:slidePanel.properties.locY - 310}) ;
					}else {
						this.opened = false ;
						TweenLite.to(slidePanel, .25, { ease:Expo.easeOut, y:slidePanel.properties.locY, onComplete:function():void {
							secondNav(false) ;
						}}) ;
					}
				}
				
				var max:int =__max =  4 ;
				var navWidth:int = 350 ;
				var unitWidth:int = 50 ;
				var unitHeight:int = 26 ;
				var unitSpace:int = 5 ;
				var startY:int = 2 ;
				var totalWidth:int = unitWidth * max + unitSpace * (max - 1) ;
				var startX:int = (navWidth -  totalWidth) >> 1 ;
				
				// THUMBSNAV
				thumbsNav = slidePanel.properties.thumbsNav = $get(Smart).attr( { id:'thumbsNav', name:'thumbsNav' } ).appendTo(slidePanel)[0] ;
				Draw.draw('rect', { g:thumbsNav.graphics, color:0xFF3300, alpha:0}, 0, 0, navWidth, 300) ;
				
				// PREV
				var prev:BehaviorSmart = new BehaviorSmart( { buttonMode:true, mouseChildren:false, tabIndex: focusIndex++ , name: 'prev', y:startY, x:10 + unitSpace } ) ;
				var prevTxt:TextField = prev.properties.tf = $get(execModel.linkTFXML).appendTo(prev)[0] ;
				var arrowFmt:TextFormat = prevTxt.defaultTextFormat ;
				
				prevTxt.text = 'prev' ;
				prev.properties.draw = function(cond:Boolean = true) {
					var col:uint ;
					var alph:Number = .93 ;
					var w:int = this.tf.width ;
					var h:int = unitHeight ;
					var g:Graphics = prev.graphics ;
					g.clear() ;
					if (cond) {
						arrowFmt.color = execModel.colors.extraOver ;
						col = execModel.colors.mainOver ;
						//alph = .35 ;
					}else {
						arrowFmt.color = execModel.colors.mainOver ;
						col = execModel.colors.extraOver ;
					}
					g.beginFill(col, alph) ;
					g.lineTo(w, 0) ;
					g.lineTo(w, h) ;
					g.lineTo(0, h) ;
					g.lineTo(-10, h/2) ;
					g.endFill() ;
					this.tf.setTextFormat(arrowFmt) ;
				}
				prev.properties.draw(false) ;
				
				prev.properties.over = function(cond:Boolean = true) {
					this.draw(cond) ;
				}
				
				prev.properties.enter = function(cond:Boolean = true) {
					execController.launchPrev() ;
				}
				prev.properties.leave = function():void {
					module.arrowUp() ;
				}
				prev.properties.passUp = function():void {
					if (slidePanel.properties.opened) {
						slidePanel.properties.open(false) ;
					}
				}
				prev.properties.passDown = function():void {
					if (!slidePanel.properties.opened) {
						slidePanel.properties.open() ;
					}else {
						if (slidePanel.properties.links is Array) {
							setFocus(slidePanel.properties.links[0]) ;
						}
					}
				}
				prev.properties.prev = function():void {
					module.arrowPrev() ;
				}
				prev.properties.next = function():void {
					module.arrowNext() ;
				}
				
				thumbsNav.addChild(prev) ;
				
				
				
				// THUMBS
				thumbsCont = $get(Smart).attr({id:'thumbsContainer', name:'thumbsContainer', x:startX, y:startY}).appendTo(thumbsNav)[0] ;
				thumbsCont.scrollRect = new Rectangle(0,0, totalWidth, unitHeight) ;
				__thumbs = [] ;
				
				// NEXT
				var next:BehaviorSmart = new BehaviorSmart( { buttonMode:true, mouseChildren:false, tabIndex: focusIndex++ , name: 'next', y:startY, x: navWidth - prev.width - unitSpace } ) ;
				var nextTxt:TextField = next.properties.tf = $get(execModel.linkTFXML).appendTo(next)[0] ;
				nextTxt.text = 'next' ;
				next.properties.draw = function(cond:Boolean = true) {
					var col:uint ;
					var alph:Number = .93 ;
					var w:int = this.tf.width ;
					var h:int = unitHeight ;
					var g:Graphics = next.graphics ;
					g.clear() ;
					if (cond) {
						arrowFmt.color = execModel.colors.extraOver ;
						col = execModel.colors.mainOver ;
						//alph = .35 ;
					}else {
						arrowFmt.color = execModel.colors.mainOver ;
						col = execModel.colors.extraOver ;
					}
					g.beginFill(col, alph) ;
					g.lineTo(w, 0) ;
					g.lineTo(w+10, h/2) ;
					g.lineTo(w, h) ;
					g.lineTo(0, h) ;
					g.endFill() ;
					this.tf.setTextFormat(arrowFmt) ;
				} ;
				next.properties.draw(false) ;
				
				next.properties.over = function(cond:Boolean = true) {
					this.draw(cond) ;
				}
				
				next.properties.enter = function(cond:Boolean = true) {
					execController.launchNext() ;
				}
				next.properties.leave = function():void {
					module.arrowUp() ;
				}
				next.properties.passUp = function():void {
					if (slidePanel.properties.opened) {
						slidePanel.properties.open(false) ;
					}
				}
				next.properties.passDown = function():void {
					if (!slidePanel.properties.opened) {
						slidePanel.properties.open() ;
					}else {
						if (slidePanel.properties.links is Array) {
							setFocus(slidePanel.properties.links[0]) ;
						}
					}
				}
				next.properties.prev = function():void {
					module.arrowPrev() ;
				}
				next.properties.next = function():void {
					module.arrowNext() ;
				}
				
				
				
				thumbsNav.addChild(next) ;
				
				// FRO NAV
				var FroNavClass:Class = externals.getDefinition('pro.exec.external.FroNav') ;
				var total:int = module.step.contents.child('panel').length() ;
				froNav = slidePanel.properties.froNav = new (FroNavClass as Class)(totalWidth, 120, total, execModel.colors.extraOver) ;
				froNav.x = thumbsCont.x ;
				froNav.y = 50 ;
				thumbsNav.addChild(froNav) ;
				froNav['smarts'].forEach(function(el:Smart,i:int,arr:Vector.<Smart>) {
					el.addEventListener(MouseEvent.CLICK, onFroNavClick) ;
					el.addEventListener(MouseEvent.ROLL_OVER, onFroNavOver) ;
					el.addEventListener(MouseEvent.ROLL_OUT, onFroNavOver) ;
				})
				enablePanel() ;
				slidePanel.properties.redraw() ;
				
			}else {
				thumbsNav = $get('#thumbsNav')[0] ;
				slidePanel = $get('#slidePanel')[0] ;
				
				
				
				// kills
				slidePanel.properties.open(false) ;
				enablePanel(false) ;
				
				froNav = slidePanel.properties.froNav ;
				
				froNav['smarts'].forEach(function(el:Smart,i:int,arr:Vector.<Smart>) {
					el.removeEventListener(MouseEvent.CLICK, onFroNavClick) ;
				})
				
				if(froNav.stage) thumbsNav.removeChild(froNav) ;
				
				// removes
				thumbsCont = $get('#thumbsContainer')[0] ;
				var l:int = __thumbs.length ;
				for (var i:int = 0 ; i < l ; i++ ) {
					var th:Smart =  Smart(__thumbs[i]) ;
					th.properties.loadThumb(null, false) ;
				}
				$get('#thumbsNav').remove()[0] ;
				thumbsNav = thumbsNav.destroy() ;
				
				$get('#slidePanel').remove()[0] ;
				slidePanel = slidePanel.destroy() ;
			}
		}
		
		private function secondNav(cond:Boolean = true):void 
		{
			var slidePanel:Smart = $get('#slidePanel')[0] ;
			if (!Boolean(slidePanel) || !Boolean(slidePanel.properties)) return ;
			var froNav:Sprite = slidePanel.properties.froNav ;
			var thumbsNav:Smart = slidePanel.properties.thumbsNav ;
			var thumbsCont:Smart = $get('#thumbsContainer')[0] ;
			var sprCont:Sprite
			if (cond) {
				if (froNav) {
					froNav.visible = true ;
					froNav['loop']() ;
					sprCont = $get(Sprite).attr( { id:'second', name:'second', x:thumbsCont.width+ thumbsCont.x, y:60} ).appendTo(thumbsNav)[0] ;
					var titleTF:TextField = $get(execModel.titleTFXML).attr( { text:module.step.xml.attribute('label')[0].toXMLString() } ).appendTo('#second')[0] ;
					var fmt:TextFormat = titleTF.defaultTextFormat ;
					fmt.color = execModel.colors.extraOver ;
					fmt.size = 45 ;
					titleTF.setTextFormat(fmt) ;
					
					var yearTF:TextField = $get(execModel.titleTFXML).attr( { text:module.step.xml.attribute('year')[0].toXMLString() } ).appendTo('#second')[0] ;
					yearTF.y = -10 ;
					fmt.size = 12 ; 
					fmt.color = 0x676767 ;
					yearTF.setTextFormat(fmt) ;
					
					var links:Array = slidePanel.properties.links = [] ;
					
					if (Boolean(module.step.xml.child('launch').length != 0)) {
						for each(var it:XML in module.step.xml.child('launch')) {
							var url2Launch:String = it.attribute('url')[0].toXMLString() ;
							var txt:String = it.attribute('txt')[0].toXMLString() ;
							var index:int = it.childIndex() ;
							var link:BehaviorSmart = $get(BehaviorSmart).attr( { mouseChildren:false, tabIndex: focusIndex++ , name: 'link_'+index, x:8, y:titleTF.height + 25 + (index*25)} ).appendTo('#second')[0] ;
							var linkTF:TextField = link.properties.tf = $get(execModel.linkTFXML).appendTo(link)[0] ;
							linkTF.text = txt ;
							link.properties.launchUrl = url2Launch ;
							link.properties.index = index ;
							link.properties.link = link ;
							var linkFmt:TextFormat = linkTF.defaultTextFormat ;
							link.properties.draw = function(cond:Boolean = true) {
								var col:uint ;
								var w:int = this.tf.width ;
								var h:int = this.tf.height +2;
								var g:Graphics = this.link.graphics ;
								g.clear() ;
								if (cond) {
									linkFmt.color = execModel.colors.mainOver ;
									col = execModel.colors.extraOver ;
								}else {
									linkFmt.color = 0xFFFFFF ;
									col = 0x444444 ;
								}
								g.beginFill(col, .93) ;
								g.lineTo(w, 0) ;
								g.lineTo(w+10, h/2) ;
								g.lineTo(w, h) ;
								g.lineTo(0, h) ;
								g.endFill() ;
								this.tf.setTextFormat(linkFmt) ;
							} ;
							
							link.properties.over = function(cond:Boolean = true) {
								this.draw(cond) ;
							}
							link.properties.leave = function():void {
								setFocus(__smarts[__currentIndex].properties.thumb) ;
							}
							link.properties.passUp = function():void {
								if (this.index == 0) {
									this.leave() ;
								}else {
									setFocus(links[this.index - 1]) ;
								}
							}
							link.properties.passDown = function():void {
								if (this.index == links.length - 1) {
									
								}else {
									setFocus(links[this.index + 1]) ;
								}
							}
							link.properties.prev = function():void {
								module.arrowPrev() ;
							}
							link.properties.next = function():void {
								module.arrowNext() ;
							}
							link.properties.enter = function(cond:Boolean = true) {
								navigateToURL(new URLRequest(this.launchUrl), '_blank') ;
							} ;
							
							link.properties.draw(false) ;
							links.push(link) ;
						}
					}
					
				}
			}else {
				if (froNav) {
					froNav['noLoop']() ;
					froNav.visible = false ;
					
					if($get('#second')[0])sprCont = $get('#second').remove()[0] ;
					sprCont = null ;
				}
			}
		}
		
		private function onFroNavClick(e:MouseEvent):void 
		{
			var slidePanel:Smart = $get('#slidePanel')[0] ;
			var froNav:Sprite = slidePanel.properties.froNav ;
			var smart:Smart = e.target ;
			var ind:int = froNav['smarts'].indexOf(smart) ;
			//froNav['select'](ind) ;
			
			module.workingStep.closeCurrentStep() ;
			module.workingStep.launch(froNav['smarts'].indexOf(smart)) ;
			
		}
		private function onFroNavOver(e:MouseEvent):void 
		{
			var smart:Smart = e.target ;
			if (e.type == MouseEvent.ROLL_OVER) {
				if(!smart.properties.selected) smart.properties.over() ;
			}else {
				if(!smart.properties.selected) smart.properties.over(false) ;
			}
		}
		
		public function initSmarts():void 
		{
			__smarts = [].concat(module.workingStep.userData.smarts) ;
		}
		
		private function enablePanel(cond:Boolean = true):void 
		{
			var slidePanel:Smart = $get('#slidePanel')[0] ;
			if (cond) {
				slidePanel.addEventListener(Event.RESIZE, slidePanel.properties.redraw) ;
				slidePanel.addEventListener(MouseEvent.ROLL_OVER, onPanelRoll) ;
				slidePanel.addEventListener(MouseEvent.ROLL_OUT, onPanelRoll) ;
				StageResize.instance.handle(slidePanel) ;
			}else {
				StageResize.instance.unhandle(slidePanel) ;
				slidePanel.removeEventListener(Event.RESIZE, slidePanel.properties.redraw) ;
				slidePanel.removeEventListener(MouseEvent.ROLL_OVER, onPanelRoll) ;
				slidePanel.removeEventListener(MouseEvent.ROLL_OUT, onPanelRoll) ;
			}
		}
		
		private function onPanelRoll(e:MouseEvent):void 
		{
			var slidePanel:Smart = $get('#slidePanel')[0] ;
			if (e.type == MouseEvent.ROLL_OVER) {
				if (!slidePanel.properties.opened) {
					slidePanel.properties.open() ;
				}
			}else {
				if (slidePanel.properties.opened) {
					slidePanel.properties.open(false) ;
				}
			}
		}

	}

}