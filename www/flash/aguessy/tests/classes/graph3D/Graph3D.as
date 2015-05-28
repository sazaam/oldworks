package graph3D 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import frocessing.core.F5Graphics3D;
	import frocessing.display.F5MovieClip3D;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Graph3D 
	{
		private var __displayer:Graph3DView;
		private var __fg:F5Graphics3D;
		
		public function Graph3D() 
		{
			__displayer = new Graph3DView() ;
		}
		
		public function init(_mc:DisplayObject):void
		{
			__fg ;
			__displayer.__target = _mc ;
			if (_mc is F5MovieClip3D) {
				var _fm:F5MovieClip3D = F5MovieClip3D(_mc) ;
				__fg = _fm.fg ;
			}
			else if (_mc is Sprite) {
				var _do:Sprite = Sprite(_mc) ;
				__fg = new F5Graphics3D(_do.graphics,_do.width,_do.height) ;
			}
			else {
				
			}
			__displayer.init3D(__fg) ;
		}
		
		public function play():void
		{
			__displayer.render(true) ;
		}
		
		public function evaluate(xml:XML):void {
			for each(var item:XML in xml.*) {
				var i:int = item.childIndex() ;
				var l:int = item.*.length() ;
				__displayer.variate(i, l, item) ;
				
				//trace(item);
				trace("______________");
			}
		}
	}
	
}