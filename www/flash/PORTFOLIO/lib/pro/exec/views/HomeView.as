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
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import gs.easing.Expo;
	import gs.TweenLite;
	import of.app.required.context.XContext;
	import of.app.required.loading.XAllLoader;
	import of.app.XConsole;
	import pro.exec.ExecuteController;
	import pro.exec.ExecuteModel;
	import pro.exec.ExecuteView;
	import pro.exec.modules.HomeModule;
	import pro.extras.IPlugable;
	import tools.fl.sprites.BehaviorSmart;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	/**
	 * ...
	 * @author saz
	 */
	public class HomeView extends View
	{
		
		private var __idTimeout:uint;
		private var __screen:Smart;
		private var __backVisual:Smart;
		
		public function HomeView(module:HomeModule) 
		{
			super(module) ;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////// HOME
		public function home(cond:Boolean = true):void 
		{
			var content:Sprite ;
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
				return XContext.$get(Sprite).attr({id:'contentHome', name:'contentHome'}).appendTo(minFrame)[0] ;
			}else {
				return null ;
			}
		}
		private function getContent():Sprite 
		{
			return XContext.$get('#contentHome')[0] ;
		}
		
		public function boostSmart(article:XML, smart:Smart):Smart 
		{
			var content:Sprite = getContent() ;
			var midHeight:int = execModel.frame.height >> 1 ;
			var id:String = article.attribute('id')[0].toXMLString() ;
			var index:int = article.childIndex() ;
			var label:String = article.attribute('label')[0].toXMLString() ;
			var size:int = int(article.attribute('size')[0].toXMLString()) ;
			var accroche:String = article.child('h3')[0] ;
			var hiddenXML:XML = article.child('hidden')[0] ;
			var linkXML:XML = hiddenXML.child('link')[0] ;
			var loadUrl:String = hiddenXML.child('load')[0].attribute('url')[0].toXMLString() ;
			
			
			smart.name = id ;
			smart.tabChildren = false ;
			////////////////// ZONES
			var limit:int = 3 ;
			if (size > limit ) size = limit ;
			
			var marginBlock:int = 20 ;
			var marginTxtX:int = 10 ;
			var marginTxtY:int = 20 ;
			
			var top:int = midHeight ;
			var totalSize:int = 600 ;
			var totalInsideSize:int = totalSize - (marginTxtX * (limit - size)) ;
			var baseUnitWidth:int = (totalInsideSize) / limit ;
			var unitSize:int = baseUnitWidth * size ;
			var restSize:int = totalInsideSize - unitSize ;
			var col:uint = execModel.colors.main ;
			var colOver:uint = execModel.colors.mainOver ;
			var extraCol:uint = execModel.colors.extra ;
			var extraColOver:uint = execModel.colors.extraOver ;
			//////////////////////////////// CHILD
			var child:BehaviorSmart = new BehaviorSmart() ;
			child.name = 'child_' + id ;
			child.tabIndex = ExecuteView.focusIndex ++ ;
			child.focusRect = false ;
			var childline:Shape = new Shape() ;
			child.addChild(childline) ;
			child.x = marginBlock ;
			child.y = midHeight ;
			//////////////// CHILDTF
			var childTF:TextField = XContext.$get(execModel.titleTFXML).appendTo(child)[0] ; 
			childTF.wordWrap = true ;
			childTF.width = unitSize - (marginTxtX << 1) ;
			childTF.text = label.toUpperCase() ;
			childTF.y = - childTF.textHeight - marginTxtY ;
			childTF.x = marginTxtX ;
			childTF.mouseEnabled = false ;
			//////////////// CHILDACCROCHETF
			var childAccrocheTF:TextField = XContext.$get(execModel.accrocheTFXML).appendTo(child)[0] ; 
			childAccrocheTF.width = unitSize - (marginTxtX << 1) ;
			childAccrocheTF.text = accroche ;
			childAccrocheTF.y = marginTxtY ;
			childAccrocheTF.x = marginTxtX ;
			childAccrocheTF.mouseEnabled = false ;
			
			// finalize CHILD
			Draw.draw('rect', { g:child.graphics, color:col, alpha:0 }, 0, -50, unitSize, 250) ;
			applyDropShadow(child) ;
			smart.addChild(child) ;
			
			
			
			//////////////// HIDDEN
			var hidden:Sprite = new Sprite() ;
			hidden.mouseEnabled = false ;
			Draw.draw('rect', { g:hidden.graphics, color:col, alpha:0 }, 0, 0 , unitSize, 150) ;
			var hiddenLine:Shape = new Shape() ;
			hiddenLine.y = 150 ;
			hidden.addChild(hiddenLine) ;
			hidden.x =  0
			hidden.y =  50 ;
			
			hidden.alpha = 0 ;
			child.addChild(hidden) ;
			
			//////////////// LINK
			var btnHeight:int = 25 ;
			var link:BehaviorSmart = XContext.$get(BehaviorSmart).attr({ id:'enterHome_' + id, name:'enterHome_' + id})[0] ;
			link.focusRect = false ;
			link.mouseChildren = false ;
			link.tabIndex = ExecuteView.focusIndex ++ ;
			var linkTF:TextField = XContext.$get(execModel.linkTFXML).attr({ name:'TF'}).appendTo(link)[0] ;
			linkTF.text = linkXML.attribute('label')[0].toXMLString() ;
			var linkFmt:TextFormat = linkTF.defaultTextFormat ;
			linkFmt.color = col ;
			linkTF.setTextFormat(linkFmt) ;
			var w:int = linkTF.width ;
			var h:int = linkTF.height ;
			link.x = marginTxtX + linkTF.defaultTextFormat.leftMargin ;
			link.y = 110 ;
			
			link.properties.linkTF = linkTF ;
			link.properties.url = linkXML.attribute('url')[0].toXMLString().toUpperCase() ;
			link.properties.fill = function(col:uint = 0, cond:Boolean = true):void {
				linkFmt.color = cond? colOver : col ;
				linkTF.setTextFormat(linkFmt) ;
				var g:Graphics = link.graphics ;
				g.clear() ;
				if (cond) {
					g.beginFill(col, .93) ;
					g.lineTo(w, 0) ;
					g.lineTo(w+10, h/2) ;
					g.lineTo(w, h) ;
					g.lineTo(0, h) ;
					g.endFill() ;
				}
			}
			link.properties.over = function(cond:Boolean = true):void {
				
				link.graphics.clear() ;
				if (cond) 
					this.fill(extraColOver) ;
				else 
					this.fill(col, false) ;
			}
			link.properties.over(false) ;
			link.buttonMode = true ;
			///////// DOWN & UP , ENTER & ESCAPE
			link.properties.enter = function():void {
				execController.launchSection(this.url) ;
			}
			link.properties.passDown = function():void {
				execController.launchSection(this.url) ;
			}
			link.properties.leave = function():void {
				setFocus(child) ;
			}
			link.properties.passUp = function():void {
				setFocus(child) ;
			}
			link.properties.prev = function():void {
				module.workingStep.prev() ;
			}
			link.properties.next = function():void {
				module.workingStep.next() ;
			}
			hidden.addChild(link) ;
			
			//////////////////////////////// FAKE
			var fake:BehaviorSmart = new BehaviorSmart() ;
			fake.name = 'fake_'+smart.name ;
			fake.tabIndex = ExecuteView.focusIndex++ ;
			fake.focusRect = false ;
			fake.mouseChildren = false ;
			fake.buttonMode = true ;
			//////////////// FAKETF
			var fakeTF:TextField = XContext.$get(execModel.fakeTitleTFXML).appendTo(fake)[0] ;
			var fakeFmt:TextFormat = fakeTF.defaultTextFormat ;
			var fakeAccrocheTF:TextField = XContext.$get(execModel.fakeAccrocheTFXML).appendTo(fake)[0] ; 
			var fakeAccrocheFmt:TextFormat = fakeAccrocheTF.defaultTextFormat ;
			
			if(size !=3){
				var fakeline:Shape = new Shape() ;
				fake.addChild(fakeline) ;
				fake.x = unitSize + marginBlock *2;
				fake.y = midHeight ;
				fakeTF.wordWrap = true ;
				fakeTF.width = restSize  - (marginTxtX << 1) ;
				fakeTF.x = 0 ;
				fakeTF.mouseEnabled = false ;
				
				
				
				//////////////// FAKEACCROCHETF
				fakeAccrocheTF.wordWrap = true ;
				fakeAccrocheTF.width = restSize  - (marginTxtX << 1) ;
				fakeAccrocheTF.y = marginTxtY ;
				fakeAccrocheTF.x = 0 ;
				fakeAccrocheTF.mouseEnabled = false ;
			
				
				Draw.draw('rect', { g:fake.graphics, color:col, alpha:0 }, 0, -50 , restSize, 100) ;
				
				
				fakeFmt.color = fakeAccrocheFmt.color = colOver ;
				
				fakeAccrocheTF.setTextFormat(fakeAccrocheFmt) ;
				
				applyDropShadow(fake) ;
				fake.properties.fake = fake ;
				fake.properties.fakeTF = fakeTF ;
				fake.properties.fakeAccrocheTF = fakeAccrocheTF ;
				fake.properties.fakeline = fakeline ;
				
				Draw.redraw('rect', { g:fakeline.graphics, color:col, alpha:.35 }, 0, 0 , restSize, 1) ;
				
				fake.properties.over =  function(cond:Boolean):void {
					
					if (cond) {
						this.fake.alpha = 1 ;
						fakeFmt.color = fakeAccrocheFmt.color = colOver ;
						this.fakeTF.setTextFormat(fakeFmt) ;
						this.fakeAccrocheTF.setTextFormat(fakeAccrocheFmt) ;
					}else {
						this.fake.alpha = .35 ;
						fakeFmt.color = fakeAccrocheFmt.color = col ;
						this.fakeTF.setTextFormat(fakeFmt) ;
						this.fakeAccrocheTF.setTextFormat(fakeAccrocheFmt) ;
					}
				}
				fake.properties.over(false) ;
				
				fake.properties.enter =  function():void {
					execController.launchNext() ;
					setFocus('enterHome_'+ module.workingStep.currentStep.id) ;
				}
				///////// DOWN & UP , ENTER & ESCAPE
				//fake.properties.enter = link.properties.passDown = function():void {
					//execController.launchNext() ;
					//setFocus('enterHome_'+ module.workingStep.currentStep.id) ;
				//}
				//fake.properties.leave = link.properties.passUp = function():void {
					//setFocus(child) ;
					//setFocus('enterHome_'+ module.workingStep.currentStep.id) ;
				//}
				//fake.properties.prev = function():void {
					//setFocus('enterHome_'+ module.workingStep.currentStep.id) ;
				//}
				//fake.properties.next = function():void {
					//module.workingStep.next() ;
				//}
				smart.addChild(fake) ;
			}
			
			// finalize SMART
			smart.y = 0 ;
			smart.visible = false ;
			smart.alpha = 0 ;
			
			smart.properties.smart = smart ;
			smart.properties.child = child ;
			smart.properties.current = child ;
			smart.properties.fake = fake ;
			smart.properties.loadUrl = loadUrl ;
			if (Boolean(hiddenXML.child('load')[0].attribute('backUrl')[0])) {
				smart.properties.backLoadable = true ;
				smart.properties.loadBackUrl = '../img/' +hiddenXML.child('load')[0].attribute('backUrl')[0].toXMLString() ;
			}
			
			
			child.properties.hidden = hidden ;
			child.properties.link = link ;
			child.properties.childline = childline ;
			child.properties.hiddenLine = hiddenLine ;
			child.properties.childTF = childTF ;
			child.properties.childAccrocheTF = childAccrocheTF ;
			
			fake.properties.fakeTF = fakeTF ;
			fake.properties.fakeAccrocheTF = fakeAccrocheTF ;
			fake.properties.fakeAccrocheFmt = fakeAccrocheFmt ;
			
			
			
			child.properties.over =  function(cond:Boolean):void {
				var titleFmt:TextFormat = this.childTF.defaultTextFormat ;
				var titleAccrocheFmt:TextFormat = this.childAccrocheTF.defaultTextFormat ;
				if (cond) {
					Draw.redraw('rect', { g:this.childline.graphics, color:col, alpha:.35 }, 0, 0 , unitSize, 1) ;
					Draw.redraw('rect', { g:this.hiddenLine.graphics, color:col, alpha:.35 }, 0, 0 , unitSize, 1) ;
					titleFmt.color = titleAccrocheFmt.color = colOver ;
					this.childTF.setTextFormat(titleFmt) ;
					this.childAccrocheTF.setTextFormat(titleAccrocheFmt) ;
				}else {
					Draw.redraw('rect', { g:this.childline.graphics, color:col, alpha:.35 }, 0, 0 , unitSize, 1) ;
					Draw.redraw('rect', { g:this.hiddenLine.graphics, color:col, alpha:.35 }, 0, 0 , unitSize, 1) ;
					titleFmt.color = titleAccrocheFmt.color = col ;
					this.childTF.setTextFormat(titleFmt) ;
					this.childAccrocheTF.setTextFormat(titleAccrocheFmt) ;
				}
			}
			
			child.properties.over(false) ;
			
			child.properties.enter =  function():void {
				setFocus(this.link) ;
			}
			child.properties.passDown = function():void {
				setFocus(this.link) ;
			}
			child.properties.prev = function():void {
				module.workingStep.prev() ;
			}
			child.properties.next = function():void {
				module.workingStep.next() ;
			}
			///////////////////////// SHOW
			smart.properties.displayLoaded = function(cond:Boolean = true):void {
				var loadObj:Object = this.loadedContent ;
				if (cond) {
					this.plugged = true ;
					if(loadObj as Bitmap) 
						fitScreen(Bitmap(loadObj)) ;
					if (loadObj as IPlugable) 
						IPlugable(this.loadedContent).initialize(__screen) ;
				}else {
					if (Boolean(this.plugged)) {
						if(loadObj as Bitmap) 
							fitScreen(Bitmap(loadObj), false) ;
						if (loadObj as IPlugable) {
							IPlugable(this.loadedContent).terminate() ;
						}
						this.loaded = false ;
						this.loadedContent = null ;
					}
					this.plugged = false ;
				}
			}
			smart.properties.funcLoad = function(e:Event):void {
				XAllLoader.removeEventListener(e.type, arguments.callee) ;
				smart.properties.loaded = true ;
				smart.properties.loadedContent = XAllLoader.instance.getAllResponses()[0] ;
				XAllLoader.clean() ;
				smart.properties.displayLoaded() ;
			}

			smart.properties.load = function(cond:Boolean = true):void {
				if (cond) {
					XAllLoader.add(this.loadUrl) ;
					XAllLoader.addEventListener(Event.COMPLETE, this.funcLoad) ;
					XAllLoader.launch() ;
				}else {
					if (XAllLoader.hasEventListener(Event.COMPLETE)) {
						XAllLoader.removeEventListener(Event.COMPLETE, this.funcLoad) ;
						XAllLoader.clean() ;
					}
					this.displayLoaded(false) ;
				}
			}
			smart.properties.loadBackVisual = function(cond:Boolean = true):void {
				var loader:Loader ;
				if (cond) {
					loader = this.backLoader = new Loader() ;
					fitLoader(this.backLoader) ;
					loader.load(new URLRequest(this.loadBackUrl)) ;
				}else {
					loader = this.backLoader ;

					if(Boolean(loader)) fitLoader(loader, false) ;
				}
			}
			smart.properties.showHidden = function(cond:Boolean = true):void {
				if (cond) {
					smart.properties.load(true) ;
					if (smart.properties.backLoadable) {
						backVisualFrameAlpha(cond) ;
						smart.properties.loadBackVisual(cond) ;
					}
				}else {
					smart.properties.load(false) ;
					if (smart.properties.backLoadable) {
						smart.properties.loadBackVisual(cond) ;
						backVisualFrameAlpha(cond) ;	
					}
					
				}
				
				
				TweenLite.killTweensOf(smart.properties.child.properties.hidden) ;
				TweenLite.to(smart.properties.child.properties.hidden, .15, {alpha:int(cond)}) ;
			}
			smart.properties.show = function(cond:Boolean = true):void {
				var smart:Smart = this.smart ;
				var childTF:TextField = this.child.properties.childTF ;
				var fakeTF:TextField = this.fake.properties.fakeTF ;
				var fakeAccrocheTF:TextField = this.fake.properties.fakeAccrocheTF ;
				var startX:int = 0 ;
				var endX:int = 0 ;
				
				if (cond) {
					fakeTF.text = this.step.getNext().userData.label ;
					fakeTF.y = - fakeTF.textHeight - marginTxtY ;
					fakeAccrocheTF.text = this.step.getNext().userData.accroche ;
					fakeTF.setTextFormat(fakeFmt) ;
					fakeAccrocheTF.setTextFormat(this.fake.properties.fakeAccrocheFmt) ;
					smart.visible = true ;
					if(this.step)
					smart.x = this.step.way == 'forward' ? 40 : - 40 ;
					TweenLite.killTweensOf(smart) ;
					TweenLite.to(smart, .3, {ease:Expo.easeOut , alpha: 1, x: startX, onComplete:function(...args:Array):void {
						__idTimeout = setTimeout( smart.properties.showHidden , 250) ;
					}}) ;
					smart.tabChildren = true ;
					setFocus(this.child) ;
				}else {
					clearTimeout(__idTimeout) ;
					smart.properties.showHidden(false) ;
					smart.tabChildren = false ;
					TweenLite.killTweensOf(smart) ;
					TweenLite.to(smart, .3, {ease:Expo.easeOut , alpha: 0, x: this.step.way == 'forward'? endX - 40 : endX + 40 , onComplete:function():void {
						if(smart.properties){
							smart.x = smart.properties.step.way == 'forward'? 40 : - 40 ;
						}
						smart.visible = false ;
					}}) ;
				}
			}
			
			content.addChild(smart) ;
			
			return smart ;
		}
		

		
		private function fitLoader(loader:Loader, cond:Boolean = true):void 
		{
			if (cond) {
				loader.x = -340 ;
				__backVisual.addChild(loader) ;
			} else {
				if(Boolean(loader.parent) && loader.parent == __backVisual) __backVisual.removeChild(loader) ;
				loader.unload() ;
			}
		}
		
		private function fitScreen(bmp:Bitmap, cond:Boolean = true):void 
		{
			var screen:Sprite = $get('#screen')[0] ;
			if (cond) {
				bmp.x = bmp.y = 19 ;
				screen.addChild(bmp) ;
			}else {
				if (bmp) {
					if(bmp.parent && bmp.parent == screen)screen.removeChild(bmp) ;
				}
			}
		}
		
		private function backVisualFrameAlpha(cond:Boolean = true):void 
		{
			if (cond) {
				TweenLite.killTweensOf(__backVisual) ;
				TweenLite.to(__backVisual, .45, {alpha:int(cond)}) ;
			}else {
				__backVisual.alpha = 0 ;
			}
		}
		public function backVisualFrame(cond:Boolean = true):void 
		{
			if (cond) {
				var w:int , h:int = 680 ;
				__backVisual = $get(Smart).attr( { id:'backVisualFrame', name:'backVisualFrame', x:(execModel.frame.width - w) / 2 , y: -60 } )[0] ;
				frame.addChildAt(__backVisual, 0) ;
				var sh:Shape = new Shape() ;
				sh.graphics.beginFill(0x555555) ;
				sh.graphics.moveTo(w >> 1, 0) ;
				sh.graphics.lineTo(w, h  >> 1) ;
				sh.graphics.lineTo(w >> 1, h) ;
				sh.graphics.lineTo(0, h >> 1) ;
				sh.graphics.endFill() ;
				__backVisual.addChild(sh) ;
			}else {
				__backVisual = $get('#backVisualFrame').remove()[0].destroy() ;
			}
		}
		
		public function screen(cond:Boolean = true):void 
		{
			if (cond) {
				var bmp:Bitmap = execModel.screenPNG ;
				__screen = $get(Smart).attr( { id:'screen', name:'screen', x:(execModel.frame.width - bmp.width)/2, y: -50} ).appendTo(frame)[0] ;
				__screen.addChild(bmp) ;
			}else {
				__screen = $get('#screen').remove()[0].destroy() ;
			}
		}
	}
}