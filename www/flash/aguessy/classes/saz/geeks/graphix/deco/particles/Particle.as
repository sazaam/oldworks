package saz.geeks.graphix.deco.particles 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public class Particle 
	{
		private var w:uint = 800;
		private var h:uint = 600;
		
		public var x:Number;
		public var y:Number;
		public var vx:Number;
		public var vy:Number;
		public var color:uint = 0xFF330000;
		public var life:uint;
		
		public function Particle(_x:Number, _y:Number):void {
			x = _x;
			y = _y;
			vx = 5*(Math.random()-Math.random());
			vy = 5*(Math.random()-Math.random());
			life = 500+Math.round(Math.random()*500);
		}
		
		public function move(_value:uint):void {
			
			var r:uint = _value >> 16;
			var g:uint = _value >> 8 & 255;
			var b:uint = _value & 255;
			
			vx += (r-b)/100;
			vy += (g-b)/100;
			
			// clip
			vx = Math.min(vx, 5);
			vy = Math.min(vy, 5);
			vx = Math.max(vx, -5);
			vy = Math.max(vy, -5);
			
			x += vx;
			y += vy;
			
			if(x < 0 || x > w) {
				vx *= -1;
			}
			
			if(y < 0 || y > h) {
				vy *= -1;
			}

			life -= 1;
			r = (x / w) * 255;
			g = (y / h) * 255;
			b = Math.abs(Math.round((vx+vy)))*10;
			color = (255 << 24 | r << 16 | g << 8 | b);
		}
	}
	
}