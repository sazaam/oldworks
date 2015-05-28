package pro.extras 
{
	import flash.events.Event;
	import frocessing.display.F5MovieClip3D;
	import gs.TweenLite;
	import of.app.required.loading.XAllLoader;
	/**
	 * ...
	 * @author saz
	 */
	public class PlugableFro3D  extends F5MovieClip3D implements IPlugable
	{
		public const EVALUATED_ALONE:Boolean = !Boolean(XAllLoader.hasInstance) ;
		public function PlugableFro3D() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
			alpha = 0 ;
		}
		private function onStage(e:Event):void 
		{
			removeEventListener(e.type, arguments.callee) ;
			if(EVALUATED_ALONE) initialize() ;
		}
		public function initialize(...rest:Array):void 
		{
			TweenLite.killTweensOf(this) ;
			TweenLite.to(this, .25, { alpha:1 } ) ;
		}
		public function terminate(...rest:Array):void 
		{
			var t:F5MovieClip3D = this ;
			TweenLite.killTweensOf(t) ;
			TweenLite.to(t, .25, { alpha:0 , onComplete:function():void {
				if(t.parent) t.parent.removeChild(t) ;
			}} ) ;
		}
	}

}