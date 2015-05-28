package sketchbook.display
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	
	/**
	 * DisplayObjectを元に初期描画を作るBitmapDataの拡張クラス。 
	 * 
	 * <p>現状は左上が原点の物に限られる</p>
	 * 
	 * ■実験用オブジェクトです
	 */
	public class CapturedBitmapData extends BitmapData
	{
		public function CapturedBitmapData(displayObject:DisplayObject, scale:Number=1, transparent:Boolean=false, fillColor:uint=0xffffff)
		{
			super(displayObject.width*scale, displayObject.height*scale, transparent, fillColor);
			this.draw(displayObject, new Matrix(scale,0,0,scale,0,0));
		}
	}
}