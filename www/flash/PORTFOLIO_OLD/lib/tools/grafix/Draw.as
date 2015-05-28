package tools.grafix
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Draw 
	{
		static public function clear(g:Graphics):Class
		{
			g.clear() ;
			return Draw ;
		}
		static public function redraw(type:String, params:Object = null, ...rest:Array ):Object 
		{
			return clear(params.g).draw.apply(null, [type, params].concat(rest)) ;
		}
		static public function draw(type:String, params:Object = null, ...rest:Array ):Object
		{
			var g:Graphics , color:uint, alpha:Number;
			try 
			{
				g = params["g"] ;
				color = params["color"] ;
				alpha = params["alpha"] ;
			}catch (e:Error)
			{
				throw (new ArgumentError("Params Array should be defined, such as {g:Graphics, color:uint, alpha:Number}... " + Draw)) ;
			}
			switch(type) {
				case 'rect': 
					try {
						var r:Rectangle = new Rectangle(rest[0], rest[1], rest[2], rest[3]) ;
					}catch (e:Error) {
						throw (new ArgumentError("Params rest should be defined here as a Rectangle, like '([...],rect.x,rect.y,rect.width,rect.height)' ... " + Draw)) ;
					}
					g.beginFill(color, alpha) ;
					g.drawRect(r.x, r.y, r.width, r.height) ;
					g.endFill() ;
					params["shape"] = r ;
				break ;
				default :
					throw(new ArgumentError("type of drawable is not implemented yet... "+ Draw))
				break ;
			}
			return params ;
		}
	}
	
}