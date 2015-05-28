package testing 
{
	import asSist.$;
	import flash.display.Sprite;
	import flash.events.Event;
	import of.app.required.resize.StageResize;
	import tools.grafix.Draw;
	/**
	 * ...
	 * @author saz
	 */
	public class TestHome extends Sprite
	{
		private var __frameMinDims:Object = {
			width : 650,
			height : 550
		}
		private var __frameDims:Object = {
			width : 850,
			height : 550
		}
		private var __simpleNavDims:Object = {
			x:50,
			width : 350,
			height : 50
		}
		public function TestHome() 
		{
			initStage() ;
			createFrame() ;
			createSimpleNav() ;
			//createSpaceNav() ;
			
			stage.dispatchEvent(new Event(Event.RESIZE)) ;
		}
		
		private function createSpaceNav():void 
		{
			var spaceNav:Sprite = $(Sprite).attr({id:'spaceNav',name:'spaceNav'})[0] ;
			Draw.draw('rect', { g:spaceNav.graphics, color:0x000000, alpha:.92 }, 0, 0, stage.stageWidth, stage.stageHeight) ;
			addChild(spaceNav) ;
			StageResize.instance.handle(spaceNav) ;
			spaceNav.addEventListener(Event.RESIZE, onSpaceNavResize) ;
		}
		
		private function createSimpleNav():void 
		{
			var simpleNav:Sprite = $(Sprite).attr({id:'simpleNav',name:'simpleNav'})[0] ;
			Draw.draw('rect', { g:simpleNav.graphics, color:0xFFFFFF, alpha:.15 }, 0, 0, __simpleNavDims.width, __simpleNavDims.width) ;
			addChild(simpleNav) ;
			StageResize.instance.handle(simpleNav) ;
			simpleNav.addEventListener(Event.RESIZE, onSimpleNavResize) ;
		}
		
		
		
		private function createFrame():void 
		{
			var frame:Sprite = $(Sprite).attr({id:'frame',name:'frame'})[0] ;
			Draw.draw('rect', { g:frame.graphics, color:0xFFFFFF, alpha:.15 }, 0, 0, __frameDims.width, __frameDims.height) ;
			addChild(frame) ;
			var minFrame:Sprite = $(Sprite).attr({id:'minFrame',name:'minFrame'})[0] ;
			Draw.draw('rect', { g:minFrame.graphics, color:0xFFFFFF, alpha:.15 }, 0, 0, __frameMinDims.width, __frameMinDims.height) ;
			frame.addChild(minFrame) ;
			minFrame.x = (__frameDims.width - __frameMinDims.width) >> 1 ;
			frame.addEventListener(Event.RESIZE, onFrameResize) ;
			StageResize.instance.handle(frame) ;
		}
		
		private function onSpaceNavResize(e:Event):void 
		{
			var spaceNav:Sprite = Sprite(e.target) ;
			Draw.draw('rect', { g:spaceNav.graphics, color:0x000000, alpha:.92 }, 0, 0, stage.stageWidth, stage.stageHeight) ;
		}
		
		private function onSimpleNavResize(e:Event):void 
		{
			var simpleNav:Sprite = Sprite(e.target) ;
			simpleNav.x = __simpleNavDims.x ;
			simpleNav.y = stage.stageHeight - __simpleNavDims.height ;
		}
		
		private function onFrameResize(e:Event):void 
		{
			var frame:Sprite = Sprite(e.target) ;
			frame.x = (stage.stageWidth - __frameDims.width) >> 1 ;
		}
		
		private function initStage():void 
		{
			stage.align = 'TL' ;
			StageResize.init(stage) ;
		}
	}
}