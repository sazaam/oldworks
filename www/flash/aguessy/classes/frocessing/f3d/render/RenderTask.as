package frocessing.f3d.render 
{
	import flash.display.Graphics;
	import flash.display.BitmapData;
	/**
	* ...
	* @author nutsu
	*/
	public class RenderTask 
	{
		public var kind:int;
		
		public var za:Number;
		public var path_start:int;
		public var command_start:int;
		public var command_num:int;
		
		public var stroke_index:uint;
		
		public var fill_do :Boolean;
		public var fillColor:uint;
		public var fillAlpha:Number;
		
		public var bitmapdata:BitmapData;
		public var u0:Number;
		public var v0:Number;
		public var u1:Number;
		public var v1:Number;
		public var u2:Number;
		public var v2:Number;
		
		public function RenderTask( kind_:int, path_start_index_:int, command_start_index_:int, za_:Number, cmd_num:int )
		{
			kind          = kind_;
			za            = za_;
			path_start    = path_start_index_;
			command_start = command_start_index_;
			command_num   = cmd_num;
			stroke_index  = 0;
			fill_do       = false;
		}
		
		public function setUV( u0_:Number, v0_:Number, u1_:Number, v1_:Number, u2_:Number, v2_:Number ):void
		{
			u0 = u0_;  v0 = v0_;
			u1 = u1_;  v1 = v1_;
			u2 = u2_;  v2 = v2_;
		}
		
		public function applyFill( g:Graphics ):void
		{
			g.beginFill( fillColor, fillAlpha );
		}
	}
	
}