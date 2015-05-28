package modules.coreData.geoms
{
	import flash.geom.Rectangle;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import modules.coreData.CoreData;
	import modules.coreData.Module;
	import modules.foundation.Comparable;
	import modules.foundation.Type;

	public class Box extends CoreData implements Module, Comparable
	{
		/**
		 * 
		 * @param	source
		 */
		public function Box(source:Object=null)
		{
			super(source);
		}
		
		/**
		 * 
		 * @return
		 */
		public function cloneRectangle():Rectangle
		{
			return _rectangle.clone();
		}
		
		/**
		 * 
		 * @param	T
		 * @return
		 */
		public function compareTo(T:Object):int
		{
			if (!(T is Box))
				throw new TypeError();
			var module:Box = T as Box;
			if (module.surface < surface)
				return -1;
			else if (module.surface > surface)
				return 1;
			return 0;
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function contains(x:Number, y:Number):Boolean
		{
			return _rectangle.contains(x, y);
		}
		
		/**
		 * 
		 * @param	location
		 * @return
		 */
		public function containsLocation(location:Location):Boolean
		{
			return _rectangle.containsPoint(location.clonePoint());
		}
		
		/**
		 * 
		 * @param	rect
		 * @return
		 */
		public function containsRect(rect:Box):Boolean
		{
			return _rectangle.containsRect(rect.cloneRectangle());
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
    		if (!(T is Box))
    			return false;
			var module:Box = T as Box;
			return module.location.equals(location) && module.surface == surface && module.hashCode() == hashCode();			
		}
		
		public function fromRect(rect:Rectangle):Box
		{
			x = rect.x;
			y = rect.y;
			width = rect.width;
			height = rect.height;
			return this;
		}
		
		/**
		 * 
		 * @return
		 */
		override public function hashCode():int
		{
			return getClass().defaultHashCode + surface;
		}
		
		/**
		 * 
		 * @param	dx
		 * @param	dy
		 */
		public function inflate(dx:Number, dy:Number):void
		{
			_rectangle.inflate(dx, dy);
		}
		
		/**
		 * 
		 * @param	location
		 */
		public function inflateLocation(location:Location):void
		{
			_rectangle.inflatePoint(location.clonePoint());
		}
		
		/**
		 * 
		 * @param	toIntersect
		 * @return
		 */
		public function intersection(toIntersect:Box):Box
		{
			return new Box(_rectangle.intersection(toIntersect.cloneRectangle()));
		}
		
		/**
		 * 
		 * @param	toIntersect
		 * @return
		 */
		public function intersects(toIntersect:Box):Boolean
		{
			return _rectangle.intersects(toIntersect.cloneRectangle());
		}
		
		/**
		 * 
		 * @return
		 */
		public function isEmpty():Boolean
		{
			return _rectangle.isEmpty();
		}
		
		/**
		 * 
		 * @param	dx
		 * @param	dy
		 */
		public function offset(dx:Number, dy:Number):void
		{
			_rectangle.offset(dx, dy);
		}
		
		/**
		 * 
		 * @param	location
		 */
		public function offsetLocation(location:Location):void
		{
			_rectangle.offsetPoint(location.clonePoint());
		}
		
		/**
		 * 
		 * @param	input
		 */
		override public function readExternal(input:IDataInput):void
		{
			getClass().accessors.forEach(function(el:*, i:int, arr:Array):void {
				 if(el.access != Type.READONLY) {
				 	if (this[el.name] is Location)
				 		this[el.name] = input.readObject();
				 	else if (this[el.name] is Dimension)
				 		this[el.name] = input.readObject();
				 	else if (this[el.name] is Number)
				 		this[el.name] = input.readFloat();
				 }
			}, this);
		}
				
		/**
		 * 
		 * @param	toUnion
		 * @return
		 */
		public function union(toUnion:Box):Box
		{
			return new Box(_rectangle.union(toUnion.cloneRectangle()));
		}	
		
		/**
		 * 
		 * @param	output
		 */
		override public function writeExternal(output:IDataOutput):void
		{
			getClass().accessors.forEach(function(el:*, i:int, arr:Array):void {
				 if(el.access != Type.READONLY) {
				 	if (this[el.name] is Location)
				 		output.writeObject(Location(this[el.name]).clone());
				 	else if (this[el.name] is Dimension)
				 		output.writeObject(Dimension(this[el.name]).clone());
				 	else if (this[el.name] is Number)
				 		output.writeFloat(this[el.name]); 
				 }
			}, this);
		}
				
		public function get bottom():Number 
		{
			return _rectangle.bottom;
		}
		
		public function set bottom(n:Number):void 
		{
			_rectangle.bottom = n;
		}
		
		public function get bottomRight():Location 
		{
			return new Location(_rectangle.bottomRight);
		}
		
		public function set bottomRight(value:Location):void 
		{
			_rectangle.bottomRight = value.clonePoint();
		}
						
		public function get dimension():Dimension 
		{
			return new Dimension({width:_rectangle.width, height:_rectangle.height});
		}
		
		public function set dimension(value:Dimension):void 
		{
			_rectangle.width = value.width;
			_rectangle.height = value.height;
		}
								
		public function get height():Number 
		{
			return _rectangle.height;
		}
		
		public function set height(n:Number):void 
		{
			_rectangle.height = n;
		}
						
		public function get left():Number 
		{
			return _rectangle.left;
		}
		
		public function set left(n:Number):void 
		{
			_rectangle.left = n;
		}
						
		public function get location():Location 
		{
			return new Location({x:_rectangle.x, y:_rectangle.y});
		}
		
		public function set location(value:Location):void 
		{
			_rectangle.x = value.x;
			_rectangle.y = value.y;
		}
								
		public function get right():Number 
		{
			return _rectangle.right;
		}
		
		public function set right(n:Number):void 
		{
			_rectangle.right = n;
		}

		public function get surface():Number
		{
			return width * height;
		}
		
		public function get top():Number 
		{
			return _rectangle.top;
		}
		
		public function set top(value:Number):void 
		{
			_rectangle.top = value;
		}

		public function get topLeft():Location 
		{
			return new Location(_rectangle.topLeft);
		}
		
		public function set topLeft(value:Location):void 
		{
			_rectangle.topLeft = value.clonePoint();
		}
												
		public function get width():Number 
		{
			return _rectangle.width;
		}
		
		public function set width(n:Number):void 
		{
			_rectangle.width = n;
		}
												
		public function get x():Number 
		{
			return _rectangle.x;
		}
		
		public function set x(n:Number):void 
		{
			_rectangle.x = n;
		}
												
		public function get y():Number 
		{
			return _rectangle.y;
		}
		
		public function set y(n:Number):void 
		{
			_rectangle.y = n;
		}
		
		/**
		 * 
		 * @return
		 */
		override protected function getInitializer():Object
		{
			var o:Object = {};
			getClass().accessors.forEach(function(el:*, i:int, arr:Array):void {
				if (el.access != Type.READONLY)
					if (el.name == "x" || el.name == "y" || el.name == "width" || el.name == "width") 
						o[el.name] = 0;
					
			}, this);
			return o;
		}
		
		/**
		 * 
		 * @param	source
		 */
		override protected function setup(source:Object):void
		{	
			_rectangle = new Rectangle();
			super.setup(source);	
		}
		
		private var _rectangle:Rectangle;
	}
}