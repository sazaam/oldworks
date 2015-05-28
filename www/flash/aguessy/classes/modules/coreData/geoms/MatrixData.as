package modules.coreData.geoms
{
	import flash.geom.Matrix;
	
	import modules.coreData.CoreData;
	import modules.foundation.Comparable;	
				 
	public class MatrixData extends CoreData implements Comparable
	{
		/**
		 * 
		 * @param	source
		 */
		public function MatrixData(source:Object=null)
		{
			super(source);
		}
		
		/**
		 * 
		 * @return
		 */
		public function cloneMatrix():Matrix
		{
			return _matrix.clone();	
		}
		
		/**
		 * 
		 * @param	matrix
		 */
		public function concat(matrix:MatrixData):void
		{
			_matrix.concat(matrix.cloneMatrix());
		}
		
		//TODO : Implements comparison alghorithm
		/**
		 * 
		 * @param	T
		 * @return
		 */
		public function compareTo(T:Object):int
		{
			if (!(T is MatrixData))
				throw new TypeError();
			var matrix:MatrixData = T as MatrixData;
			/*if (dimension.surface < surface)
				return -1;
			else if (dimension.surface > surface)
				return 1;*/
			return 0;
		}
		
		/**
		 * 
		 * @param	scaleX
		 * @param	scaleY
		 * @param	rotation
		 * @param	tx
		 * @param	ty
		 */
		public function createBox(scaleX:Number, scaleY:Number, rotation:Number = 0, tx:Number = 0, ty:Number = 0):void
		{
			_matrix.createBox.apply(_matrix, arguments);
		}
		
		/**
		 * 
		 * @param	width
		 * @param	height
		 * @param	rotation
		 * @param	tx
		 * @param	ty
		 */
		public function createGradientBox(width:Number, height:Number, rotation:Number = 0, tx:Number = 0, ty:Number = 0):void
		{
			_matrix.createGradientBox.apply(_matrix, arguments);
		}
		
		/**
		 * 
		 * @param	point
		 * @return
		 */
		public function deltaTransformLocation(location:Location):Location
		{
			return new Location(_matrix.deltaTransformPoint(location.clonePoint()));
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
			if(!(T is MatrixData))
				return false;
			var matrix:MatrixData = T as MatrixData;
			return hashCode() ==  matrix.hashCode() && a == matrix.a && b ==  matrix.b && c == matrix.c && d ==  matrix.d && tx == matrix.tx && ty == matrix.ty;
		}
		
		public function fromMatrix(source:Matrix):MatrixData
		{
			_matrix = source.clone();
			return this;
		}
		
		/**
		 * 
		 * @return
		 */
		override public function hashCode():int
		{
			return super.hashCode() + a + b + c + d + tx + ty;
		}
		
		/**
		 * 
		 */
		public function identity():void
		{
			_matrix.identity();
		}
		
		/**
		 * 
		 */
		public function invert():void
		{
			_matrix.invert();
		}
		
		/**
		 * 
		 * @param	angle
		 */
		public function rotate(angle:Number):void
		{
			_matrix.rotate(angle);
		}
		
		/**
		 * 
		 * @param	dx
		 * @param	dy
		 */
		public function translate(dx:Number, dy:Number):void
		{
			_matrix.translate(dx, dy);
		}
		
		public function get a():Number
		{
			return _matrix.a;
		}	
		
		public function set a(value:Number):void
		{
			_matrix.a = value;
		}	
				
		public function get b():Number
		{
			return _matrix.b;
		}		
		
		public function set b(value:Number):void
		{
			_matrix.b = value;
		}	
				
		public function get c():Number
		{
			return _matrix.c;
		}
		
		public function set c(value:Number):void
		{
			_matrix.c = value;
		}	
				
		public function get d():Number
		{
			return _matrix.d;
		}		
		
		public function set d(value:Number):void
		{
			_matrix.d = value;
		}	
				
		public function get tx():Number
		{
			return _matrix.tx;
		}		
		
		public function set tx(value:Number):void
		{
			_matrix.tx = value;
		}	
				
		public function get ty():Number
		{
			return _matrix.ty;
		}				
		
		public function set ty(value:Number):void
		{
			_matrix.ty = value;
		}	
		
		/**
		 * 
		 * @return
		 */
		override protected function getInitializer():Object
		{
			var accessors:Array = getClass().accessors;
			var o:Object = {};
			accessors.forEach(function(el:*, i:int, arr:Array):void {
				switch(el.name) {
					case "a" :
					case "d" : 
						o[el.name] = 1;
						break;
					case "b" : 
					case "c" :
					case "tx" :
					case "ty" :
						o[el.name] = 0;
						break;
				}
			}, this);
			return o;
		}
		
		/**
		 * 
		 * @param	source
		 */
		override protected function setup(source:Object):void
		{	
			_matrix = new Matrix();
			super.setup(source);	
		}
		
		private var _matrix:Matrix;
	}
}