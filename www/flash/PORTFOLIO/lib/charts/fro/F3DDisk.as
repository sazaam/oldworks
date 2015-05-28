package charts.fro 
{
	import frocessing.f3d.F3DModel;
	import frocessing.math.FMath;
	
	/**
	 * ...
	 * @author saz
	 */
	public class F3DDisk extends F3DModel 
	{
		
		public function F3DDisk(radiusW:Number = 50, radiusH:Number = NaN, size:Number = 20, segmentCirc:uint = 12, segmentZ:uint = 1) 
		{
			super();
			radiusH = radiusH || radiusW ;
			backFaceCulling = true;
			initModel(radiusW, radiusH, size, segmentCirc, segmentZ);
		}
		/** @private */
		private function initModel( rW:Number, rH:Number, size:Number, sC:uint, sZ:uint ):void
		{
			 
			//void cylinder(float w, float h, int sides)
			//{
			  var angle=Number;
			  
			  
			  var arrX:Array = [sC+1] ;
			  var arrY:Array = [sC+1] ;
			 
			  //get the x and z position on a circle for all the sides
			  var l:int = arrX.length ;
			  for(var n:int = 0 ; n < l ; n++){
				angle = FMath.TWO_PI / (sC) * n;
				arrX[n] = Math.cos(angle) * rW;
				arrY[n] = Math.sin(angle) * rH;
			  }
			 
			  //draw the top of the cylinder
			  beginVertex(TRIANGLE_MESH, l) ;
				  for(var i:int =0; i < l ; i++){
					addVertex(arrX[i], arrY[i], 0, i/l, i/l);
				  }
			  endVertex() ;
			 
			  //draw the center of the cylinder
			  //beginVertex(TRIANGLE_MESH, sC+1); 
			  //for(var j:int = 0 ; j < l ; j++){
				//addVertex(arrX[j], -rH/2, arrZ[j], (j+1)/sC, (j+1)/sC);
				//addVertex(arrX[j], rH/2, arrZ[j], (j+1)/sC, (j+1)/sC);
			  //}
			  //endVertex();
			 //
			  //draw the bottom of the cylinder
			  //beginVertex(TRIANGLE_MESH, sC+1); 
			  //addVertex(0,   rH/2,    0);
			  //for(var k:int = 0 ; k < l ; k++){
				//addVertex(arrX[k], rH/2, arrZ[k], (k+1)/sC, (k+1)/sC);
			  //}
			  //endVertex();
			//}
			
			
			
			
			
			//beginVertex(TRIANGLE_MESH, sC + 1 ) ;
			//
			//var _size:int = 40 ;
			//beginVertex( TRIANGLE_MESH, 2 + 1 ) ;
			//for ( var a:int = 0 ; a <= sC; a++ ) {
				//var ind:Number = a / sC ;
				//var _x:Number = Math.cos(FMath.radians(360 * (ind))) * rW ;
				//var _y:Number = Math.cos(FMath.radians(360 * (ind))) * rH ;
				//var _z:Number = 0 ;
				//
				//for (var i:int = 0 ; i <= 2; i++) {
					//for ( var j:int = 0; j <= 2; j ++ ) {
						//addVertex( _x, _y, 0) ;
					//}
				//}
			//}
			//
			//endVertex();
		}
	}

}