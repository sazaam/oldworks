package frocessing.f3d.render 
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	/**
	* ...
	* @author nutsu
	*/
	public class RenderBitmapTask extends RenderTask
	{
		
		public var bitmap:BitmapData;
		public var matrix:Matrix;
		public var repeat:Boolean;
		public var smooth:Boolean;
		
		public function RenderBitmapTask( kind_:int, path_start_index_:int, command_start_index_:int, za_:Number, cmd_num:int )
		{
			super( kind_, path_start_index_, command_start_index_, za_, cmd_num );
		}
		
		public function setParameters( bitmap_:BitmapData, matrix_:Matrix, repeat_:Boolean, smooth_:Boolean ):void
		{
			bitmap = bitmap_;
			matrix = matrix_;
			repeat = repeat_;
			smooth = smooth_;
		}
		
		override public function applyFill(g:Graphics):void 
		{
			g.beginBitmapFill( bitmap, matrix, repeat, smooth );
		}
	}
	
}