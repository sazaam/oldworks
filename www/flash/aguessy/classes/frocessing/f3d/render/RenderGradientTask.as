package frocessing.f3d.render 
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	/**
	* ...
	* @author nutsu
	*/
	public class RenderGradientTask extends RenderTask
	{
		public var type:String;
		public var colors:Array;
		public var alphas:Array;
		public var ratios:Array
		public var matrix:Matrix;
		public var spreadMethod:String;
		public var interpolationMethod:String;
		public var focalPointRation:Number;
		
		public function RenderGradientTask( kind_:int, path_start_index_:int, command_start_index_:int, za_:Number, cmd_num:int )
		{
			super( kind_, path_start_index_, command_start_index_, za_, cmd_num );
		}
		
		public function setParameters( type_:String, colors_:Array, alphas_:Array, ratios_:Array, matrix_:Matrix, spreadMethod_:String, interpolationMethod_:String, focalPointRation_:Number ):void
		{
			type                = type_;
			colors              = colors_;
			alphas              = alphas_;
			ratios              = ratios_;
			matrix              = matrix_;
			spreadMethod        = spreadMethod_;
			interpolationMethod = interpolationMethod_;
			focalPointRation    = focalPointRation_;
		}
		
		override public function applyFill(g:Graphics):void 
		{
			g.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRation);
		}
		
	}
	
}