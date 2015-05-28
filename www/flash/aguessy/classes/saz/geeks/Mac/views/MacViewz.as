package saz.geeks.Mac.views 
{
	import f6.utils.Collection
	import flash.display.Stage;
	import flash.display.StageAlign;
	import saz.geeks.Mac.MacPlayerGraphics;
	
	/**
	 * ...
	 * @author saz
	 */
	public class MacViewz 
	{
		private var 	graphX			:MacPlayerGraphics;
		public var 		views			:Collection;
		
		public function MacViewz() 
		{
			
		}
		
		public function init(_graphX:MacPlayerGraphics):MacViewz
		{
			var stage:Stage = _graphX.macPlayer.target.stage
			stage.align = StageAlign.TOP
			stage.scaleMode = "noScale"
			//graphX 				= _graphX
			
			//views 				= new Collection()
			//var view1:MacView 	= new MacView().init(graphX,)
			//var view2:MacView 	= new MacView().init(graphX)
			//var view3:MacView 	= new MacView().init(graphX)
			
			//views.populate(view1, view2, view3)
			
			//
			return this
		}
		
	}
	
}