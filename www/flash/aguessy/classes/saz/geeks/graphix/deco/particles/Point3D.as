package saz.geeks.graphix.deco.particles 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public class Point3D 
	{
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		
		public function Point3D(__x:Number = 0, __y:Number = 0,__z:Number = 0 ) 
		{
			_x = __x;
			_y = __y;
			_z = __z;
		}
		
		public function middle(toPoint:Point3D):Point3D
		{
			return new Point3D(toPoint.x - x, toPoint.y - y, toPoint.z - z);
		}
		
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void { _x = value; }
		public function get y():Number { return _y; }
		public function set y(value:Number):void { _y = value; }
		public function get z():Number { return _z; }
		public function set z(value:Number):void { _z = value; }
	}
	
}