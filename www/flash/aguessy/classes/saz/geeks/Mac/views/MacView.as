package saz.geeks.Mac.views
{
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.Tweener;
	import f6.helpers.essentials.collections.SpriteCollection;
	import f6.helpers.essentials.collections.SpriteIterator;
	import f6.lang.reflect.Type;
	import f6.utils.iterator.Iterator;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import 			flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import 			flash.display.Sprite;
	import 			flash.display.Stage;
	import 			flash.display.StageAlign;
	import 			flash.events.Event;
	import flash.events.MouseEvent;
	import 			flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import 			flash.text.Font;
	import 			flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import org.papervision3d.core.controller.SkinController;
	import saz.geeks.graphix.deco.ReflectFade;
	import saz.geeks.Mac.MacPlayer;
	import 			saz.geeks.Mac.MacPlayerGraphics;
	import saz.geeks.Mac.parts.Part;
	import saz.geeks.Mac.parts.Parts;
	
	/**
	 * ...
	 * @author saz
	 */
	public class MacView 
	{
		public var 		skin				:MacSkin
		private var 	macGraphX			:MacPlayerGraphics
		private var 	stage				:Stage		
		private var 	originalDimensions	:Point
		
		//	GRAPHICS
		private var 	background			:Sprite
		private var 	upperNav			:Sprite
		private var 	next_btn			:Sprite
		private var 	prev_btn			:Sprite
		private var 	section				:SpriteCollection
		private var 	visualSection		:Sprite
		private var 	titleSection		:Sprite
		private var 	titleSection_txt	:TextField

		private var 	sections				:SpriteCollection
		private var 	parts					:Parts
		private var 	layer					:Sprite
		private var 	resizables				:Array
		private var 	sprites					:Array
		private var 	textes					:Array		
		private var 	toEnable				:Array
		private var 	oldSection				:SpriteCollection
		private var 	SectionNewTweenCoords	:Object
		private var 	SectionOldTweenCoords	:Object
		private var		startReferencePoint		:Point
		private var		target					:DisplayObjectContainer
		private var 	_skin					:MacSkin
		private var 	_xList					:XMLList;
		private var 	part					:Part
		
		public function MacView() 
		{
			ColorShortcuts.init()
			CurveModifiers.init()
			FilterShortcuts.init()
		}
		
		private function initSkin():void
		{
			//new (skin.MUSIC as Class)()
		}
		
		public function init(_macGraphX:MacPlayerGraphics):MacView
		{
			macGraphX = _macGraphX
			
			
			return this
		}
		
		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT
			stage.scaleMode = "noScale"
			originalDimensions = new Point(stage.stageWidth, stage.stageHeight)
		}
		
		private function initConstantElems():void
		{
			background 							= target.getChildByName('BACKGROUND') as Sprite
			parts								= target.addChild(new Parts()) as Parts
				parts.name 						= "PARTS"
			layer								= target.addChildAt(new Sprite(),target.numChildren) as Sprite
				layer.name						= 'LAYER'
			
			upperNav 							= target.addChild(skin.UPPER_NAV) as Sprite		
			resizables 							= [upperNav, background ,layer, parts]
		}
		
		public function generate(_xlist:XMLList):void
		{
			_xList 								= _xlist
			_skin 								= skin
			target							 	= macGraphX.macPlayer.target
			stage 								= target.stage
			initStage()
			initConstantElems()
			
			macGraphX.macPlayer.enableForResize()
			
			macGraphX.macPlayer.enableHome(resizables)
			
			macGraphX.macPlayer.enableForKeyPress()
			
			initSections()
		}
		
		private function initSections():void
		{
				
				sections							= target.addChildAt(new SpriteCollection(),layer.parent.getChildIndex(layer)+1) as SpriteCollection
					sections.name 					= "SECTIONS"
				next_btn 							= target.addChild(skin.NEXT) as Sprite
				prev_btn 							= target.addChild(skin.PREV) as Sprite
				textes 								= []
				toEnable							= [next_btn, prev_btn]
				
				resizables.push(sections,next_btn,prev_btn)
				
				for each(var item:XML in _xList)
						createSection(item)
				displayLayer()
				displayNavElems(false)
				posElems()
		}
		
		private function displayLayer():void
		{
			with (layer.graphics) {
				beginFill(0x131313,.96)
				drawRect(0,0,background.width,background.height)
				endFill()
			}
			enableLayer(false,0)
		}
		
		private function enableLayer(cond:Boolean,_time:int):void
		{
			if (cond) {
				showHideLayer(cond) 
				Tweener.addTween(layer, { _color:0x0 ,time:0})
				Tweener.addTween(layer, { alpha: 1, time:_time,_color:null})
			}
			else
				Tweener.addTween(layer, { alpha: 0, time:_time ,delay:_time==0 ? 0 : .3, onComplete:function() { showHideLayer(cond) }} )
			
		}
		
		private function showHideLayer(cond:Boolean):void
		{
			layer.visible = cond
		}
		
		private function displayNavElems(cond:Boolean):void
		{
			toEnable.forEach(function(el, i, arr) { el.visible = cond } )
			enableLayer(cond,.5)
		}
		
		public function toRequestedSection()
		{
			if (parts.numChildren != 0)
				cleanUpParts()
			part = new Part( { background:skin.PARTS_MCS_BACKGROUNDS[section.properties.id], id:section.properties.id , name: getQualifiedClassName(skin.PARTS_MCS[section.properties.id])} )

			part.target = part.addChild(skin.PARTS_MCS[section.properties.id]) as Sprite
			parts.addPart(part)
			parts.loadBackground()
		}
		
		private function cleanUpParts():void
		{
			parts.removePart()
		}
		
		
		public function displaySections(cond:Boolean):void
		{
			if (cond) {
				displayNavElems(true)
				appearNewSection()
				macGraphX.macPlayer.enableNav(toEnable)
			}
			else {
				Tweener.addTween(sections, { alpha:0, time:.5,transition:"easeInExpo", onComplete:function() {  displayNavElems(false) ; this.alpha = 1}} )
				macGraphX.macPlayer.disableNav(toEnable)
				
			}
		}
		
		public function showNav(cond:Boolean):void
		{
			displaySections(cond)
		}
		
		private function createSection(_node:XML):void
		{
			var i:int = _node.childIndex()
			section 							= new SpriteCollection()
			
			section.properties = { clipName:"SECTION", id:i , sectionMC: skin.PARTS_MCS[i]}
			
			
			section.name = section.properties.clipName
				var s:Sprite = section.addChild(new (skin.SECTION) as Sprite) as Sprite
				visualSection							= s.getChildByName('SECTION_IMAGE') as Sprite 
					var loader:Loader 					= visualSection.addChild(new Loader()) as Loader
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbComplete)
					loader.load(new URLRequest(_node.@img))
					titleSection 						= s.getChildByName('SECTION_TITLE') as Sprite
					
					titleSection_txt 					= titleSection.getChildByName('SECTION_TITLE_TXT') as TextField
					
					titleSection_txt.text 				= _node.@title
			sections.add(section)
			toEnable.push(section)
			section.alpha = 0
			section.properties.clip = s
			//
			//var sprReflect:Reflecter = new Reflecter(section.properties.clip, .4, .2, 0, 0, 1);
            //section.addChild(sprReflect); 
			
		}
		
		private function onThumbComplete(e:Event):void 
		{
			//About the displayed Bitmap
			var loaderInfo:LoaderInfo = e.target as LoaderInfo
			var sprCol = loaderInfo.loader.parent.parent.parent as SpriteCollection
			var i:int = sprCol.properties.id
			var cont:Sprite = loaderInfo.loader.parent as Sprite
			loaderInfo.content.x = - (loaderInfo.content.width >> 1)
			cont.removeChild(loaderInfo.loader)
			cont.removeChildAt(0)
			var bmp:Bitmap = loaderInfo.content as Bitmap
			bmp.smoothing = true
			cont.addChild(bmp)
			
			//STYLEES
			StyleIt(sprCol)
			
			//si arrivé au bout
			if(i == sections.toArray().length-1)
			//displays current SectionNode on the View
			showCurrent()
		}
		
		private function StyleIt(_sprColl:SpriteCollection):void
		{
			var clip:Sprite = _sprColl.properties.clip as Sprite
			new ReflectFade(clip)
			_sprColl.properties.initPoint = new Point(section.x, 0)
			switchWay(true)
		}
		
		public function showCurrent():void
		{
			var _num:int = macGraphX.macPlayer.MacDepot.sectionIndex
			// determine num current from XML
			section = sections.toArray()[_num]
			//	given number is the one to set to current
			enableRightSection(_num)
			//	now let's talk about old sections
			oldSection = section
		}
		
		private function enableRightSection(_num:int):void
		{
			var n:int = _num
			
			var it:Iterator = sections.iterator() as Iterator
			while (it.hasNext()) {
				var x:SpriteCollection = it.next() as SpriteCollection
				checkSection(x)
			}
		}
		private function appearNewSection():void
		{
			Tweener.addTween(section, { alpha:1, time:0, x:0,transition:"easeOutExpo",onStart:function() {
				appearFunction(this, "start")
				
				}, onComplete:function() {
				appearFunction(this, "complete")
				var l:Sprite = this.properties.clip.getChildByName('REFLECT') as Sprite
				//l.visible = true
				Tweener.addTween(l,{alpha:.1,time:1,delay:0,transition:"easeOutQuint",onStart:function(){this.alpha = .7},onComplete:function(){/*this.visible = false*/}})
				
				}})
		}
		
		private function appearFunction(_spr:SpriteCollection,_way:String):void
		{
			var el:Sprite = _spr.properties.clip as Sprite
			switch(_way)
			{
				case "start":
					_spr.x = startReferencePoint.x
				break;
				case "complete":
					_spr.x = 0
				break;
			}
		}
		
		private function switchWay(toRight:Boolean):void
		{
			startReferencePoint = new Point(toRight ?  0 : 0 , toRight? 1000 : -1000  )
		}
		
		private function hideFunction(_spr:SpriteCollection,_way:String):void
		{
			var el:Sprite = _spr.properties.clip as Sprite
			switch(_way)
			{
				case "start":
					//
				break;
				case "complete":
					_spr.x = oldSection.properties.initPoint.x
				break;
			}
		}
		
		
		private function removeOldSection():void
		{
			if (!oldSection) return
			
			Tweener.addTween(oldSection, { alpha:0, time:.8, x:oldSection.properties.initPoint.x - startReferencePoint.x,transition:"easeOutQuint", onStart:function() {
				hideFunction(this,"start")
				}, onComplete:function() {
				hideFunction(this,"complete")
				}})
		}
		
		private function checkSection(el:SpriteCollection):void
		{
			//pos(el)
			
			var sprite:Sprite = el.toArray()[0] as Sprite
			if (el == section) {
				appearNewSection()
			}
			
			if(el == oldSection)
			{
				removeOldSection()
			}
			
		}
		

		
		public function posElems(e:Event = null):void
		{
			var cond = e is Event
			if (resizables) {
				var arr:Array = resizables, l:int = arr.length 
				for (var i = 0; i < l ; i++ ) {
					pos(arr[i],e,!cond)
				}
			}
		}
		public function SectionsTween(_num:int):void
		{
			if(_num>0)
				switchWay(true)
			else
				switchWay(false)
		}
		private function pos(el:DisplayObjectContainer ,e:Event = null, initOnly:Boolean = false):void
		{
			var X:Number, Y:Number
			//trace(el.name)
			switch (el.name)
			{
				case 'UPPER_NAV':
					if (initOnly) {
						X = 20
						Y = 20
					}
				break;
				case 'PREV':
					X = 50
					Y = (stage.stageHeight >> 1) - 50
				break;
				case 'NEXT':
					X = stage.stageWidth - 50
					Y = (stage.stageHeight >> 1) - 50
					if (initOnly) {
						el.scaleX = -1
					}
				break;
				case 'LAYER':
				case 'BACKGROUND':
					el.width = stage.stageWidth
					el.height = stage.stageHeight
				break;
				case 'SECTIONS' :
					
					X = (stage.stageWidth >> 1)
					Y = ((stage.stageHeight >> 1) - (section.height >> 1))
					//if(el.scaleX>=.5)
					//el.scaleX = el.scaleY = (stage.stageHeight / 600 < 1 ) ? stage.stageHeight / 600 : 1 ;
					//else
					//el.scaleX = el.scaleY = .5
					
					
				break;
				case 'PARTS':
					if (parts.toArray()[0] as SpriteCollection) {
						parts.toArray()[0].dispatchEvent(new Event(Event.RESIZE))
					}
				break;
				default:
					//X = 100
					//Y = 140
				break;
			}
			with (el) {
				if(X) x = X
				if(Y) y = Y
			}

		}
		
	}
	
}