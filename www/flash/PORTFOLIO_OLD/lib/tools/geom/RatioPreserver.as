package tools.geom 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class RatioPreserver 
	{
		public static function preserveRatio(elementSize:Rectangle,requestedPerimeter:Rectangle,centered:Boolean = false):Rectangle
		{
			var r:Rectangle = requestedPerimeter ;
			var p:Rectangle = elementSize ;
			var ratio:Number = p.width / p.height ;
			// reset
			p.width = 1 ;
			p.height = 1 ;
			if (p.width < r.width) {
				p = redimension("width",p,r,ratio)
			}
			if (p.height < r.height) {
				p = redimension("height",p,r,ratio)
			}
			if (centered) {
				p.x = (r.width - p.width) >> 1 ;
				p.y = (r.height - p.height) >> 1;
			}
			return p ;
		}
		
		static private function redimension(accordingTo:String, p:Rectangle,r:Rectangle,ratio:Number):Rectangle
		{
			if (accordingTo == "height") {
				p.height = r.height ;
				p.width = Math.round(p.height * ratio) ;
			}else {
				p.width = r.width ;
				p.height = Math.round(p.width / ratio) ;
			}
			return p ;
		}
	}
}