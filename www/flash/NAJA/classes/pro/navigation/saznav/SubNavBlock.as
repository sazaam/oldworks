package pro.navigation.saznav
{
	import asSist.$;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import gs.easing.Expo;
	import gs.TweenLite;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.tools.api.geom.Draw;
	import naja.tools.steps.VirtualSteps;
	import pro.steps.NavStep;
	import tools.fl.sprites.Smart;
	
	/**
	 * ...
	 * @author saz
	 */
	public class SubNavBlock extends Smart
	{
		static private var __index:int = -1 ;
		private var __focused:Boolean ;
		private var __opened:Boolean ;
		public function SubNavBlock(props:Object = null) 
		{
			super(props) ;
			__index ++ ;
		}
		public function init(tfXml:XML, small_tfXml:XML):SubNavBlock
		{
			properties.index = __index ;
			properties.itemTF_XML = tfXml ;
			properties.small_itemTF_XML = small_tfXml ;
			properties.items = [] ;
			properties.event = { type:MouseEvent.CLICK, closure:onNavLinkClicked } ;
			
			var back:Sprite = properties.back = new Sprite() ;
			addChild(back) ;
			
			return this ;
		}
		private function onNavLinkClicked(e:MouseEvent):void
		{
			var step:VirtualSteps = VirtualSteps(properties.step) ;
			var str:String = e.currentTarget.name ;
			if (step.depth > 0) {
				str =  properties.adress + "/" + str
			}
			ExternalDialoger.instance.swfAddress.value = str ;
		}
		public function read(step:VirtualSteps):SubNavBlock
		{
			properties.step = step ;
			properties.xml = step.xml ;
			properties.adress = step.genealogy.replace(/^\w+\//i, "") ;
			if (properties.adress == String(step.ancestor.id)) properties.adress == ExternalDialoger.instance.swfAddress.home ;
			trace("ADRESS", properties.adress)
			buildSubNav() ;
			var w:int = int(width + properties.margin * 2) ;
			var h:int = int(height + properties.margin * 2) ;
			var back:Sprite = properties.back ;
			Draw.redraw("rect", { g:graphics, color:0x212121, alpha:1 }, 0, 0, w, h) ;
			Draw.redraw("rect", { g:back.graphics, color:0xFF0000, alpha:1 }, 0, 0, w, h) ;
			back.alpha = 0 ;
			properties.height = height ;
			scrollRect = new Rectangle(0, 0, width, 30) ;
			return this ;
		}
		private function buildSubNav():void
		{
			properties.size = new Point() ;
			properties.margin = int(properties.itemTF_XML.@margin.toXMLString()) ;
			properties.length = 0 ;
			for each(var section:XML in properties.xml.*) {
				properties.length++ ;
				var id:String = section.@id.toXMLString() ;
				var label:String = section.@label.toXMLString() ;
				var url:String = section.@url.toXMLString() ;
				var index:int = section.childIndex() ;
				properties.items[index] = { id:id, item:buildItem(section, index) } ;
				var nStep:NavStep = new NavStep(id) ;
				
				var step:VirtualSteps = VirtualSteps(properties.step) ;
				nStep.userData.url = "../xml/sections/"+url ;
				//nStep.xml = step.xml ;
				step.add(nStep) ;
			};
			for (var n:String in properties.items) {
				var item:SubNavItem = properties.items[int(n)].item ;
				item.properties.event = properties.event ;
				item.createBack(properties.size.x + 60) ;
				item.enable() ;
			}
			enable() ;
		}
		
		private function enable(cond:Boolean = true):void
		{
			if (cond) {
				addEventListener(FocusEvent.FOCUS_IN, onBlockOver) ;
				addEventListener(FocusEvent.FOCUS_OUT, onBlockOver) ;
				addEventListener(MouseEvent.MOUSE_OVER, onBlockOver) ;
				addEventListener(MouseEvent.MOUSE_OUT, onBlockOver) ;
			}else {
				removeEventListener(FocusEvent.FOCUS_IN, onBlockOver) ;
				removeEventListener(FocusEvent.FOCUS_OUT, onBlockOver) ;
				removeEventListener(MouseEvent.MOUSE_OVER, onBlockOver) ;
				removeEventListener(MouseEvent.MOUSE_OUT, onBlockOver) ;
			}
		}
		
		private function onBlockOver(e:Event):void
		{
			if (e is FocusEvent) {
				if (e.type == FocusEvent.FOCUS_IN) {
					if (!focused) {
						if (!opened) open(.25) ;
					}
				}else {
					if (!focused) {
						if (opened) close(.25) ;
					}
				}
			}else {
				if (e.type == MouseEvent.MOUSE_OVER) {
					if (!focused) {
						if (!opened) open(.25) ;
					}
				}else {
					if (!focused) {
						if (opened && !hitTestPoint(stage.mouseX, stage.mouseY)) close(.25) ;
					}
				}
			}
		}
		private function buildItem(section:XML, n:int):Sprite
		{
			var item:SubNavItem = new SubNavItem(this).init(n==0 ? properties.itemTF_XML : properties.small_itemTF_XML, properties.margin) ;
			if (n == 0) {
				properties.min_size = item.properties.size = 30 - item.properties.margin * 2 ;
			} else {
				item.properties.size = 20 ;
			}
			item.read(section) ;
			
			item.tabIndex = Navigation.focusIndex++ ;
			item.focusRect = null ;
			
			var sizeX:int = item.width ;
			item.x = properties.margin ;
			item.y = properties.size.y + properties.margin ;
			properties.size.y += item.size ;
			
			if (properties.size.x < sizeX) properties.size.x = sizeX ;
			
			addChild(item) ;
			return item ;
		}
		public function focus(time:Number = 0):void
		{
			__focused = true ;
			properties.back.alpha = 1 ;
			open(time) ;
		}
		public function unfocus(time:Number = 0):void
		{
			__focused = false ;
			properties.back.alpha = 0 ;
			close(time) ;
		}
		private function shrink(time:Number = 0):void
		{
			var rect:Rectangle = new Rectangle(0, 0, width , 30) ;
			var base:Rectangle = scrollRect ;
			if (time == 0) {
				scrollRect =  rect ;
			} else {
				TweenLite.to(base, time, { ease:Expo.easeOut, 
					height:rect.height,
					onUpdate:function():void {
						scrollRect = base ;
					}
				}) ;
			}
		}
		private function unshrink(time:Number = 0):void
		{
			var rect:Rectangle = new Rectangle(0, 0, width , properties.height) ;
			var base:Rectangle = scrollRect ;
			if (time == 0) {
				scrollRect =  rect ;
			} else {
				TweenLite.to(base, time, { ease:Expo.easeOut, 
					height:rect.height,
					onUpdate:function():void {
						scrollRect = base ;
					}
				}) ;
			}
		}
		public function open(time:Number = 0):void
		{
			__opened = true ;
			unshrink(time) ;
		}
		public function close(time:Number = 0):void
		{
			shrink(time) ;
			__opened = false ;
		}
		
		public function get focused():Boolean { return __focused }
		public function get opened():Boolean { return __opened }
	}
}