package pro.navigation.saznav.highlight 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gs.TweenLite;
	import tools.fl.sprites.Smart;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Arrows extends Smart
	{
		
		public function Arrows() 
		{
			properties.arrows = [{name:"TL"}, {name:"TR"}, {name:"BR"}, {name:"BL"}] ;
		}
		
		public function init(baseCoords:Rectangle, arrowsSize:int = 2, arrowsMargin:Point = null):Arrows
		{
			properties.arrows_size =  arrowsSize ;
			properties.arrows_base =  baseCoords ;
			properties.arrows_coords =  baseCoords ;
			arrowsMargin = properties.arrows_margin =  arrowsMargin || new Point(4,4) ;
			var arr:Array  = properties.arrows ;
			for (var i:int = 0 ; i < arr.length ; i++ ) {
				var arrow:Arrow = arr[i].arrow = new Arrow().init(i, arr[i].name, arrowsSize, arrowsMargin) ;
				arrow.draw(1, 0xFF0000, .7, true, "none", "square", "miter", 4) ;
				addChild(arrow) ;
			}
			posArrows(baseCoords) ;
			return this ;
		}
		
		public function posArrows(ref:Rectangle = null, time:Number = 0):Object
		{
			var o:Object = { } ;
			var arr:Array  = properties.arrows ;
			var d:Rectangle = ref || properties.arrows_base ;
			for (var i:int = 0 ; i < arr.length ; i++ ) {
				var arrow:Arrow = Arrow(arr[i].arrow) ;
				o[arrow.name] = arrow.pos(d, time) ;
			}
			properties.arrows_coords = d ;
			return o ;
		}
		
	}
}