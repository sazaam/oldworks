package saz.geeks.Mac.parts 
{
	import f6.helpers.essentials.collections.SpriteCollection;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import saz.geeks.graphix.deco.CrazyBitmap;
	import saz.geeks.Mac.MacPlayer;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Part extends SpriteCollection
	{
		public var target:Sprite;
		public var background:Sprite;
		private var stageRect:Rectangle;
		private var ratio:Number;
		private var stageDims:Rectangle;
		private var sectionManager:SectionManager
		
		
		
		public function Part(_props:Object = null) 
		{
			trace("PART LOADED...")
			super(_props)
		}
		
		public function init():void
		{
			setBackground(properties.background)
		}
		
		private function launchPart():void
		{
			trace("PART :" + properties.name)
			switch(properties.name)
			{
				case 'StudioSection' :
					sectionManager = new MacStudio() as SectionManager
					sectionManager.init(this)
				break;
				case 'ParamsSection' :
					sectionManager = new MacParams() as SectionManager
					sectionManager.init(this)
				break;
				case 'VideoSection' :
					sectionManager = new MacVideo() as SectionManager
					sectionManager.init(this)
				break;
				case 'MusicSection' :
					sectionManager = new MacMusic() as SectionManager
					sectionManager.init(this)
				break;
			}
		}
		
		private function detectStageDimensions():Rectangle
		{
			stageRect = new Rectangle(0, 0, target.stage.stageWidth, target.stage.stageHeight)
			return stageRect
		}
		
		public function onPartResize(e:Event = null):void
		{
			stageDims = detectStageDimensions()
			childrenToArray(target).forEach(resize)
		}
		
		private function resize(el:DisplayObject,i:int,arr:Array):void
		{
			var w:Number, h:Number, X:Number, Y:Number;
			
			//trace(el.name)
			switch(el.name)
			{
				case 'CONTENT':
					X = (stageDims.width - el.width) >> 1 
					Y = (stageDims.height - el.height) >> 1 
				break;
				case 'BACKGROUND':
					var p:Point = preserveRatio(el)
					w = p.x
					h = p.y
				break;
			}
			//trace(el.x)
			with (el) {
				if(X) x = X
				if(Y) y = Y
				if(w) width = w
				if(h) height = h
			}
		}
		
		private function preserveRatio(el:DisplayObject):Point
		{
			var w:Number, h:Number,elw:Number, elh:Number, r:Rectangle = detectStageDimensions()
			elw = el.width
			elh = el.height
			
			var diffW:Number = elw - r.width
			var diffH:Number = elh - r.height
			var axis:String = (diffW > diffH)? "vertical" : "horizontal" ;
			switch(axis) 
			{
				case 'horizontal':
					w = r.width
					h = w/ratio
				break;
				case 'vertical':
					if (r.width/r.height > ratio)
					{
						w = r.width
						h = w/ratio
					}else
					{
						h = r.height
						w = h * ratio
					}
				break;
			}
			return new Point(w,h)
		}
		

		public function setBackground(value:String):void 
		{
			if (!Boolean(target.getChildByName('BACKGROUND') as Sprite)) {
				var loader:Loader = new Loader()
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete)
				loader.load(new URLRequest(value))
				loader = null
			}
			else {
				background = target.getChildByName('BACKGROUND') as Sprite
				ratio = ratio || background.width / background.height
				launchPart()
				onPartResize()
			}
		}
	
		
		private function onLoadComplete(e:Event):void 
		{
			e.target.content.removeEventListener(Event.COMPLETE, arguments.callee)
			var back:Sprite = new Sprite()
			back.name = "BACKGROUND"
			var bmp:CrazyBitmap = new CrazyBitmap(e.target.content.bitmapData,"auto",true)
			properties.bitmap = back.addChild(bmp) as CrazyBitmap
			bmp.render()
			var w:Number = properties.bitmap.width , h:Number = properties.bitmap.height;
			ratio = w / h ;
			
			background = target.addChildAt(back, 0) as Sprite
			launchPart()
			onPartResize()
		}
		private function empty():void
		{
			if (target) childrenToArray(target).forEach(function(el, i, arr) {
				//if(el.name =="BACKGROUND") target.removeChildAt(i)
			})
		}
		
		public function clean():void
		{
			if(sectionManager) sectionManager.kill()
		}
	}
	
}