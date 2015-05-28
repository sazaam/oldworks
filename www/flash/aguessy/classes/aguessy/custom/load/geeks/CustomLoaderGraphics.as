package aguessy.custom.load.geeks
{

	import aguessy.custom.load.geeks.InitLoader3D; InitLoader3D;
	import aguessy.custom.load.geeks.Spinners; Spinners;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import gs.easing.Expo;
	import gs.TweenLite;
	import naja.model.control.context.Context;
	import naja.model.data.loaders.I.ILoaderGraphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import saz.helpers.math.Percent;
	
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class CustomLoaderGraphics implements ILoaderGraphics
	{
		
		public function CustomLoaderGraphics(_tg:Sprite) 
		{
			target = _tg ;
		}
		
		private var target:Sprite ;
		private var loadingTxtXML:XML = <aguessy.custom.load.geeks.InitLoader3D text="" color="0x777777" /> ;
		private var spinnersXML:XML = <aguessy.custom.load.geeks.Spinners /> ;
		private var forReal:Boolean;
		private var backMotif:Bitmap;
/////////////////////////////////////////////////////////////////////////////ENABLE / DISABLE
		public function enableLoader(cond:Boolean = true ):void
		{
			if (cond) {
				start() ;
			}else {
				kill() ;
			}
		}
		public function start():void 
		{
			Context.$get(loadingTxtXML).attr( { name:"loadTXT", id:"loadTXT" } ).appendTo(target.stage) ;
			Context.$get(spinnersXML).attr( { name:"spinners", id:"spinners"} ).appendTo(target.stage)[0].spin("first") ;
		}
		public function kill():void 
		{
			Context.$get("#loadTXT").remove() ;
			var spin:Spinners = Context.$get("#spinners")[0] ;
			if (forReal == true) {
				TweenLite.to(spin, .5, { alpha:0, y:100 ,ease:Expo.easeIn, onComplete:function() { spin.stopSpin() ; Context.$get(spin).remove() ; }} ) ;
			}else {
				Context.$get(spin).remove()[0].stopSpin() ;
			}
		}
/////////////////////////////////////////////////////////////////////////////UTILS
		public function indicatePercent(_n:Number):void
		{
			var tf:InitLoader3D = Context.$get("InitLoader3D")[0] ;
			tf.text = String(Math.floor(_n)) ;
		}
/////////////////////////////////////////////////////////////////////////////LOADS
////////////////////////////////////////////////////////////////////////////////////////////////////XML
		public function loadXML():void
		{
			enableLoader() ;
		}
		public function onXMLComplete(e:Event):void 
		{
			//
		}
		public function onXMLProgress(e:ProgressEvent):void 
		{
			var percent:Number = Percent.percent(e.bytesLoaded, e.bytesTotal ) ;
			indicatePercent(percent) ;
		}
////////////////////////////////////////////////////////////////////////////////////////////////////FONTS
		public function loadFonts():void
		{
			Context.$get('#spinners')[0].spin("first") ;
		}
		public function onFontsComplete(e:Event):void 
		{
			//
		}
		public function onFontsProgress(e:ProgressEvent):void 
		{
			var percent:Number = Percent.percent(e.bytesLoaded, e.bytesTotal ) ;
			trace(percent)
			indicatePercent(percent) ;
		}
////////////////////////////////////////////////////////////////////////////////////////////////////SWF
		public function loadSWF():void
		{
			Context.$get('#spinners')[0].spin("second") ;
		}
		public function onSWFComplete(e:Event):void 
		{
			//
		}
		public function onSWFProgress(e:ProgressEvent):void 
		{
			var percent:Number = Percent.percent(e.bytesLoaded, e.bytesTotal ) ;
			trace(percent)
			indicatePercent(percent) ;
		}
////////////////////////////////////////////////////////////////////////////////////////////////////IMG
		public function loadIMG():void 
		{
			Context.$get('#spinners')[0].spin("third") ;
		}
		public function onIMGComplete(e:Event):void 
		{
			forReal = true ;
			enableLoader(false) ;
		}
		public function onIMGProgress(e:ProgressEvent):void 
		{
			var percent:Number = Percent.percent(e.bytesLoaded, e.bytesTotal ) ;
			indicatePercent(percent) ;
		}
	}
}