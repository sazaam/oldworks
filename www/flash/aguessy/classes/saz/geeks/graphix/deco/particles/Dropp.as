package saz.geeks.graphix.deco.particles 
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Dropp 
	{
		private var _x:Number ;
		private var _y:Number ;
		private var _z:Number ;
		private var _diameter:uint ; 
		private var _life:uint ;
		
		private var _graphics:Graphics ;
		

		
		public function Dropp(_point3D:Point3D,__diameter:uint = 1,__life:uint = 200)
		{
			x = _point3D.x ;
			y = _point3D.y ;
			z = _point3D.z ;
			diameter = __diameter ;
			life = __life ;
		}
		
		public function moveAlongPoint3D(toPoint:Point3D):void
		{
			x = toPoint.x
			y = toPoint.y
			z = toPoint.z
			
			draw(_graphics);
			
		}
		
		public function draw(__graphics:Graphics = null,_col:uint =0xFFFFFF):void
		{
			_graphics = __graphics ;
			_graphics.clear() ;
			_graphics.beginFill(_col) ;
			_graphics.drawCircle(x,y,diameter) ;
			
			//diameter++ ;
			//life-- ;
			//if (life == 0) delete this  ;
		}
		
		public function moveAlongVector(vector:Vector3D):void
		{
			
			
			
			
			//draw()
		}
		
		public function get z():int { return _z; }
		public function set z(value:int):void { _z = value; }
		public function get y():int { return _y; }
		public function set y(value:int):void { _y = value; }
		public function get x():int { return _x; }
		public function set x(value:int):void { _x = value;	}
		public function get diameter():uint { return _diameter; }
		public function set diameter(value:uint):void { _diameter = value; }
		
		public function get life():uint { return _life; }
		
		public function set life(value:uint):void 
		{
			_life = value;
			
			
			
		}
	}
	
}