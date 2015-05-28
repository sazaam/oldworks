package testing 
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import gs.TweenLite;
	import of.app.required.commands.Command;
	import of.app.required.steps.VirtualSteps;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	
	/**
	 * @author saz
	 */
	
	public class TestNew extends Sprite 
	{
		static private var __focusIndex:int;
		private var __mainSteps:VirtualSteps;
		private var __content:XML;
		private var __container:Sprite;
		private var left:Smart;
		private var right:Smart;
		
		public function TestNew() 
		{
			trace(this) ;
			runTests() ;
		}
		
		private function runTests():void 
		{
			load() ;
		}
		
		private function load():void 
		{
			var loader:URLLoader = new URLLoader() ;
			loader.dataFormat = URLLoaderDataFormat.BINARY ;
			loader.addEventListener(Event.COMPLETE, onXML) ;
			loader.load(new URLRequest('../xml/contents/home.xml')) ;
		}
		
		private function onXML(e:Event):void 
		{
			e.target.removeEventListener(e.type, arguments.callee) ;
			
			__content = XML(e.target.data) ;
			resume() ;
		}
		
		private function resume():void 
		{
			init() ;
			initArrows() ;
			parseXML() ;
			enable() ;
			__mainSteps.next() ;
		}
		
		private function enable():void 
		{
			addEventListener(FocusEvent.FOCUS_IN, onFocus, true) ;
			addEventListener(FocusEvent.FOCUS_OUT, onFocus, true) ;
			
			left.addEventListener(MouseEvent.ROLL_OVER, onOver) ;
			left.addEventListener(MouseEvent.ROLL_OUT, onOver) ;
			left.addEventListener(MouseEvent.CLICK, onClick) ;
			
			right.addEventListener(MouseEvent.ROLL_OVER, onOver) ;
			right.addEventListener(MouseEvent.ROLL_OUT, onOver) ;
			right.addEventListener(MouseEvent.CLICK, onClick) ;
		}
		
		private function init():void 
		{
			
			__container = Sprite(addChild(new Sprite())) ;
			__container.x = 300 ;
			__mainSteps = new VirtualSteps('HOMEMODULE').setUnique() ;
			__mainSteps.looping = true ;
			__mainSteps.userData.smarts = [] ;
		}
		
		private function parseXML():void 
		{
			var articles:XML = __content.child('articles')[0] ;
			for each(var article:XML in articles.*) {
				__mainSteps.userData.smarts.push(createSmart(article)) ;
			}
		}
		
		private function createSmart(article:XML):Smart 
		{
			var id:String = article.attribute('id')[0].toXMLString() ;
			var index:int = article.childIndex() ;
			var label:String = article.attribute('label')[0].toXMLString() ;
			var size:int = int(article.attribute('size')[0].toXMLString()) ;
			var hiddenXML:XML = article.attribute('hidden')[0] ;
			
			var smart:Smart = new Smart() ;
			smart.tabIndex = __focusIndex++ ;
			
			////////////////// ZONES
			//////////////////////////////// CHILD
			var child:Sprite = new Sprite() ;
			Draw.draw('rect', { g:child.graphics, color:0xFFFFFF, alpha:.25 }, 0, 0, 120, 200) ;
			child.x = 20 ;
			child.y = 100 ;
			
			var childTF:TextField = new TextField() ;
			childTF.autoSize = 'left' ;
			childTF.wordWrap = true ;
			childTF.width = 120 ;
			childTF.mouseEnabled = false ;
			childTF.appendText(label) ;
			child.addChild(childTF) ;
			
			smart.addChild(child) ;
			
			
			
			
			
			
			//////////////////////////////// FAKE
			var fake:Smart = new Smart() ;
			
			var remaining:int = 400 - 120 - (20 * 2) ;
			Draw.draw('rect', { g:fake.graphics, color:0xFFFFFF, alpha:.25 }, 0, 0, remaining - 20, 200) ;
			fake.x = 120 + 40;
			fake.y = 100 ;
			fake.tabIndex = __focusIndex++ ;
			
			var fakeFMT:TextFormat = new TextFormat() ;
			fakeFMT.align = TextFormatAlign.RIGHT ;
			
			var fakeTF:TextField = new TextField() ;
			fakeTF.autoSize = TextFieldAutoSize.RIGHT;
			fakeTF.wordWrap = true ;
			fakeTF.width = remaining - 20;
			fakeTF.defaultTextFormat = fakeFMT ;
			
			
			fakeTF.mouseEnabled = false ;
			fake.addChild(fakeTF) ;
			smart.addChild(fake) ;
			
			
			
			////////////////// SETTINGS
			smart.y = 100 ;
			smart.alpha = 0 ;
			smart.properties.child = child ;
			smart.properties.childTF = childTF ;
			smart.properties.fake = fake ;
			smart.properties.fakeTF = fakeTF ;
			smart.properties.smart = smart ;
			
			///////////////////////// SHOW
			smart.properties.show = function(cond:Boolean):void {
				var smart:Smart = this.smart ;
				var childTF:TextField = this.childTF ;
				var fakeTF:TextField = this.fakeTF ;
				var startX:int = 0 ;
				var endX:int = 0 ;
				
				if (cond) {
					
					///////////// FILL
					if (__mainSteps.way == 'forward') {
						this.fakeTF.appendText(__mainSteps.getNext().userData.label) ;
						this.smart.x = 80 ;
						TweenLite.to(this.smart, .3, {alpha: 1, x: startX, onComplete:function(...args:Array):void {
							
						}}) ;
						this.smart.tabEnabled = true ;
						this.child.tabEnabled = true ;
						this.fake.tabEnabled = true ;
					}else {
						this.fakeTF.appendText(__mainSteps.getNext().userData.label) ;
						this.smart.x = -80 ;
						TweenLite.to(this.smart, .3, {alpha: 1, x: startX, onComplete:function():void {
							
							
						}}) ;
						this.smart.tabEnabled = true ;
						this.child.tabEnabled = true ;
						this.fake.tabEnabled = true ;
					}
				}else {
					if (__mainSteps.way == 'forward') {
						this.smart.tabEnabled = false ;
						this.child.tabEnabled = false ;
						this.fake.tabEnabled = false ;
						TweenLite.to(this.smart, .3, {alpha: 0, x: endX - 80, onComplete:function():void {
							smart.x = 80 ;
							fakeTF.text = '' ;
						}}) ;
					}else {
						this.smart.tabEnabled = false ;
						this.child.tabEnabled = false ;
						this.fake.tabEnabled = false ;
						TweenLite.to(this.smart, .3, {alpha: 0, x: endX + 80, onComplete:function():void {
							smart.x = -80 ;
							fakeTF.text = '' ;
						}}) ;
					}
				}
			}
			

			
			
			
			
			/////////////////////// FILL
			__container.addChild(smart) ;
			
			
			/////////////////////// STEP
			var step:VirtualSteps = VirtualSteps(__mainSteps.add(new VirtualSteps(id, new Command(this, onArticle, smart, true), new Command(this, onArticle, smart, false)))) ;
			step.userData.smart = smart ;
			step.userData.smart.properties.step = step ;
			step.userData.label = label ;
			
			return smart ;
		}
		
		private function onArticle(smart:Smart, cond:Boolean = true):void 
		{
			if (cond) {
				smart.properties.show(true) ;
			}else {
				smart.properties.show(false) ;
			}
		}
		
		private function onFocus(e:FocusEvent):void 
		{
			trace(e.target) ;
			if (e.type == FocusEvent.FOCUS_IN) {
				
			}else {
				
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////// STEPS FUNC
		////////////////////////////// PREV
		private function getPrev():VirtualSteps
		{
			return __mainSteps.getPrev() ;
		}
		private function prev():void 
		{
			__mainSteps.prev() ;
		}
		////////////////////////////// NEXT
		private function getNext():VirtualSteps
		{
			return __mainSteps.getNext() ;
		}
		private function next():void 
		{
			__mainSteps.next() ;
		}
		
		
		
		////////////////////////////// ARROWS
		
		private function initArrows():void 
		{
			left = addChild(createArrow('left')) ;
			right = addChild(createArrow('right')) ;
			
			left.y = right.y =  250 ;
			left.x = 200 ;
			right.x = 700 ;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (e.target.name == 'right') {
				next() ;
			}else {
				prev() ;
			}
		}
		
		private function onOver(e:MouseEvent):void 
		{
			var arrow:Smart = Smart(e.target) ;
			arrow.properties.fill(e.type == MouseEvent.ROLL_OVER ? arrow.properties.colorOver : arrow.properties.color ) ;
		}
		
		private function createArrow(way:String):Sprite {
			var arrMargin:int = 20 ;
			var arrSize:int = 50 ;
			var color:uint = 0x2A2A2A ;
			var colorOver:uint = 0xFF0000 ;
			var spr:Smart = new Smart( { margin:arrMargin, size:arrSize, color: color, colorOver:colorOver } ) ;
			spr.name = way ;
			spr.properties.way = way ;
			spr.properties.g = spr.graphics ;
			spr.properties.fill =  function(col:uint):void {
				this.g.lineStyle(1, col, 1, true, 'none', CapsStyle.SQUARE, JointStyle.MITER, 4) ;
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
			
			spr.properties.fill(spr.properties.color) ;
			
			var drop:DropShadowFilter = new DropShadowFilter(1, 90, 0xFFFFFF, 1, 1, 1, 2, 3) ;
			spr.filters = [drop] ;
			
			return spr ;
		}
		
	}
}