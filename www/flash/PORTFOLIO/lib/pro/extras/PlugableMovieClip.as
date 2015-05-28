package pro.extras 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import gs.TweenLite;
	import of.app.required.loading.XAllLoader;
	
	/**
	 * ...
	 * @author saz
	 */
	public class PlugableMovieClip extends MovieClip implements IPlugable
	{
		public const EVALUATED_ALONE:Boolean = !Boolean(XAllLoader.hasInstance) ;
		public function PlugableMovieClip() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
			alpha = 0 ;
		}
		private function onStage(e:Event):void 
		{
			removeEventListener(e.type, arguments.callee) ;
			if(EVALUATED_ALONE) initialize() ;
		}
		public function initialize():void 
		{
			TweenLite.killTweensOf(this) ;
			TweenLite.to(this, .25, { alpha:1 } ) ;
		}
		public function terminate():void 
		{
			var t:MovieClip = this ;
			TweenLite.killTweensOf(this) ;
			TweenLite.to(this, .25, { alpha:0 , onComplete:function():void {
				parent.removeChild(t) ;
			}} ) ;
		}
	}

}