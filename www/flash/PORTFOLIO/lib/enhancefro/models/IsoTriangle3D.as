package enhancefro.models 
{
	import frocessing.f3d.F3DModel;
	
	/**
	 * ...
	 * @author saz
	 */

	public class IsoTriangle3D extends F3DModel
	{
		public function IsoTriangle3D(size:Number = 50, segment:int = 2)
		{
			super();
			backFaceCulling = false;
			initModel( size , segment);
		}
		
		/** @private */
		private function initModel( size:Number, seg:int):void
		{
			beginVertex(TRIANGLES) ;
			
			var total:int = seg + 1 ;
			var hh:Number = 0 ;
			var midSize:Number = size * .5 ;
			hh = int(Math.sqrt((size*size) - (midSize*midSize))) ;
			var diff:Number = size - hh ;
			var midW:Number = size * .5 ;
			var midH:Number = hh * .5 ;
			var divX:Number = size / (total) ;
			var divY:Number = hh / (total) ;
			
			var startX:Number = - midW ;
			var startY:Number = - (hh - diff) / 2 ;
			var startIndY:Number = (size - hh)/2 / size;
			var unitX:Number = 1/ (total*2) ;
			
			 for ( var i:int = 0 ; i <= seg; i++ ) {
				var curX:Number =  midW + ( - i * divX * .5) ;
				var curX2:Number =  midW + ( - i * divX) ;
				var curY:Number =  divY * i ;
				
				for ( var j:int = 0; j <= i ; j ++ ) {
					var xx:Number = curX + divX * j ;
					var yy:Number = curY ;
					var indX:Number = xx / size - unitX ;
					var indY:Number = yy / hh ;
					
					var result0:Number = indX + (divX  / size / 2) ;
					var result1:Number = indX + (divX  / size) ;
					var result2:Number = indX ;
					
					if (j != 0) {
						addVertex(startX + xx - divX, startY + (yy - divY / 2), 0,
								result1 - unitX*3, indY - startIndY) ;
						addVertex(startX + xx, startY + (yy - divY / 2), 0,
								result1 - unitX, indY - startIndY) ;
						addVertex(startX + (xx - divX / 2), startY + (yy + divY / 2), 0,
								result1 - unitX*2, indY + (divY / hh) - startIndY) ;
					}
					addVertex(startX + xx, startY + (yy - divY / 2), 0, 
							 result0, indY - startIndY) ;
					addVertex(startX + (xx + divX / 2), startY + (yy + divY / 2), 0, 
							result1, indY + (divY / hh) - startIndY) ;
					addVertex(startX + (xx - divX / 2), startY + (yy + divY / 2), 0, 
							result2, indY + (divY / hh) - startIndY) ;
				}
			}
			endVertex() ;
		}
		
		public function toString():String 
		{
			return '[object IsoTriangle3D] >> ( x:'+x+', y:'+y+', z:'+z+')' ;
		}
	}

}