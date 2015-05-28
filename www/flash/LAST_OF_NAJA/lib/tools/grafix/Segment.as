package tools.grafix
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Segment 
	{
		private var __vertexArr:Array ;
		private var __indexArr:Array ;
		private var __vertices:Vector.<Number> ;
		private var __uvDatas:Vector.<Number> ;
		private var __indices:Vector.<int> ;
		private var __params:Object ;
		
		public function Segment(_width:Number,_height:Number, _segW:int, _segH:int) 
		{
			__params = { } ;
			__params.vertices = new Vector.<Number>() ;
			__params.uvDatas = new Vector.<Number>() ;
			__params.indices = new Vector.<int>() ;
			
			__params.vertexArr = [] ;
			__params.indexArr = [] ;
			__params.width = _width ;
			__params.height = _height ;
			__params.segW = _segW ;
			__params.segH = _segH ;
			__params.divX = _width / _segW ;
			__params.divY = _height / _segH ;
			
			var startingPoints:Array = [] ;
			var ct:int = 0 ;
			for (var j:int = 0 ; j <= __params.segH; j++ ) {
				__params.vertexArr[j] = [] ; 
				for (var i:int = 0 ; i <= __params.segW; i++ ) {
					var pt:Point = new Point(__params.divX * i , __params.divY * j) ;
					__params.vertices.push(pt.x, pt.y) ;
					__params.uvDatas.push(pt.x/__params.width , pt.y/__params.height) ;
					__params.indexArr.push(ct) ;
					__params.vertexArr[j][i] = pt ;
					if (i < __params.segW  &&  j < __params.segH) {
						startingPoints.push(new Point(ct, ct + __params.segH + 1)) ;
					}
					ct++ ;
				}
			}
			for (i = 0 ; i < __params.segW * __params.segH ; i++ ) {
				var sqInd:Rectangle = new Rectangle( startingPoints[i].x, startingPoints[i].x + 1, startingPoints[i].y + 1, startingPoints[i].y) ;
				__params.indices.push(sqInd.x, sqInd.y, sqInd.height, sqInd.y, sqInd.width, sqInd.height )
			}
		}
		public function get vertex():Array { return __params.vertexArr }
		public function get index():Array { return __params.indexArr }
		public function get vertices():Vector.<Number> { return __params.vertices }
		public function get indices():Vector.<int> { return __params.indices }
		public function get uvDatas():Vector.<Number> { return __params.uvDatas }
	}
}