package modules.coreData.geoms
{
	import modules.coreData.CoreData;
	import modules.foundation.Comparable;
	
	public class Dimension extends CoreData implements Comparable
	{
		/**
		 * 
		 * @param	source
		 */
		public function Dimension(source:Object=null) 
		{
			super(source);
		}
		
		/**
		 * 
		 * @param	T
		 * @return
		 */
		public function compareTo(T:Object):int
		{
			if (!(T is Dimension))
				throw new TypeError();
			var dimension:Dimension = T as Dimension;
			if (dimension.surface < surface)
				return -1;
			else if (dimension.surface > surface)
				return 1;
			return 0;
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
    		if (!(T is Dimension))
    			return false;
			var dimension:Dimension = T as Dimension;
			return dimension.surface == surface;
		}
		
		public function from(w:Number, h:Number):Dimension
		{
			width = w;
			height = h;
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
			
		public function get height():Number 
		{
			return _height;
		}
		
		public function set height(n:Number):void 
		{
			_height = n;
		}
		
		public function get width():Number 
		{
			return _width;
		}
		
		public function set width(n:Number):void 
		{
			_width = n;
		}
		
		public function get surface():Number
		{
			return width * height;
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
					case "width" : 
					case "height" : 
						o[el.name] = 0;
						break;
				}
			});
			return o;
		}

		private var _height:Number;
		private var _width:Number;		
	}
}