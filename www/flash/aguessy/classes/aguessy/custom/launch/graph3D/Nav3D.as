package aguessy.custom.launch.graph3D 
{
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import naja.model.control.context.Context;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.model.control.dialog.JSModule;
	import naja.model.Root;
	import naja.model.XUser;
	import naja.model.commands.Command;
	import naja.model.commands.CommandQueue;
	import naja.model.commands.Wait;
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Nav3D 
	{
		private var user:XUser ;
		internal var graphics:Nav3DGraphics ;
		public var g3D:Graph3D ;
		internal var currentStep:VirtualSteps ;
		private var context:ContextMenu;
		internal var __final:Boolean;
		
		
		public function Nav3D() 
		{
			user = Root.user ;
			g3D = new Graph3D() ;
			graphics = new Nav3DGraphics() ;
		}
		
		public function init():void
		{
			user.model.data.objects["graph3D"] = g3D ;
			
			graphics.init(this) ;
			g3D.init(graphics.__mc, this) ;
			
			clearContextMenus() ;
			initContextMenus() ;
			enableContextMenus() ;
		}
		
		private function enableContextMenus():void
		{
			Root.root.contextMenu = context ;
			var p = context.customItems ;
			var l:int = p.length ;
			for (var i:int = 0; i < l ; i++ )
			{
				var item:ContextMenuItem = ContextMenuItem(p[i]) ;
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuItemSelect) ;
			}
		}
		
		private function onContextMenuItemSelect(e:ContextMenuEvent):void 
		{
			var cmi:ContextMenuItem = ContextMenuItem(e.target) ;
			switch(cmi.caption) {
				case 'HISTORY.BACK' :
				case 'HISTORY.FORWARD' :
					JSModule.callJS(cmi.caption.toLowerCase()) ;
				break ;
				case 'GO' :
					go() ;
				break ;
				case 'FACEBOOK':
					var d:Object = user.model.data.links['facebook'] ;
					navigateToURL(new URLRequest(d.url), d.target) ;
				break;
				case 'HOME':
				case 'PORTFOLIO':
				case 'ABOUT':
				case 'NEWS':
				case 'MEDIAS':
				case 'PRESS':
				case 'CONTACTS':
					ExternalDialoger.instance.swfAddress.value = cmi.caption ;
				break;
			}
		}
		private function clearContextMenus():void
		{
			Root.root.stage.showDefaultContextMenu = false ;
			context = new ContextMenu() ;
			context.hideBuiltInItems() ;
			context.customItems = [] ;
		}
		private function initContextMenus():void
		{
			var cm_go:ContextMenuItem = new ContextMenuItem("GO",false,true ) ;
			var cm_prev:ContextMenuItem = new ContextMenuItem("HISTORY.BACK",true,true) ;
			var cm_next:ContextMenuItem = new ContextMenuItem("HISTORY.FORWARD",false,true) ;
			var cm_home:ContextMenuItem = new ContextMenuItem("HOME",true,true) ;
			var cm_portfolio:ContextMenuItem = new ContextMenuItem("PORTFOLIO",false,true) ;
			var cm_about:ContextMenuItem = new ContextMenuItem("ABOUT",false,true) ;
			var cm_news:ContextMenuItem = new ContextMenuItem("NEWS",false,true) ;
			var cm_medias:ContextMenuItem = new ContextMenuItem("MEDIAS",false,true) ;
			var cm_press:ContextMenuItem = new ContextMenuItem("PRESS",false,true) ;
			var cm_contact:ContextMenuItem = new ContextMenuItem("CONTACTS", false, true) ;
			var cm_facebook:ContextMenuItem = new ContextMenuItem("ON FACEBOOK", true, true) ;
			
			context.customItems.push(cm_go) ;
			context.customItems.push(cm_prev) ;
			context.customItems.push(cm_next) ;
			
			context.customItems.push(cm_home) ;
			context.customItems.push(cm_portfolio) ;
			context.customItems.push(cm_about) ;
			context.customItems.push(cm_news) ;
			context.customItems.push(cm_medias) ;
			context.customItems.push(cm_press) ;
			context.customItems.push(cm_contact) ;
			context.customItems.push(cm_facebook) ;
			
		}
		
		
		//	GRAPH
		
		internal function graphPrev():void
		{
			g3D.prev() ;
			if (__final) {
				goFinal() ;
			}else {
				
			}
			
		}
		
		internal function graphNext():void
		{
			g3D.next() ;
			if (__final) {
				goFinal() ;
			}else {
				
			}
		}
		//////////////////////////////////////////////////////////////////// TEXT TEMPLATES APPENDING
		public function appendText(step:VirtualSteps,cond:Boolean = true):void
		{
			g3D.appendText(step,cond) ;
		}
		
		
		
		public function evaluate(_steps:VirtualSteps):void
		{
			currentStep = _steps ;
			g3D.evaluate(_steps) ;
			//new CommandQueue(Wait(500),new Command(g3D, g3D.evaluate,_steps)).execute() ;
		}
		
		public function levelOne(cond:Boolean = true):void {
			g3D.levelOne(cond) ;
		}
		
		public function finalEvents(_step:VirtualSteps,cond:Boolean = true):void
		{
			__final = cond ;
			//g3D.finalEvents(_step,cond) ;
		}
		
		public function fillMedias(_step:VirtualSteps,cond:Boolean = true):void
		{
			g3D.fillMedias(_step, cond) ;
		}
		
		public function fillInfos(_step:VirtualSteps,cond:Boolean = true):void
		{
			g3D.__displayer.addSubSection(_step.depth,_step["infos"].usename[0],cond) ;
			g3D.fillInfos(_step, cond) ;
		}
		public function fillNews(_step:VirtualSteps,cond:Boolean = true):void
		{
			g3D.__displayer.addSubSection(_step.depth,_step.xml.@usename.toXMLString().replace(/&amp;/gi, "&"),cond) ;
			g3D.fillNews(_step, cond) ;
		}
		public function addSubSection(_step:VirtualSteps,cond:Boolean = true):void
		{
			g3D.addSubSection(_step, cond) ;
		}
		
		public function fill(_step:VirtualSteps,cond:Boolean = true):void
		{
			g3D.fill(_step, cond) ;
		}
		
		public function reset():void
		{
			g3D.reset() ;
		}
		
		public function play():void
		{
			g3D.play() ;
		}
		
		public function stop():void
		{
			g3D.stop() ;
		}
		
		
		///////////////////////////////////////////////////////////////////////////////// EVENTS
		internal function onKeyDowned(e:KeyboardEvent):void 
		{
			var eventDown:Boolean = e.type == KeyboardEvent.KEY_DOWN ;
			if (e.keyCode == Keyboard.LEFT)
			{
				if (!__final) {
					graphPrev() ;
				}else {
					graphPrev() ;
				}
			}
			else if (e.keyCode == Keyboard.RIGHT)
			{
				if (!__final) {
					graphNext() ;
				}else {
					graphNext() ;
				}
			}
			else if (e.keyCode == Keyboard.ESCAPE || e.keyCode == Keyboard.UP)
			{
				if (!__final) {
					quit() ;
				}else {
					quit() ;
				}
			}
			else if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.NUMPAD_ENTER || e.keyCode == Keyboard.DOWN)
			{
				if (!__final) {
					go() ;
				}else {
					goFinal() ;
				}
			}
		}
		
		internal function onNavClicked(e:MouseEvent):void 
		{
			if (e.currentTarget.name == "TITLE") {
				goSection(Sprite(e.currentTarget),true) ;
			}else if (e.currentTarget.name.indexOf("SUBITEM_") != -1) {
				goSection(Sprite(e.currentTarget)) ;
			}else if (e.currentTarget.name.indexOf("graphItem_") != -1) {
				var s:String = e.currentTarget.name ;
				var n:int = int(s.substr(s.lastIndexOf('_') + 1, s.length)) ;
				var curXML:XML = g3D.__switchables[n] ;
				
				if (!Boolean(g3D.__switchables[n])) {
					return ;
				}
				
				g3D.sliceArr(g3D.__currentIndex - n) ;
				g3D.setCurrent() ;
				
				if (!__final) {
					go(curXML) ;
				}else {
					goFinal(curXML) ;
				}
			}else {
				switch(e.currentTarget.name) {
					case 'logo' :
						ExternalDialoger.instance.swfAddress.value = "HOME" ;
					break ;
					case 'left' :
						graphPrev() ;
					break ;
					case 'right' :
						graphNext() ;
					break ;
					case 'bottom' :
						go() ;
					break ;
					case 'top' :
						quit() ;
					break ;
				}
			}
		}
		
		private function goSection(s:Sprite,direct:Boolean = false):void
		{
			var tf:TextField = s.getChildByName('TEXT') as TextField ;
			if (direct) {
				ExternalDialoger.instance.swfAddress.value = tf.text.replace(' ','_') ;
			}else {
				var i:int = int(s.name.substr( s.name.lastIndexOf('_') + 1, s.name.length)) ;
				var q:Array = ExternalDialoger.instance.swfAddress.address.split('/') ;
				q = q.splice(0,i) ;
				ExternalDialoger.instance.swfAddress.value = q.join('/') ;
			}
		}
		private function goFinal(n:XML = null):void
		{
			if (currentStep.gates.merged.length == 0) return ;
			var curXML:XML = n is XML ? n : g3D.__switchables[g3D.__currentIndex] ;
			if (!(curXML is XML)) return ;
			var str:String = String(curXML.childIndex() + 1) ;
			var input:String = ExternalDialoger.instance.swfAddress.value ;
			var output:String ;
			if (isNaN(input.split('/').pop())) {
				output = input+ "/" + str ;
			}else {
				var p:Array = input.split('/') ;
				p.pop() ;
				output = p.join('/') + '/' + str ;
			}
			ExternalDialoger.instance.swfAddress.value = output ;
		}
		private function go(n:XML = null):void
		{
			if (currentStep.gates.merged.length == 0) return ;
			var curXML:XML = n is XML ? n : g3D.__switchables[g3D.__currentIndex] ;
			if (!(curXML is XML)) return ;
			
			var str:String = curXML.hasOwnProperty("@id")? curXML.@id.toXMLString() : curXML.@name.toXMLString() ;
			if (ExternalDialoger.instance.swfAddress.value == ExternalDialoger.instance.swfAddress.home ) {
				if (curXML.hasOwnProperty("@url")) {
					ExternalDialoger.instance.swfAddress.value = str.toUpperCase() ;
				}
			}else {
				ExternalDialoger.instance.swfAddress.value += "/" + str.toUpperCase() ;
			}
		}
		
		private function quit():void
		{
			var s:String = ExternalDialoger.instance.swfAddress.value ;
			if (s.indexOf("/") != -1) {
				var output:String ;
				if (__final) {
					var input:String = ExternalDialoger.instance.swfAddress.value ;
					var p:Array = input.split('/') ;
					if(isNaN(parseInt(p.pop()))) {
						
					}else {
						p.pop() ;
					}
					
					output = p.join('/') ;
				}else {
					output = s.substr(0, s.lastIndexOf("/")) ;
				}
				ExternalDialoger.instance.swfAddress.value = output ;
			}else {
				ExternalDialoger.instance.swfAddress.value = ExternalDialoger.instance.swfAddress.home ;
			}
		}
	}
	
}