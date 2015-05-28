package pro.navigation.navmain 
{
	/**
	 * ...
	 * @author saz
	 */
	import flash.display.Sprite ;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import frocessing.shape.FShapeSVG;
	import of.app.required.context.XContext;
	import of.app.required.resize.StageResize;
	import of.app.Root;
	import of.app.XConsole;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	public class NavigationGraphics {
	//////////////////////////////////////////////////////// VARS
		private var __o:OverallNavigation ;
		private var __target:Sprite;
		private var __nav:Smart;
		private var __brothers:Array;
		private var __depth:int;
		
		private var __indexHeight:int;
		private var __indexWidth:int;
		private var __futureItem:Sprite;
		private var __focusIndex:int;
		private var __listener:Sprite;
		private var __focusedItem:Sprite;
	//////////////////////////////////////////////////////// CTOR
		public function NavigationGraphics(o:OverallNavigation) 
		{
			var __o:OverallNavigation = o ;
			__target = __o.target ;
		}
		
		public function createNewChoiceSet(id:String, label:String):Sprite 
		{
			__brothers = [] ;
			__indexHeight = 0 ;
			
			var choiceSet:Sprite = $sprite('choiceSet_' + id) ;
			__brothers.choiceSet = choiceSet ;
			__brothers.id = id ;
			__futureItem = __brothers.choiceSet.addChild(createItem(id +'/' + '__futureChoice__', '>', true)) ;
			eventsItem(__futureItem) ;
			__nav.addChild(choiceSet) ;
			
			var back:Sprite = XContext.$get('#back_logo')[0] ;
			back.width = __nav.width + 20 ;
			__nav.dispatchEvent(new Event(Event.RESIZE)) ;
			
			return choiceSet ;
		}
		
		public function createNewChoice(id:String, label:String):Sprite 
		{
			var item:Sprite = createItem(id, label) ;
			__brothers.push(__brothers.choiceSet.addChild(item)) ;
			return item ;
		}
		
		private function createItem(id:String, label:String, isFutureItem:Boolean = false):Sprite 
		{
			var logo:Sprite = XContext.$get('#logo')[0] ;
			var item:Sprite = $sprite('item_' + id)  ;
			
			var elems:XML = Root.user.data.loaded['XML']["elements"] ;
			var tf_xml:XML ;
			var over:Sprite = $sprite(null, 'over') ;
			var back:Sprite = $sprite(null, 'back') ;
			
			if (isFutureItem) {
				Draw.draw("rect", { g:over.graphics, color:0xFF0000, alpha:1 }, 0, 0, 200, 30) ;
				Draw.draw("rect", { g:back.graphics, color:0xBBBBBB, alpha:1 }, 0, 0, 200, 30) ;
				tf_xml = elems.child('textfields').*[0] ;
				item.tabIndex = -1 ;
			}else {
				Draw.draw("rect", { g:over.graphics, color:0xFF0000, alpha:1 }, 0, 0, 200, 20) ;
				Draw.draw("rect", { g:back.graphics, color:0xFFFFFF, alpha:.12 }, 0, 0, 200, 20) ;
				tf_xml = elems.child('textfields').*[1] ;
				item.tabIndex = __focusIndex++ ;
			}
			over.alpha = 0 ;
			item.x = logo.width ;
			item.y = __indexHeight ;
			
			item.addChildAt(back, 0) ;
			item.addChild(over) ;
			
			var tf:TextField = XContext.$get(tf_xml)
			.attr( { id:'itemTF_' + id , name:"itemTF", text:label} )
			.appendTo(item)[0] ;
			__indexHeight += item.height ;
			
			return item
		}
		
		public function eventsItem(item:Sprite):void 
		{
			//item.addEventListener(MouseEvent.ROLL_OVER, onItemRoll) ;
			//item.addEventListener(MouseEvent.ROLL_OUT, onItemRoll) ;
			//item.addEventListener(FocusEvent.FOCUS_IN, onItemRoll) ;
			//item.addEventListener(FocusEvent.FOCUS_OUT, onItemRoll) ;
			//item.addEventListener(MouseEvent.CLICK, onClick) ;
			item.mouseChildren = false ;
			item.focusRect = false ;
		}
		
		public function eventsChoiceSet(id:String):Sprite 
		{
			var blockChoiceSet:Sprite = XContext.$get('#choiceSet_'+id)[0] ;
			blockChoiceSet.addEventListener(KeyboardEvent.KEY_DOWN, onBlockKey, true) ;
			blockChoiceSet.addEventListener(FocusEvent.FOCUS_IN, onBlockFocus, true) ;
			blockChoiceSet.addEventListener(FocusEvent.FOCUS_OUT, onBlockFocus, true) ;
			blockChoiceSet.addEventListener(MouseEvent.ROLL_OVER, onBlockRoll) ;
			blockChoiceSet.addEventListener(MouseEvent.ROLL_OUT, onBlockRoll) ;
			blockChoiceSet.addEventListener(MouseEvent.MOUSE_OVER, onBlockMouseOver, true) ;
			blockChoiceSet.addEventListener(MouseEvent.MOUSE_OUT, onBlockMouseOver, true) ;
			blockChoiceSet.addEventListener(MouseEvent.CLICK, onClick, true) ;
		}
		
		private function onBlockKey(e:KeyboardEvent):void 
		{
			switch(e.keyCode) {
				case Keyboard.TAB:
					return ;
				break ;
				case Keyboard.DOWN:
					nextFocus() ;
				break ;
				case Keyboard.UP:
					prevFocus() ;
				break ;
				case Keyboard.ENTER:
				case Keyboard.NUMPAD_ENTER:
					goToChild() ;
				break ;
				case Keyboard.ESCAPE:
					backToParent() ;
				break ;
			}
			
			XConsole.log(e.eventPhase) ;
			XConsole.log(e.keyCode, e.target.name) ;
			XConsole.log('-------------------------') ;
			
			trace('ksduvbkdvbkdshbsdkbv')
		}
		
		private function goToChild(id:String):void 
		{
			
		}
		
		private function backToParent():void 
		{
			
		}
		
		private function nextFocus():void 
		{
			var ind:int = loopUp(__brothers.indexOf(__focusedItem)) ;
			var item:Sprite = __brothers[ind] ;
			item.stage.focus = item ;
		}
		private function prevFocus():void 
		{
			var ind:int = loopDown(__brothers.indexOf(__focusedItem)) ;
			var item:Sprite = __brothers[ind] ;
			item.stage.focus = item ;
		}
		
		private function loopUp(focusIndex:int):int
		{
			return Boolean(__brothers[focusIndex + 1] as Sprite) ? focusIndex + 1 : 0 ;
		}
		
		private function loopDown(focusIndex:int):int 
		{
			return Boolean(__brothers[focusIndex - 1] as Sprite) ? focusIndex - 1 : __brothers.length - Array.length ;
		}
		
		private function onBlockRoll(e:MouseEvent):void 
		{
			Sprite(e.target).alpha = e.type == MouseEvent.ROLL_OVER ? 1 : .7 ;
		}
		
		private function onBlockMouseOver(e:MouseEvent):void 
		{
			//trace(e.eventPhase)
			//trace(e)
			if (e.target is Sprite) {
				trace( e.target.name, e.target)  ;
				execOver(e.target, e.type == MouseEvent.MOUSE_OVER) ;
			}
		}
		private function onBlockFocus(e:FocusEvent):void 
		{
			execOver(e.target, e.type == FocusEvent.FOCUS_IN) ;
			__focusedItem = e.target ;
		}
		private function onItemRoll(e:Event):void 
		{
			execOver(e.target, e.type == MouseEvent.ROLL_OVER) ;
		}		
		private function onClick(e:MouseEvent):void 
		{
			XConsole.log('heyhyehyeheyheyheyeyeh',  e)
		}
		private function execOver(item:Sprite, cond:Boolean = true):void
		{
			var over:Sprite =  gcbn(item, 'over') ;
			var tf:TextField = gcbn(item, 'itemTF') ;
			var fmt:TextFormat = tf.getTextFormat();
			if (cond) {
				fmt.color = '0xFFFFFF' ;
				over.alpha = 1 ;
			}else {
				fmt.color = '0x0' ;
				over.alpha = 0 ;
			}
			tf.setTextFormat(fmt) ;
		}
		private function execFocus(item:Sprite, cond:Boolean = true):void
		{
			var over:Sprite =  gcbn(item, 'over') ;
			var tf:TextField = gcbn(item, 'itemTF') ;
			var fmt:TextFormat = tf.getTextFormat();
			if (cond) {
				fmt.color = '0xFFFFFF' ;
				over.alpha = 1 ;
			}else {
				fmt.color = '0x0' ;
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
		private function navContainer():void 
		{
			__nav = new Smart() ;
			__target.addChild(__nav) ;
			
		}
		private function navGraphics():void 
		{
			var logo:Sprite = XContext.$get(new Sprite()).attr({id:'logo', name:'logo'})[0] ;
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
			__nav.y = (stHeight / 2) - (__nav.height / 2) + 20;
		}
		
		private function $sprite(id:String = null, label:String = null):Sprite 
		{
			var obj:Object ;
			if (id == null) {
				obj = label == null ? {}  : { name:label } ;
			}else {
				obj = { id:id, name:label || id }
			}
			return XContext.$get(new Sprite()).attr( obj )[0] ;
		}
				
		private function gcbn(tg:Sprite, childName:String):*
		{
			return tg.getChildByName(childName) ;
		}
		public function get brothers():Array 
		{
			return __brothers;
		}
	}
}