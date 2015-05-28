package sketchbook.imageprocessing
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	/** モザイク処理 */
	public class Mosaic implements IImageProcessing
	{
		public var xDotSize:uint
		public var yDotSize:uint
		public var smoothing:Boolean
		
		public function Mosaic(xDotSize:uint, yDotSize:uint, smoothing:Boolean=true):void
		{
			this.xDotSize = xDotSize
			this.yDotSize = yDotSize
			this.smoothing = smoothing
		}
		
		public function apply(bitmapData:BitmapData):BitmapData
		{
			var tempW:uint = Math.ceil(bitmapData.width / xDotSize)
			var tempH:uint = Math.ceil(bitmapData.height/ yDotSize)
			var tempBmd:BitmapData = new BitmapData(tempW,tempH,true,0x00000000);
			
			var mat:Matrix = new Matrix(1/xDotSize,0,0,1/yDotSize,0,0)
			tempBmd.draw(bitmapData, mat, null, null, null, smoothing);
			
			bitmapData.draw(tempBmd, new Matrix(xDotSize,0,0,yDotSize,0,0));
			
			return bitmapData
		}
	}
}