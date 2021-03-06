﻿package pro.graphics 
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import frocessing.display.F5MovieClip2D;
	import gs.TweenLite;
	import naja.tools.commands.Command;
	import naja.tools.commands.CommandQueue;
	import naja.tools.commands.Wait;
	import naja.model.control.context.Context;
	import naja.model.control.resize.StageProxy;
	import naja.model.data.loadings.loaders.I.ILoaderGraphics;
	import naja.model.data.loadings.AllLoader;
	import naja.model.data.loadings.E.LoadEvent;
	import naja.model.data.loadings.E.LoadProgressEvent;
	import naja.model.Root;
	import naja.model.XUser;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class SquareGraphics implements ILoaderGraphics
	{
		private var user:XUser;
		
		private var stageDims:Point;
		private var target:Sprite ;
		private var size:Number ;
		private var square:Sprite;
		private var progressZone:Sprite ;
		private var midWidth:Number;
		private var midHeight:Number;
		
		public function SquareGraphics() 
		{
			target =  Sprite(Root.root.addChild(new Sprite)) ;
			user = Root.user ;
		}
		
		public function start(closure:Function, ...args:Array):void
		{
			stageDims = StageProxy.init(Root.root.stage) ;
			trace("Loadingz Started !!!") ;
			
			midWidth = int(stageDims.x >> 1) ;
			midHeight = int(stageDims.y >> 1) ;
			size = 10 ;
			square = new Sprite() ;
			progressZone = new Sprite() ;
			
			//square.x = midWidth - (size/2) ;
			//square.y = midHeight - (size/2) ;
			
			square.graphics.beginFill(0xF2F2F2) ;
			square.graphics.drawRect(0, 0, target.stage.stageWidth, size) ;
			square.graphics.endFill() ;
			
			square.addChild(progressZone ) ;
			target.addChild(square) ;
			twStart.apply(this, [closure].concat(args)) ;
		}
		private function drawProgress(percent:Number):void
		{
			var pct:Number = percent * size ;
			progressZone.graphics.clear() ;
			progressZone.graphics.beginFill(0xFF0000) ;
			//progressZone.graphics.lineStyle(3, 0xFF6600,1, true,'none',CapsStyle.SQUARE,JointStyle.MITER,5 ) ;
			progressZone.graphics.drawRect(0, 0, pct*target.stage.stageWidth, size) ;
			progressZone.graphics.endFill() ;
		}
		private function twReset():void
		{
			progressZone.graphics.clear() ;
		}
		
		private function twStart(closure:Function, ...args:Array):void
		{
			TweenLite.to(progressZone, .5, { alpha:1, onComplete:function():void {
				closure.apply(closure, [].concat(args)) ;
			}}) ;
		}
		
		private function twKill(closure:Function, ...args:Array):void
		{
			TweenLite.to(progressZone, .5, { onComplete:function():void {
				closure.apply(closure, [].concat(args)) ;
			}} ) ;
		}		
		
		public function kill(closure:Function, ...args:Array):void {
			trace("Loadingz Ended !!!") ;
			var f:Function = function():void {
				TweenLite.to(square, .5, { alpha:0, onComplete:function():void {
					closure.apply(closure, [].concat(args)) ;
				}} ) ;
			}
			twKill(f) ;
		}

		/////////////////////////////////////////////////// ALL
		public function onALLOpen(e:Event):void {
			
		}
		public function onALLProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onALLLoadProgress(e:LoadProgressEvent):void {
			//trace("ALL Progress", " >> ", e.bytesLoaded, e.bytesTotal, e.bytesLoaded / e.bytesTotal )
		}
		public function onALLLoadOpen(e:LoadEvent):void {
			//trace("ALL Open", " >> ", e.index )
		}
		public function onALLLoadComplete(e:LoadEvent):void {
			//trace("ALL Complete", " >>", e.index)
		}
		public function onALLComplete(e:Event):void {
			//twKill() ;
		}
		/////////////////////////////////////////////////// ZIP
		public function onZIPOpen(e:Event):void {
			twReset() ;
			//twStart() ;
		}
		public function onZIPProgress(e:ProgressEvent):void {
			
		}
		public function onZIPLoadProgress(e:LoadProgressEvent):void {
			//var percent:Number = e.bytesLoaded / e.bytesTotal ;
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onZIPComplete(e:Event):void {
			//twKill() ;
		}
		/////////////////////////////////////////////////// IMG
		public function onIMGOpen(e:Event):void {
			twReset() ;
			//twStart() ;
		}
		public function onIMGProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onIMGLoadProgress(e:LoadProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
		}
		public function onIMGComplete(e:Event):void {
			//twKill() ;
		}
		/////////////////////////////////////////////////// FONTS
		public function onFONTSOpen(e:Event):void {
			//twReset() ;
			//twStart() ;
		}
		public function onFONTSProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onFONTSComplete(e:Event):void {
			//twKill() ;
		}
		/////////////////////////////////////////////////// SWF
		public function onSWFOpen(e:Event):void {
			//twReset() ;
			//twStart() ;
		}
		public function onSWFProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onSWFComplete(e:Event):void {
			//twKill() ;
		}
		/////////////////////////////////////////////////// XML
		public function onXMLOpen(e:Event):void {
			//twReset() ;
			//twStart() ;
		}
		public function onXMLProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onXMLComplete(e:Event):void {
			//twKill() ;
		}
	}
} 