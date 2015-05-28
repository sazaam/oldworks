package frocessing.f3d.render 
{
	import flash.display.Graphics;
	/**
	* ...
	* @author nutsu
	*/
	public class StrokeTask implements IStrokeTask
	{
		public var strokeColor:uint;
		public var strokeAlpha:Number;
		public var thickness:Number;
		public var pixelHinting:Boolean;
		public var scaleMode:String;
		public var caps:String;
		public var joints:String;
		public var miterLimit:Number;
		
		public function StrokeTask( thickness_:Number, color_:uint, alpha_:Number, pixelHinting_:Boolean, scaleMode_:String, caps_:String, joints_:String, miterLimit_:Number )
		{
			thickness    = thickness_;
			strokeColor  = color_;
			strokeAlpha  = alpha_;
			pixelHinting = pixelHinting_;
			scaleMode    = scaleMode_;
			caps         = caps_;
			joints       = joints_;
			miterLimit   = miterLimit_;
		}
		
		public function setLineStyle( g:Graphics ):void
		{
			g.lineStyle( thickness, strokeColor, strokeAlpha, pixelHinting, scaleMode, caps, joints, miterLimit );
		}
	}
	
}