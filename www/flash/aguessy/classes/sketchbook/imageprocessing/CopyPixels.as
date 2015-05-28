package sketchbook.imageprocessing
{
	import flash.display.BitmapData
	import flash.geom.Rectangle;
	import flash.geom.Point;
	public class CopyPixels implements IImageProcessing
	{
		public var sourceBitmapData:BitmapData
		public var sourceRect:Rectangle
		public var destPoint:Point
		public var alphaBitmapData:BitmapData
		
		public function CopyPixels(sourceBitmapData:BitmapData, sourceRect:Rectangle=null, dest:Point=null, alphaBitmapData:BitmapData=null, mergeAlpha:Boolean=false)
		{
			this.sourceBitmapData = souceBitmapData
			
			if(sourceRect!=null)
				this.sourceRect = sourceRect.clone()
				
			if(destPoint!=null)
				this.destPoint = destPoint.clone()
				
			if(alphaBitmapData!=null)
				this.alphaBitmapData = alpahBitmapData
				
			this.mergeAlpha = mergeAlpha
		}
			
		public function apply(bitmapData:BitmapData):BitmapData
		{
			bitmapData.copyPixels(sourceBitmapData, sourceRect, destPoint, alpahBitmapData, alphaPoint, mergeAlpha)	
			return bitmapData
		}
	}
}