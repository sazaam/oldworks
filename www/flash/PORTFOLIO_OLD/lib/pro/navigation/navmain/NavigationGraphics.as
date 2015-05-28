package pro.navigation.navmain 
{
	/**
	 * ...
	 * @author saz
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite ;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import frocessing.shape.FShapeSVG;
	import gs.TweenLite;
	import of.app.required.context.XContext;
	import of.app.required.dialog.XExternalDialoger;
	import of.app.required.loading.XLoader;
	import of.app.required.resize.StageResize;
	import of.app.required.steps.VirtualSteps;
	import of.app.Root;
	import of.app.XConsole;
	import pro.steps.CustomStep;
	import pro.steps.NavHierarchy;
	import tools.fl.sprites.Smart;
	import tools.grafix.BloopEffect;
	import tools.grafix.Draw;
	public class NavigationGraphics {
	//////////////////////////////////////////////////////// VARS
		private var __overall:OverallNavigation ;
		private var __target:Sprite;
		private var __nav:Smart;
		private var __home:Sprite;
		private var __brothers:Array;
		private var __choiceSets:Array;
		private var __depth:int;
		
		private var __indexHeight:int;
		private var __indexWidth:int;
		private var __futureItem:Sprite;
		private var __focusIndex:int;
		private var __listener:Sprite;
		private var __focusedItem:Sprite;
		private var __bloops:Dictionary;
	//////////////////////////////////////////////////////// CTOR
		public function NavigationGraphics(o:OverallNavigation) 
		{
			__overall = o ;
			__target = __overall.target ;
			//__bloops = new Dictionary() ;
		}
		public function addChoiceSet(path:String):Sprite
		{
			var step:VirtualSteps = NavHierarchy.instance.getDeep(path) ;
			var block:Sprite = XContext.$get(new Sprite()).attr( { id:path, name:path } )[0] ;
			
			step.userData.focuses = [] ;
			createChoiceSet(block, path) ;
			__nav.addChild(block) ;
			__nav.dispatchEvent(new Event(Event.RESIZE)) ;
			return block ;
		}
		private function createChoiceSet(block:Sprite, path:String):void 
		{
			__indexHeight = 0 ;
			block.addChild(createItem(path +'/' + '__futureChoice__', '>', true)) ;
			var back:Sprite = XContext.$get('#back_logo')[0] ;
			var logo:Sprite = XContext.$get('#logo')[0] ;
			block.x = __indexWidth ;
			block.alpha = 0 ;
			
			
			
			__indexWidth += block.width ;
			back.width = logo.width + __indexWidth+ 20*2 ;
		}
		public function removeChoiceSet(path:String, ...args:Array):Sprite
		{
			var block:Sprite = gcbn(__nav, path) ;
			__nav.removeChild(block) ;
			__indexWidth -= block.width ;
			var back:Sprite = XContext.$get('#back_logo')[0] ;
			var logo:Sprite = XContext.$get('#logo')[0] ;
			
			back.width = logo.width + __indexWidth+ 20*2 ;
			__nav.dispatchEvent(new Event(Event.RESIZE)) ;
			
			return block ;
		}
		public function createNewChoice(path:String, id:String, label:String):Sprite 
		{
			var step:VirtualSteps = NavHierarchy.instance.getDeep(path) ;
			var block:Sprite = gcbn(__nav, path) ;
			var item:Sprite = createItem(path + '/' + id, label) ;
			step.userData.focuses.push(item) ;
			block.addChild(item) ;
			return item ;
		}
		private function createItem(path:String, label:String, isFutureItem:Boolean = false):Sprite 
		{
			var logo:Sprite = XContext.$get('#logo')[0] ;
			var item:Sprite = $sprite('item_' + path)  ;
			
			var elems:XML = Root.user.data.loaded['XML']["elements"] ;
			var tf_xml:XML ;
			var over:Sprite = $sprite(null, 'over') ;
			var back:Sprite = $sprite(null, 'back') ;
			
			if (isFutureItem) {
				Draw.draw("rect", { g:over.graphics, color:0xFF0000, alpha:1 }, 0, 0, 200, 30) ;
				Draw.draw("rect", { g:back.graphics, color:0x2A2A2A, alpha:.92 }, 0, 0, 200, 30) ;
				tf_xml = elems.child('textfields').*[0] ;
				item.tabIndex = -1 ;
			}else {
				Draw.draw("rect", { g:over.graphics, color:0xFF0000, alpha:1 }, 0, 0, 200, 20) ;
				Draw.draw("rect", { g:back.graphics, color:0x2A2A2A, alpha:.92 }, 0, 0, 200, 20) ;
				tf_xml = elems.child('textfields').*[1] ;
				item.tabIndex = __focusIndex++ ;
			}
			
			over.alpha = 0 ;
			
			item.x = logo.width ;
			item.y = __indexHeight ;
			item.mouseChildren = false ;
			item.focusRect = false ;
			item.addChildAt(back, 0) ;
			item.addChild(over) ;
			
			var tf:TextField = XContext.$get(tf_xml)
			.attr( { id:'itemTF_' + path , name:"itemTF", text:label} )
			.appendTo(item)[0] ;
			__indexHeight += item.height ;
			
			
			
			return item
		}
		
		// Graphics
		public function execOver(item:Sprite, cond:Boolean = true):void
		{
			
			var over:Sprite =  gcbn(item, 'over') ;
			var tf:TextField = gcbn(item, 'itemTF') ;
			var fmt:TextFormat = tf.getTextFormat();
			if (cond) {
				fmt.color = '0xFFFFFF' ;
				over.alpha = 1 ;
			}else {
				fmt.color = '0xCCCCCC' ;
				over.alpha = 0 ;
			}
			tf.setTextFormat(fmt) ;
		}
		
		public function createNavGraphics():void 
		{
			navContainer() ;
			navGraphics() ;
			draw() ;
			StageResize.instance.handle(__nav) ;
			__nav.addEventListener(Event.RESIZE, draw) ;
		}
		
		public function displayChoiceSet(st:Sprite, closure:Function = null, ...args:Array):void 
		{
			//var bloop:BloopEffect = __bloops[st] ;
			//bloop.reset() ;
			//bloop.show.apply(this, [st.width >> 1, st.height >> 1, 30, function(...bla:Array):void {
				//bloop.removeFrom(__nav) ;
				//st.alpha = 1 ;
				//if(Boolean(closure)) closure.apply(null, [].concat(args)) ;
			//}].concat(args)) ;
			//
			TweenLite.to(st, .15, { alpha:1 , onComplete:function(e:Event = null):void {
				if(Boolean(closure))closure.apply(this, [].concat(args)) ;
			}} ) ;
			
			
			
		}
		
		public function finalizeChoiceSet(path:String):void 
		{
			//var block:Sprite = gcbn(__nav, path) ;
			//var bloop:BloopEffect = __bloops[block] = new BloopEffect(block, 16) ;
			//bloop.output.x = block.x + 34;
			//bloop.appendTo(__nav) ;
		}
		
		
		private function navContainer():void 
		{
			__nav = new Smart() ;
			__target.addChild(__nav) ;
		}
		
		private function navGraphics():void 
		{
			var logo:Sprite = __home = XContext.$get(new Sprite()).attr( { id:'logo', name:'logo' } )[0] ;
			logo.mouseChildren = false ;
			logo.tabIndex = __focusIndex++ ;
			var elems:XML = Root.user.data.loaded['XML']["elements"] ;
			var logo_svg:XML = elems.child('svgs').*[0] ;
			var fshape:FShapeSVG = new FShapeSVG(logo_svg);
			var shoebox:Sprite = Sprite(fshape.toSprite()) ;
			var mainCont:Sprite = Sprite(shoebox.getChildAt(0)) ;
			var shoeCont:Sprite = Sprite(mainCont.getChildAt(0)) ;
			var shoe:Sprite = Sprite(shoeCont.getChildAt(1)) ;
			
			var navSize:Point = new Point(34,30) ;
			Draw.draw("rect", { g:logo.graphics, color:0xFF0000, alpha:1 }, 0, 0, navSize.x, navSize.y) ;
			logo.addChild(shoe) ;
			shoe.x += 3 ;
			shoe.y += 2 ;
			__nav.addChild(logo) ;
			
			var margin:Point = new Point(20 , 20);
			var back:Sprite = XContext.$get(new Sprite()).attr({id:'back_logo', name:'back_logo'})[0] ;
			Draw.draw("rect", { g:back.graphics, color:0x212121, alpha:.03 }, 0,0,(margin.x<<1) + logo.width, (margin.y<<1) + logo.height) ;
			back.x = - margin.x ;
			back.y = - margin.y ;
			__nav.addChildAt(back, 0) ;
		}
		
		private function draw(e:Event = null):void
		{
			var stWidth:int = __target.stage.stageWidth ;
			var stHeight:int = __target.stage.stageHeight ;
			__nav.x = (stWidth / 2) - (__nav.width / 2) + 20 ;
			__nav.y = (stHeight / 2) - 20;
		}
		
		private function $sprite(path:String = null, label:String = null):Sprite 
		{
			if (path == null) {
				obj = { name:label}
				return XContext.$get(new Sprite()).attr( obj )[0] ;
			} else {
				obj = { id:path, name:label || path }
				return XContext.$get(new Sprite()).attr( obj )[0] ;
			}
		}
		
		private function $get(path:String):DisplayObject 
		{
			return XContext.$get('#'+path)[0] ;
		}
		
		private function gcbn(tg:Sprite, childName:String):*
		{ return tg.getChildByName(childName) }
		
		public function get brothers():Array 
		{ return __brothers }
		
		public function get home():Sprite 
		{ return __home }
	}
}