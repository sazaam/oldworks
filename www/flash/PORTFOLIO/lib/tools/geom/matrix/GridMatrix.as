package tools.geom.matrix 
{
	/**
	 * ...
	 * @author saz
	 */
	import fl.motion.DynamicMatrix;
	
	public class GridMatrix extends DynamicMatrix
	{
		private var __base:int = -1;
		private var __limit:int;
		private var __indexLimit:int;
		private var __total:int;
		private var m_length:int;
		///////////////////// CTOR
		public function GridMatrix(w:int, h:int, limit:int = -1) {
			super(w, h) ;
			__total = w * h
			if (limit == -1) limit = __total ;
			__limit = limit ;
			__cleanMatrix() ;
			identity() ;
		}
		public function identity():void 
		{
			for (var i:int = 0 ; i < __total ;  i++ ) {
				var divX:int = i % m_width ;
				var divY:int = int(i / m_width) ;
				if (i < __limit) {
					SetValue( divY, divX , i) ;
				}else {
					SetValue( divY, divX , __base) ;
				}
			}
			m_length = m_matrix.length ;
		}
		private function __cleanMatrix():void 
		{
			m_matrix.forEach(function(el, i, arr) {
				el.splice( -(m_height - m_width)) ;
			})
		}
		public function shiftRow(n:Number):void 
		{
			shiftCol(n * m_width) ;
		}
		public function shiftCol(n:int):void 
		{
			for (var i:int = 0 ; i < m_height ; i++ ) {
				for (var j:int = 0 ; j < m_width ; j ++ ) {
					var arr:Array = m_matrix[i] ;
					var el:int = arr[j] ;
					if (el == -1) {
						//
					}else if (el + n < 0) {
						arr[j] = __limit + n + el ;
					}else if (el + n < __limit) {
						arr[j] += n ;
					}else {
						arr[j] = -(__limit - n - el) ;
					}
				}
			}
		}
		public function toString():String
		{
			var str:String = '[ [Object GridMatrix] >>' ;
			for (var i:int = 0 ; i < m_height ; i ++ ) {
				str += '\n	' ;
				for (var j:int = 0 ; j < m_width ; j ++ ) {
					str +=  '		'+GetValue( i, j) ;
				}
			}
			str += '\n]' ;
			
			return str ;
		}
		public function getSubMatrix(colsLimit:int, rowsLimit:int):GridMatrix
		{
			var m:GridMatrix = new GridMatrix(colsLimit, rowsLimit) ;
			m.m_matrix = [].concat(m_matrix.slice(0, rowsLimit)) ;
			return m ;
		}
		public function get matrix():Array { return m_matrix }
		public function get concatenatedMatrix():Array { return m_matrix.join(',').split(',').map(stringToInt) }
		
		static public function stringToInt(el:String, i:int, arr:Array):int
		{
			return int(el) ;
		}
		public function get concatenatedLength():int { return __limit }
		public function get totalLength():int { return __total }
	}

}