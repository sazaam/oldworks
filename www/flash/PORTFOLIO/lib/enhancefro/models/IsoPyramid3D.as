package enhancefro.models 
{
	import begin.type.array.Variables;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import frocessing.core.canvas.ICanvas3D;
	import frocessing.f3d.F3DObject;
	import frocessing.math.FMath;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class IsoPyramid3D extends F3DObject 
	{
		public var front:IsoTriangle3D;
		public var bottom:IsoTriangle3D;
		public var left:IsoTriangle3D;
		public var right:IsoTriangle3D;
		
		public var visible:Boolean = true;
		
		public function IsoPyramid3D(size:Number = 50, segment:int = 2) 
		{
			super();
			backFaceCulling = false;
			
			initModel( size , segment);
		}
		
		/** @private */
		private function initModel( size:Number, seg:int):void
		{
			var numSize:int = 3 ;
			
			var deg:Number = 180 / numSize / Math.PI ;
			var percent:Number = deg / 90 ;
			var angleRoll:Number = deg /180 * Math.PI ;
			var newSize:Number = size - (size * percent) ;
			var midSize:Number = newSize * .5 ;
			var ht:Number = int(Math.sqrt((newSize * newSize) - (midSize * midSize))) ;
			var g:Number = 2 / 3 ;
			var remain:Number = 1 / 3 ;
			var rayonInnerDisk:Number = (size * g)/2 ;
			var rayonBase:Number = (size / 4 ) - 2 ;
			var baseAngle:Number = 90 ;
			var unitAngle:Number = 360 / 3 ;
			
			var frontZ:Number = rayonBase * (1-percent) ;
			var rightX:Number = Math.cos(FMath.radians(baseAngle + (unitAngle))) * rayonBase * (1-percent);
			var rightZ:Number = Math.sin(FMath.radians(baseAngle + (unitAngle))) * rayonBase * (1-percent);
			var leftX:Number = Math.cos(FMath.radians(baseAngle + (360 - unitAngle))) * rayonBase * (1-percent);
			var leftZ:Number = Math.sin(FMath.radians(baseAngle + (360 - unitAngle))) * rayonBase * (1-percent);
			
			front = new IsoTriangle3D( size, seg );
			bottom = new IsoTriangle3D( size, seg );
			left = new IsoTriangle3D( size, seg );
			right = new IsoTriangle3D( size, seg );
			front.backFaceCulling = true;
			bottom.backFaceCulling = true;
			left.backFaceCulling = true;
			right.backFaceCulling = true;
			
			front.pitch(FMath.radians(180)) ;
			front.roll(-angleRoll) ;
			front.translate( 0, 0, frontZ);
			
			// yaw  = Z rotate
			// roll  = X rotate
			// pitch  = Y rotate
			
			left.pitch(FMath.radians(60)) ;
			left.roll(-angleRoll) ;
			left.translate( -leftX, 0, leftZ ) ;
 			right.pitch(FMath.radians(-60)) ;
			right.roll(-angleRoll) ;
			right.translate( -rightX, 0, rightZ ) ;
			bottom.roll( Math.PI / 2 ) ;
			bottom.translate( 0, (rayonInnerDisk * (1-percent)), 0) ;
		}
		
		
		//--------------------------------------------------------------------------------------------------- MATERIAL
		/**
		 * 
		 */
		public function setColors( front:uint, right:uint, left:uint, bottom:uint , alpha:Number = 1):void
		{
			this.front.setColor( front , alpha) ;
			this.bottom.setColor( bottom , alpha) ;
			this.left.setColor( left , alpha) ;
			this.right.setColor( right , alpha) ;
		}
		
		public function setColor(color:uint, alpha:Number = 1):void
		{
			setColors(color, color, color, color, alpha) ;
		}
		/**
		 * 
		 */
		public function setTextures( front:BitmapData, right:BitmapData, left:BitmapData, bottom:BitmapData = null):void
		{
			this.front.setTexture( invertXTexture(front)) ;
			this.left.setTexture(invertXTexture(left)) ;
			this.right.setTexture(invertXTexture(right)) ;
			if (!Boolean(bottom as BitmapData)) {
				this.bottom.setColor(0x0) ;
			}else {
				this.bottom.setTexture( invertXTexture(bottom)) ;
			}
		}
		
		private function invertXTexture(tex:BitmapData):BitmapData
		{
			var temp:BitmapData = new BitmapData(tex.width, tex.height, true, 0x0) ;
			temp.draw(tex, new Matrix( -1, 0, 0, 1, tex.width, 0), null, null, null, true) ;
			return temp ;
		}
		
		public function setTexture( front:BitmapData, bottom:BitmapData = null):void
		{
			setTextures(front, front, front, bottom) ;
		}
		/**
		 * enable material and backCulling.
		 */
		public function enableStyle():void {
			front.enableStyle();
			bottom.enableStyle();
			left.enableStyle();
			right.enableStyle();
		}
		
		/**
		 * disable material and backCulling.
		 */
		public function disableStyle():void {
			front.disableStyle();
			bottom.disableStyle();
			left.disableStyle();
			right.disableStyle();
		}
		
		//---------------------------------------------------------------------------------------------------
		/** @inheritDoc */
		override public function draw( g:ICanvas3D ):void
		{
			if ( visible ) {
				front.draw(g);
				bottom.draw(g);
				left.draw(g);
				right.draw(g);
			}
		}
		
		/** @inheritDoc */
		override public function updateTransform( m11_:Number, m12_:Number, m13_:Number,
												  m21_:Number, m22_:Number, m23_:Number,
												  m31_:Number, m32_:Number, m33_:Number,
												  m41_:Number, m42_:Number, m43_:Number ):void
		{
			super.updateTransform( m11_, m12_, m13_, m21_, m22_, m23_, m31_, m32_, m33_, m41_, m42_, m43_ );
			front.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
			bottom.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
			left.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
			right.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
		}
	}
}