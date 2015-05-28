package of.app.required.loading 
{
	import flash.display.Loader;
	import of.app.required.loading.I.ILoaderGraphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import of.app.Root;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class DefaultLoaderGraphics implements ILoaderGraphics
	{
		public function DefaultLoaderGraphics(_tg:Sprite = null) 
		{
			target = _tg || Root.root ;
		}
		private var target:Sprite;
		private var loadingTxtXML:XML = 
			<flash.display.Sprite>
				<flash.display.Loader />
			</flash.display.Sprite>;
//////////////////////////////////////////////////////////////////////////GRAFIX
		public function enableLoader(cond:Boolean = true ):void
		{
			if (cond) {
				//start() ;
			}else {
				//kill() ;
			}
		}
		public function start(closure:Function, ...args:Array):void 
		{
			closure.apply(closure, [].concat(args)) ;
		}
		public function kill(closure:Function, ...args:Array):void 
		{
			closure.apply(closure, [].concat(args)) ;
		}
		public function indicatePercent(_n:Number):void
		{
			
			
		}
/////////////////////////////////////////////////////////////////////////////STEPS

////////////////////////////////////////////////////////////////////////////////////////////////////ALL
		public function onALLOpen(e:Event):void
		{
			
		}
		public function onALLComplete(e:Event):void 
		{
			
		}
		public function onALLProgress(e:ProgressEvent):void 
		{
			
		}

////////////////////////////////////////////////////////////////////////////////////////////////////IMG
		public function onIMGOpen(e:Event):void
		{
			
		}
		public function onIMGComplete(e:Event):void 
		{
			
		}
		public function onIMGProgress(e:ProgressEvent):void 
		{
			
		}

////////////////////////////////////////////////////////////////////////////////////////////////////FONTS
		public function onFONTSOpen(e:Event):void
		{
			
		}
		public function onFONTSComplete(e:Event):void 
		{
			
		}
		public function onFONTSProgress(e:ProgressEvent):void 
		{
			
		}
////////////////////////////////////////////////////////////////////////////////////////////////////SWF
		public function onSWFOpen(e:Event):void
		{
			
		}
		public function onSWFComplete(e:Event):void 
		{
			
		}
		public function onSWFProgress(e:ProgressEvent):void 
		{
			
		}
////////////////////////////////////////////////////////////////////////////////////////////////////XML
		public function onXMLOpen(e:Event):void
		{
			
		}
		public function onXMLComplete(e:Event):void 
		{
			
		}
		public function onXMLProgress(e:ProgressEvent):void 
		{
			
		}
	}	
}