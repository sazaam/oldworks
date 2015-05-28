package testing 
{
	import asSist.$;
	import flash.display.Sprite;
	import of.app.required.resize.StageResize;
	/**
	 * ...
	 * @author saz
	 */
	public class SazViewPort 
	{
		private var __root:Sprite;
		
		public function SazViewPort() 
		{
			
		}
		
		public function init(root:Sprite, scheme:XML):SazViewPort
		{
			__root = root ;
			StageResize.init(__root.stage) ;
			$(scheme).appendTo(__root) ;
			
			return this ;
		}
	}
}