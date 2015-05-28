package pro.navigation.saznav 
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import frocessing.shape.FShapeSVG;
	import gs.easing.Expo;
	import gs.TweenLite;
	import of.app.required.delay.Delay;
	import of.app.required.dialog.XExternalDialoger;
	import of.app.required.loading.XLoader;
	import of.app.required.steps.VirtualSteps;
	import of.app.Root;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	
	public class Navigation 
	{
		//////////////////////////////////////////////////////// VARS
		static private var __instance:Navigation ;
		private var __target:Sprite;
		private var __nav:Object;
		private var currentStep:VirtualSteps;
		static internal var __focusIndex:int = 100;
		//////////////////////////////////////////////////////// CTOR
		public function Navigation() 
		{
			__instance = this ;
		}
		public function init(tg:Sprite):Navigation
		{
			__target  = tg ;
			initNav() ;
			//__target.stage.stageFocusRect = true ;
			__target.stage.stageFocusRect = false ;
			__target.stage.addEventListener(Event.RESIZE, onStageResized) ;
			__target.stage.dispatchEvent(new Event(Event.RESIZE)) ;
			return this ;
		}
///////////////////////////////////////////////////////////////////////////////// NAV CONTROL	
//////////////////////////////////////////////////////// GENERATE
		//	SHOULD READ THE FIRST XML 
		public function readOnce(step:VirtualSteps):void
		{
			var block:SubNavBlock ;
			var elems:XML = Root.user.data.loaded['XML']["elements"] ;
			var item__tf:XML = elems.child('textfields').*[0] ;
			var small_item__tf:XML = elems.child('textfields').*[1] ;
			if (!Boolean(step.userData.block as SubNavBlock)) {
				__nav.first_step = step ;
				block = step.userData.block = __nav.first_block = new SubNavBlock()
				.init(item__tf, small_item__tf)
				.read(step) ;
				addBlock(block) ;
			}else {
				block = step.userData.block  ;
			}
		}
		//	SHOULD READ A NEW XML (before ScrollRect Tween in that case) at init of step
		public function read(step:VirtualSteps):void
		{
			currentStep = step ;
			if (!Boolean(step.userData.block as SubNavBlock)) {
				return request(step) ;
			}else {
				
			}
			addBlock(step.userData.block) ;
		}
		private function request(step:VirtualSteps):void
		{
			var loader:XLoader = new XLoader() ;
			loader.addRequestByUrl(step.userData.url, String(step.id), null) ;
			loader.addEventListener(Event.COMPLETE, resume) ;
			
			loader.load() ;
		}
		private function resume(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			var loader:XLoader = XLoader(e.currentTarget) ;
			var step:VirtualSteps = currentStep ;
			step.xml = loader.getResponseById(String(step.id)) ;
			step.userData.block = createBlock(step) ;
			addBlock(step.userData.block) ;
		}
		internal function checkBlocksToUnfocus(block:SubNavBlock):void
		{
			var sNav:Smart = __nav.sub_nav ;
			for (var i:int = 0; i < sNav.numChildren ; i++ ) {
				var bl:SubNavBlock = SubNavBlock(sNav.getChildAt(i)) ;
				if(bl.focused && bl != block) bl.unfocus(.1) ;
			}
		}
		internal function checkBlocksToFocus(block:SubNavBlock):void
		{
			var sNav:Smart = __nav.sub_nav ;
			block = getBlockAt(sNav.numChildren - 1) ;
			trace('hey yo  >>' , block.properties.id)
			block.focus() ;
		}
		public function unread(step:VirtualSteps):void
		{
			var sNav:Smart = __nav.sub_nav ;
			var block:SubNavBlock = getBlockAt(step.depth) ;
			removeBlock(block) ;
		}
		private function createBlock(step:VirtualSteps):SubNavBlock
		{
			var sNav:Smart = __nav.sub_nav ;
			var elems:XML = Root.user.data.loaded['XML']["elements"] ;
			var item__tf:XML = elems.child('textfields').*[0] ;
			var small_item__tf:XML = elems.child('textfields').*[1] ;
			
			var block:SubNavBlock = new SubNavBlock({id:step.id, nav:this})
			.init(item__tf, small_item__tf)
			.read(step) ;
			var base:SubNavBlock = getBlockAt(step.depth - 1) ;
			block.x = base.x + base.width ;
			return block ;
		}
		private function removeBlock(block:SubNavBlock):void
		{
			var sNav:Smart = Smart(__nav.sub_nav) ;
			
			sNav.properties.width = block.x ;
			sNav.properties.height = getHighest().properties.height ;
			var f:Function , p:Array ;
			
			
			Delay.make(0, null, unSetFocus, block, 0)
			.make(1, null, navExpand, .1)
			.make(1, null, backExpand, .15)
			.make(1, null, function():void {
				sNav.removeChild(block) ;
			}) ;
		}
		private function addBlock(block:SubNavBlock):SubNavBlock
		{
			var sNav:Smart = Smart(__nav.sub_nav) ;
			block.addEventListener(Event.ADDED, onBlockAdded) ;
			var o:SubNavBlock = SubNavBlock(sNav.addChild(block)) ;
			return o ;
		}
		private function onBlockAdded(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			var sNav:Smart = Smart(__nav.sub_nav) ;
			var block:SubNavBlock = SubNavBlock(e.currentTarget) ;
			
			sNav.properties.width = block.width + block.x ;
			sNav.properties.height = block.properties.height ;
			
			Delay.make(1, null, backExpand, .1)
			.make(1, null, navExpand, .15)
			.make(1, null, setFocus, block, 0)
			.make(1, null, checkBlocksToUnfocus, block)
			.make(1, null, XExternalDialoger.instance.hierarchy.dispatchReady) ;
		}
		private function setFocus(block:SubNavBlock , time:Number = 0):void
		{
			block.focus(time) ;
		}
		private function unSetFocus(block:SubNavBlock, time:Number = 0):void
		{
			block.unfocus(time) ;
		}
		private function backExpand(time:Number = 0, width:Number = NaN):void
		{
			var sNav:Smart = Smart(__nav.sub_nav) ;
			var resultW:int = isNaN(width) ? 
				sNav.properties.width + __nav.logo_size.x : int(width) ;
			resultW += __nav.back_margin.x * 2 ;
			if (time != 0) {
				TweenLite.to(__nav.back, time, { ease: Expo.easeOut,
					width: resultW,
					onUpdate:drawLogo 
				} ) ;
			}else {
				__nav.back.width = resultW ;
				drawLogo() ;
			}
		}
		private function navExpand(time:Number = 0):void
		{
			var sNav:Smart = Smart(__nav.sub_nav) ;
			var block:SubNavBlock = getHighest() ;
			var rect:Rectangle = new Rectangle(0, 0, sNav.properties.width ,  sNav.properties.height) ;
			var base:Rectangle = sNav.scrollRect ;
			base.height = block.properties.height ;
			if (time == 0) {
				sNav.scrollRect =  rect ;
			} else {
				TweenLite.to(base, time, { ease:Expo.easeOut, 
					width:rect.width,
					onUpdate:function():void {
						sNav.scrollRect = base ;
					}
				}) ;
			}
		}
		private function navShrink(time:Number = 0):void
		{
			var sNav:Smart = Smart(__nav.sub_nav) ;
			var block:SubNavBlock = getLowest() ;
			var rect:Rectangle = new Rectangle(0, 0, sNav.properties.width ,  sNav.properties.height) ;
			var base:Rectangle = sNav.scrollRect ;
			base.height = block.properties.height ;
			if (time == 0) {
				sNav.scrollRect =  rect ;
			} else {
				TweenLite.to(base, time, { ease:Expo.easeOut, 
					width:rect.width,
					onUpdate:function():void {
						sNav.scrollRect = base ;
					}
				}) ;
			}
		}
		private function getBlockAt(depth:int):SubNavBlock
		{
			var sNav:Smart = Smart(__nav.sub_nav) ;
			var block:SubNavBlock ;
			return SubNavBlock(sNav.getChildAt(depth)) ;
		}
		private function getAccurateBlock(highest:Boolean):SubNavBlock
		{
			var sNav:Smart = Smart(__nav.sub_nav) ;
			var bl:SubNavBlock , block:SubNavBlock ;
			for (var i:int = 0 ; i < sNav.numChildren ; i++ ) {
				bl = SubNavBlock(sNav.getChildAt(i)) ;
				if (i == 0) {
					block = bl ;
				}else {
					if (highest) {
						if (bl.properties.height > block.properties.height) block = bl ;
					}else{
						if (bl.properties.height < block.properties.height) block = bl ;
					}
				}
			}
			return block ;
		}
		private function getHighest():SubNavBlock
		{
			return getAccurateBlock(true) ;
		}
		private function getLowest():SubNavBlock
		{
			return getAccurateBlock(false) ;
		}
///////////////////////////////////////////////////////////////////////////////// NAV INITS
		//////////////////////////////////////////////////////// SUBNAV
		private function initSubNav():Smart
		{
			var sNav:Smart = new Smart() ;
			sNav.properties.nav_blocks = [] ;
			
			sNav.x = __nav.logo_size.x ;
			sNav.scrollRect = new Rectangle( 0, 0, 0, 30) ;
			__nav.logo.addChild(sNav) ;
			return sNav ;
		}
		//////////////////////////////////////////////////////// BACK
		private function initBack():Sprite
		{
			var margin:Point = __nav.back_margin = new Point(20 , 20);
			var l:Sprite = __nav.logo ;
			var back:Sprite = __nav.back = new Sprite() ;
			Draw.draw("rect", { g:back.graphics, color:0x212121, alpha:.03 }, 0,0,(margin.x<<1) +l.width, (margin.y<<1) +l.height) ;
			back.x = -margin.x ;
			back.y = -margin.y ;
			__nav.logo.addChildAt(back, 0) ;
			return  back ;
		}
		//////////////////////////////////////////////////////// LOGO
		private function initLogo():Sprite
		{
			var elems:XML = Root.user.data.loaded['XML']["elements"] ;
			var logo_svg:XML = elems.child('svgs').*[0] ;
			
			var fshape:FShapeSVG = new FShapeSVG(logo_svg);
			var logo:Sprite = Sprite(fshape.toSprite()) ;
			
			var mainCont:Sprite = Sprite(logo.getChildAt(0)) ;
			var shoebox:Sprite = Sprite(mainCont.getChildAt(0)) ;
			var shoe:Sprite = Sprite(shoebox.getChildAt(1)) ;
			shoebox = new Sprite() ;
			var navSize:Point = __nav.logo_size = new Point(34,30) ;
			Draw.draw("rect", { g:shoebox.graphics, color:0xFF0000, alpha:1 }, 0, 0, navSize.x, navSize.y) ;
			shoebox.addChild(shoe) ;
			shoe.x += 3 ;
			shoe.y += 2 ;
			var lc:Sprite = __nav.logo_clickable =  new Sprite() ;
			Draw.draw("rect", { g:lc.graphics, color:0xFF0000, alpha:0 }, 0,0,navSize.x,navSize.y) ;
			shoebox.addChild(lc) ;
			__target.addChild(shoebox) ;
			__nav.logo_clickable.addEventListener(MouseEvent.CLICK, onClickLogo) ;
			return shoebox ;
		}
		private function drawLogo():void
		{
			var l:Sprite = __nav.logo, l2:Sprite = Boolean(__nav.back as Sprite)? __nav.back: l,
			stWidth:int = __target.stage.stageWidth,
			stHeight:int = __target.stage.stageHeight ;
			l.x = (stWidth / 2) - ((l2.width - __nav.logo_clickable.width) / 2) ;
			l.y = (stHeight / 2) - ((l2.height - __nav.logo_clickable.height ) / 2) ;
		}
		//////////////////////////////////////////////////////// NAV
		private function initNav():void
		{
			__nav = { } ;
			__nav.logo = initLogo() ;
			__nav.xml = new XML(<datas></datas>) ;
			__nav.back = initBack() ;
			__nav.back_original_size  = new Point(__nav.back.width, __nav.back.height) ;
			__nav.loading_extra_size  = 50 ;
			__nav.sub_nav = initSubNav() ;
			__nav.loading  = initLoading() ;
		}
		
		private function initLoading():Sprite
		{
			var loading:Sprite = new Sprite() ;
			loading.graphics.beginFill(0x212121, 1) ;
			loading.graphics.drawRect(0,0,__nav.loading_extra_size,30)
			loading.graphics.endFill() ;
			return loading ;
		}
		//////////////////////////////////////////////////////// EVENTS
		private function addEvents(cond:Boolean = true):void
		{
			var closure:String = cond ? "addEventListener" : "removeEventListener" ;
			__target.stage[closure](KeyboardEvent.KEY_DOWN, onStageKeyUp) ;
			__nav.logo[closure](MouseEvent.ROLL_OVER, onLogoMouse) ;
			__nav.logo[closure](MouseEvent.ROLL_OUT, onLogoMouse) ;
		}
		
///////////////////////////////////////////////////////////////////////////////// NAV EVENTS
		private function onStageResized(e:Event):void 
		{
			drawLogo() ;
		}
		private function onLogoMouse(e:MouseEvent):void 
		{
			trace(e)
			if (e.type == MouseEvent.ROLL_OVER) {
				//if (!__nav.opened) navShow() ;
			}else {
				//if (__nav.opened) navShow(false) ;
			}
		}
		private function onStageKeyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.SPACE) {
				//if (!__nav.opened) navShow() ;
				//else navShow(false) ;
			}
		}
		private function onClickLogo(e:MouseEvent):void
		{
			trace(e)
			XExternalDialoger.instance.swfAddress.value = XExternalDialoger.instance.swfAddress.home ; 
		}
		///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get hasInstance():Boolean { return Boolean(__instance is Navigation) }
		static public function get instance():Navigation { return __instance || new Navigation() }
		static public function init(tg:Sprite):Navigation { return __instance.init(tg) }
		
		public function get enabled():Boolean { return __nav.enabled }
		
		static public function get focusIndex():int { return __focusIndex }
		static public function set focusIndex(value:int):void 
		{ __focusIndex = value }
	}
}