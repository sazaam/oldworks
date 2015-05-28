package pro.extras 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import gs.TweenLite;
	import of.app.required.loading.XAllLoader ;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Plugable extends Sprite implements IPlugable
	{
		public const EVALUATED_ALONE:Boolean = !Boolean(XAllLoader.hasInstance) ;
		public function Plugable() 
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
			var t:Sprite = this ;
			TweenLite.killTweensOf(t) ;
			TweenLite.to(t, .25, { alpha:0 , onComplete:function():void {
				if(t.parent) t.parent.removeChild(t) ;
			}} ) ;
		}
	}

}