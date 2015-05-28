package modules.coreData.geoms
{
	import flash.geom.Point;

	import modules.coreData.CoreData;
	import modules.foundation.Comparable;
	
	public class Location extends CoreData implements Comparable
	{
		/**
		 * 
		 * @param	source
		 */
		public function Location(source:Object=null)
		{
			super(source);
		}
		
		/**
		 * 
		 * @param	v
		 * @return
		 */
		public function add(location:Location):Location
		{
			return new Location(_point.add(location.clonePoint()));
		}

		/**
		 * 
		 * @return
		 */
		public function clonePoint():Point
		{
			return _point.clone();
		}
		
		/**
		 * 
		 * @param	T
		 * @return
		 */
		public function compareTo(T:Object):int
		{
			if (!(T is Location))
				throw new TypeError();
			var location:Location = T as Location;
			if (location.x < x && location.y < y)
				return -1;
			else if (location.x > x && location.y > y)
				return 1;
			return 0;
		}
		
		/**
		 * 
		 * @param	pt1
		 * @param	pt2
		 * @return
		 */
		public function distance(pt1:Location, pt2:Location):Number
		{
			return Point.distance(pt1.clonePoint(), pt2.clonePoint());
		}
		
		/**
		 * 
		 * @param	T
		 * @return
		 */
		override public function equals(T:Object):Boolean
		{
			if (T == this)
				return true;
			if (!(T is Location))
				return false;
			var location:Location = T as Location;
			return location.hashCode() == hashCode() && location.x == x && location.y == y
		}	
		
		public function fromPoint(source:Point):Location
		{
			x = source.x;
			y = source.y;
			return this;
		}
		
		/**
		 * 
		 * @return
		 */
		override public function hashCode():int
		{
			return getClass().defaultHashCode + x + y;
		}
		
		/**
		 * 
		 * @param	location
		 * @param	f
		 * @return
		 */
		public function interpolate(location:Location, f:Number):Location
		{
			return new Location(Point.interpolate(_point, location.clonePoint(), f));
		}
		
		/**
		 * 
		 * @param	thickness
		 */
		public function normalize(thickness:Number):void
		{
			_point.normalize(thickness);
		}
		
		/**
		 * 
		 * @param	dx
		 * @param	dy
		 */
		public function offset(dx:Number, dy:Number):void
		{
			_point.offset(dx, dy); 
		}
		
		/**
		 * 
		 * @param	len
		 * @param	angle
		 * @return
		 */
		public function polar(len:Number, angle:Number):Location
		{
			return new Location(Point.polar(len, angle));
		}
		
		/**
		 * 
		 * @param	v
		 * @return
		 */
		public function subtract(location:Location):Location
		{
			return new Location(_point.subtract(location.clonePoint()));
		}
	
		public function get length():Number
		{
			return _point.length;
		}
		
		public function get x():Number
		{
			return _point.x;
		}
		
		public function set x(value:Number):void
		{
			_point.x = value;
		}
		
		public function get y():Number
		{
			return _point.y;
		}
		
		public function set y(value:Number):void
		{
			_point.y = value;
		}
		
		/**
		 * 
		 * @return
		 */
		override protected function getInitializer():Object
		{
			var o:Object = {};
			getClass().accessors.forEach(function(el:*, i:int, arr:Array):void {
				switch(el.name) {
					case "x" : 
					case "y" : 
						o[el.name] = 0;
						break;
				}
			});
			return o;
		}
		
		/**
		 * 
		 * @param	source
		 */
		override protected function setup(source:Object):void
		{	
			_point = new Point();
			super.setup(source);	
		}
		
		private var _point:Point;			
	}
}