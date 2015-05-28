package pro.navigation.saznav.highlight 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gs.easing.Expo;
	import gs.TweenLite;
	import tools.fl.sprites.SmartShape;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Arrow extends SmartShape
	{
		
		public function Arrow() 
		{
			
		}
		
		public function init(index:int, _name:String, size:int, margin:Point):Arrow
		{
			name = properties.name = _name ;
			properties.index = index ;
			properties.size = size ;
			properties.margin = margin ;
			
			return this ;
		}
		
		public function draw(thickness:int, color:uint, _alpha:Number, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
			var size:int = properties.size ;
			properties.thickness = thickness ;
			properties.color = color ;
			properties.alpha = _alpha ;
			graphics.lineStyle(thickness, color, _alpha, pixelHinting, scaleMode,caps, joints, miterLimit) ;
			graphics.moveTo(-size, 0) ;
			graphics.lineTo(size, 0) ;
			graphics.moveTo(0, -size) ;
			graphics.lineTo(0, size) ;
			graphics.endFill() ;
		}
		
		public function pos(ref:Rectangle, time:Number = 0):Point
		{
			var margin:Point = properties.margin ;
			var p:* ;
			if (time != 0) {
				p = {} ;
			}else {
				p = this ;
			}
			switch(name) {
				case "TL" :
					p.x = ref.x -margin.x ;
					p.y = ref.y - margin.y ;
				break ;
				case "TR" :
					p.x = ref.x + ref.width + margin.x -1; 
					p.y = ref.y - margin.y ; 
				break ;
				case "BR" :
					p.x = ref.x + ref.width + margin.x -1; 
					p.y = ref.y + ref.height + margin.y -1; 
				break ;
				case "BL" :
					p.x = ref.x - margin.x ;
					p.y = ref.y + ref.height + margin.y -1; 
				break ;
			}
			if (time != 0) {
				p.ease = Expo.easeOut ;
				TweenLite.to(this, time, p) ;
			}
			return new Point(p.x, p.y) ;
		}
		
	}
	
}