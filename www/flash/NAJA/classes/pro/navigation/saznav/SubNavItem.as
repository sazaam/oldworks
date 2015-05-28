package pro.navigation.saznav 
{
	import asSist.$;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import naja.tools.api.geom.Draw;
	import tools.fl.sprites.Smart;
	
	/**
	 * ...
	 * @author saz
	 */
	public class SubNavItem extends Smart
	{
		private var __block:SubNavBlock;
		public function SubNavItem(block:SubNavBlock) 
		{
			__block = block ;
		}
		public function init(tfXml:XML, margin:int):SubNavItem
		{
			properties.tf_xml = tfXml ;
			properties.margin = margin ;
			return this ;
		}
		public function read(section:XML):void
		{
			var n:int = properties.index =  section.childIndex() ;
			
			var id:String = properties.id = section.@id.toXMLString() ;
			var label:String = properties.label = section.@label.toXMLString() ;
			name = id ;
			var tf:TextField = $(properties.tf_xml)
			.attr( { name:"itemTF_" + id, text:label } )
			.appendTo(this)[0] ;
		}
/////////////////////////////////////////////////////////////////////////////////GRAPHICS
		public function createBack(largestSize:Number):Sprite
		{
			var over:Sprite = properties.over = new Sprite() ;
			Draw.draw("rect", { g:over.graphics, color:0xD20000, alpha:1 }, 0, 0, largestSize, size) ;
			over.alpha = 0 ;
			addChildAt(over, 0) ;
			return over ;
		}
///////////////////////////////////////////////////////////////////////////////// EVENTS
		public  function enable(cond:Boolean = true):void
		{
			if (cond) {
				addEventListener(MouseEvent.ROLL_OVER, onItemOver) ;
				addEventListener(MouseEvent.ROLL_OUT, onItemOver) ;
				addEventListener(FocusEvent.FOCUS_IN, onItemOver) ;
				addEventListener(FocusEvent.FOCUS_OUT, onItemOver) ;
				addEventListener(properties.event.type, properties.event.closure) ;
			}else {
				removeEventListener(MouseEvent.ROLL_OVER, onItemOver) ;
				removeEventListener(MouseEvent.ROLL_OUT, onItemOver) ;
				removeEventListener(FocusEvent.FOCUS_IN, onItemOver) ;
				removeEventListener(FocusEvent.FOCUS_OUT, onItemOver) ;
				removeEventListener(properties.event.type, properties.event.closure) ;
			}
		}
		private function onItemOver(e:Event):void 
		{
			var over:Sprite = properties.over ;
			if (e is FocusEvent){
				if (e.type == FocusEvent.FOCUS_IN) {
					over.alpha = 1 ;
				}else{
					over.alpha = 0 ;
				}
			}else{
				if (e.type == MouseEvent.ROLL_OVER) {
					over.alpha = 1 ;
				}else {
					over.alpha = 0 ;
				}
			}
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get size():Number
		{
			return properties.size ;
		}
	}
}