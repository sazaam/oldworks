package pro.navigation.saznav 
{
	import asSist.$;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	
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
			mouseChildren = false ;
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
			.attr( { id:__block.properties.id + id , name:"itemTF_" + id, text:label } )
			.appendTo(this)[0] ;
		}
/////////////////////////////////////////////////////////////////////////////////GRAPHICS
		public function createBack(largestSize:Number):Sprite
		{
			var over:Sprite = properties.over = new Sprite() ;
			Draw.draw("rect", { g:over.graphics, color:0xFF0000, alpha:1 }, 0, 0, largestSize, size) ;
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
			if (e is FocusEvent){
				if (e.type == FocusEvent.FOCUS_IN) {
					execOver() ;
				}else{
					execOver(false) ;
				}
			}else{
				if (e.type == MouseEvent.ROLL_OVER) {
					execOver() ;
				}else {
					execOver(false) ;
				}
			}
		}
		
		private function execOver(cond:Boolean = true):void
		{
			var over:Sprite = properties.over
			var tf:TextField = $("#" + __block.properties.id + properties.id)[0] ;
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
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get size():Number
		{
			return properties.size ;
		}
	}
}