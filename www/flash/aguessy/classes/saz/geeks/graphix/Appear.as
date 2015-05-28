package saz.geeks.graphix 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class Appear
	{
		private var target:DisplayObject;
		private var _id1:Number;
		private var maskk:MovieClip;
		private var removed:Boolean = true ;
		private var completeCB:Function = null;
		static private var _util:MovieClip;
		
		
		
		public function Appear(_tg:DisplayObject,_time:Number = 1 ,_callback:Function = null,...args:Array) 
		{
			_tg.alpha = 0 ;
			var callback:Function = null;
			var callbackArgs:Array = [];
			target = _tg;
			maskk = target.parent.addChildAt(Appear.util, target.parent.getChildIndex(target) + 1) as MovieClip ;
			maskk.gotoAndStop(0);
			
			maskk.cacheAsBitmap = target.cacheAsBitmap = true ;
			target.mask = maskk ;
			removed = false ;
			with(maskk)
			{
				x = target.x ;
				y = target.y ;
				width = target.width+20 ;
				height = target.height+20 ;
			}
			if (_callback != null) {
				callback = _callback ;
				callbackArgs = args ;
			}
			
			TweenLite.to(maskk,_time,{ frame:maskk.totalFrames ,onStart:function(){_tg.alpha = 1 ;},onComplete:function(){remove(_callback,callbackArgs)}});
		}
		
		public function remove(_callback:Function = null,...args:Array):void
		{
			if (removed == false) {
				maskk.parent.removeChild(maskk) ;
				target.mask = null ;
				if (_callback != null) _callback(args) ;
				if (completeCB != null) completeCB();
				removed = true ;
				//delete this ;
			}
		}
		
		public function onComplete(_CB:Function):Appear {
			completeCB = _CB ;
			return this;
		}
		public function getMask():MovieClip
		{
			return maskk;
		}
		
		static public function get util():MovieClip { return _util; }
		
		static public function set util(value:MovieClip):void 
		{
			_util = value;
		}
		
	}
}