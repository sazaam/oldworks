package frocessing.f3d.render 
{
	import flash.display.Graphics;
	/**
	* ...
	* @author nutsu
	*/
	public class NoStrokeTask implements IStrokeTask
	{
		
		public function NoStrokeTask()
		{
			;
		}
		
		public function setLineStyle( g:Graphics ):void
		{
			g.lineStyle();
		}
		
	}
	
}