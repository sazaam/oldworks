package saz.defaults.loaders 
{
	import asSist.$;
	import saz.helpers.loadlists.loaders.I.ILoaderGraphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import saz.helpers.math.Percent;
	import saz.geeks.loaders.BasicMultiLoader3D;BasicMultiLoader3D;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class DefaultLoaderGraphics implements ILoaderGraphics
	{
		
		public function DefaultLoaderGraphics(_tg:Sprite) 
		{
			target = _tg ;
		}
		private var target:Sprite;
		private var loadingTxtXML:XML = 
			<flash.display.Sprite>
				<saz.geeks.loaders.BasicMultiLoader3D text="loading..." color="0xFFFFFF" />
			</flash.display.Sprite>;
//////////////////////////////////////////////////////////////////////////GRAFIX
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
			var sprLoading:Sprite = target.stage.addChild(new Sprite()) as Sprite ;
			var indicator:Shape = sprLoading.addChild(new Shape()) as Shape ;
			$(sprLoading).attr( { id:"loading" } ) ;
			$(indicator).attr( { id:"indic",y:target.stage.stageHeight >> 1 } ) ;
			$(loadingTxtXML).attr( { id:"loadTXT", y:target.stage.stageHeight >> 1 } ).appendTo(target.stage).attr( { x:(target.stage.stageWidth >> 1) - (150 >> 1), y:indicator.y - 45 } ) ;
		}
		public function kill():void 
		{
			$("#loadTXT").remove() ;
			$("#indic").remove() ;
			$("#loading").remove() ;
		}
		public function indicatePercent(_n:Number):void
		{
			var sprLoading:Sprite = $("#loading")[0] ;
			var indicator:Shape = $("#indic")[0] ;
			indicator.graphics.clear() ;
			indicator.graphics.beginFill(0xFFFFFF, .9) ;
			indicator.graphics.drawRect((target.stage.stageWidth >> 1) - (150 >> 1), 0,_n ,2) ;
			indicator.graphics.endFill() ;
		}
/////////////////////////////////////////////////////////////////////////////STEPS
////////////////////////////////////////////////////////////////////////////////////////////////////IMG
		public function loadIMG():void
		{
			enableLoader() ;
			$("BasicMultiLoader3D").attr({text:"loading Images..."})
		}
		public function onIMGComplete(e:Event):void 
		{
			enableLoader(false) ;
		}
		public function onIMGProgress(e:ProgressEvent):void 
		{
			var percent:Number = Percent.percent(e.bytesLoaded, e.bytesTotal, {start:(target.stage.stageWidth >> 1) - (150 >> 1), end:(target.stage.stageWidth >> 1) + (150 >> 1) } ) ;
			indicatePercent(percent) ;
		}

////////////////////////////////////////////////////////////////////////////////////////////////////FONTS
		public function loadFonts():void
		{
			enableLoader() ;
			$("BasicMultiLoader3D").attr({text:"loading Fonts..."})
		}
		public function onFontsComplete(e:Event):void 
		{
			enableLoader(false) ;
		}
		public function onFontsProgress(e:ProgressEvent):void 
		{
			var percent:Number = Percent.percent(e.bytesLoaded, e.bytesTotal, {start:(target.stage.stageWidth >> 1) - (150 >> 1), end:(target.stage.stageWidth >> 1) + (150 >> 1) } ) ;
			indicatePercent(percent) ;
		}
////////////////////////////////////////////////////////////////////////////////////////////////////SWF
		public function loadSWF():void
		{
			enableLoader() ;
			$("BasicMultiLoader3D").attr( { text:"loading SWF..." } ) ;
		}
		public function onSWFComplete(e:Event):void 
		{
			enableLoader(false) ;
		}
		public function onSWFProgress(e:ProgressEvent):void 
		{
			var percent:Number = Percent.percent(e.bytesLoaded, e.bytesTotal, {start:(target.stage.stageWidth >> 1) - (150 >> 1), end:(target.stage.stageWidth >> 1) + (150 >> 1) } ) ;
			indicatePercent(percent) ;
		}
////////////////////////////////////////////////////////////////////////////////////////////////////XML
		public function loadXML():void
		{
			enableLoader() ;
			$("BasicMultiLoader3D").attr({text:"loading XML..."})
		}
		public function onXMLComplete(e:Event):void 
		{
			enableLoader(false) ;
		}
		public function onXMLProgress(e:ProgressEvent):void 
		{
			var percent:Number = Percent.percent(e.bytesLoaded, e.bytesTotal,{ start:(target.stage.stageWidth >> 1) - (150 >> 1), end:(target.stage.stageWidth >> 1) + (150 >> 1) }  ) ;
			indicatePercent(percent) ;
		}
	}	
}