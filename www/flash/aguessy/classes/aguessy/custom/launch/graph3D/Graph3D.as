package aguessy.custom.launch.graph3D 
{
	import aguessy.custom.launch.NewsInsideSteps;
	import aguessy.custom.launch.NewsItemSteps;
	import aguessy.custom.launch.PortfolioInsideSteps;
	import aguessy.custom.launch.PortfolioItemSteps;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import frocessing.core.F5Graphics3D;
	import frocessing.display.F5MovieClip3D;
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Graph3D 
	{
		public var __displayer:Graph3DView;
		private var __fg:F5Graphics3D;
		internal var __nav3D:Nav3D;
		internal var __switchables:Array;
		internal var __currentIndex:int;
		
		public function Graph3D() 
		{
			__displayer = new Graph3DView() ;
		}
		
		public function init(_mc:DisplayObject, _nav3D:Nav3D):void
		{
			__nav3D = _nav3D ;
			__displayer.__target = _mc ;
			if (_mc is F5MovieClip3D) {
				var _fm:F5MovieClip3D = F5MovieClip3D(_mc) ;
				__fg = _fm.fg ;
			}
			else if (_mc is Sprite) {
				var _do:Sprite = Sprite(_mc) ;
				__fg = new F5Graphics3D(_do.graphics,_do.width,_do.height) ;
			}
			else {
				
			}
			__displayer.init3D(__fg, this) ;
		}
		
		
		//	GRAPH
		internal function prev():void
		{
			if (Boolean(__switchables[__currentIndex - 1])) {
				sliceArr(1) ;
				setCurrent() ;
			}else {
				getToPrev() ;
			}
		}
		
		private function getToPrev():void
		{
			var ind:int ;
			var i:int = __currentIndex - 1 ;
			var indice:int = __currentIndex ;
			var l:int = __switchables.length ;
			while (i > -1) {
				if (Boolean(__switchables[i])) {
					ind = i ;
					break ;
				}else {
					if (i == 0) i = l ;
					if (i == indice) return ;
					i -- ;
				}
			}
			sliceArr(__currentIndex - ind ) ;
			setCurrent() ;
		}
		
		internal function next():void
		{
			if (Boolean(__switchables[__currentIndex + 1])) {
				sliceArr(-1) ;
				setCurrent() ;
			}else {
				getToNext() ;
			}
		}
		private function getToNext():void
		{
			var ind:int ;
			var i:int = __currentIndex + 1 ;
			var indice:int = __currentIndex ;
			var l:int = __switchables.length ;
			while (i < l) {
				if (Boolean(__switchables[i])) {
					ind = i ;
					break ;
				}else {
					if (i == l - 1) i = -1  ;
					if (i == indice) return ;
					i ++ ;
				}
			}
			sliceArr(__currentIndex - ind ) ;
			setCurrent() ;
		}
		
		internal function rearrange():void
		{
			var length:int = __switchables.length ;
			__displayer.__currentCube = __displayer.__items[__currentIndex] ;
			for (var i:int = 0 ; i < length ; i++) {
				var item:XML = __switchables[i] ;
				var l:int = 0 ;
				if (i < __displayer.__totalAvailable) {
					if (Boolean(XML(item).toXMLString() != "")) {
						//l = item.hasComplexContent()? item.descendants("source").length() : 0 ;
						l = item.descendants("source").length() ;
						if (item.hasOwnProperty('@color')) {
							__displayer.setCubeColor(uint(item.@color.toXMLString()),i) ;
						}else {
							__displayer.setCubeColor(null,i) ;
						}
						
						__displayer.variate(i, l, item) ;
						__displayer.highlight(__currentIndex, false) ;
					}else {
						__displayer.setCubeColor(null, i) ;
						__displayer.variate(i, l) ;
						__displayer.highlight(__currentIndex, false) ;
					}
				}
			}
			var step:VirtualSteps = __nav3D.currentStep ;
			step.userData.switchables = __switchables ;
			step.userData.currentIndex = __currentIndex ;
		}
		
		internal function setCurrent(pos:int = -1):void
		{
			__currentIndex = pos == -1 ? 3 : pos ;
			__displayer.__currentCube = __displayer.__items[pos] ;
			var p:XML = __switchables[__currentIndex] ;
			rearrange() ;
			if (!__nav3D.__final) addHover() else {
				if (__nav3D.currentStep.hasOwnProperty("onCurrent") && __nav3D.currentStep["onCurrent"] is Function) {
					__nav3D.currentStep["onCurrent"](p) ;
				}
			}
		}
		
		private function addHover(cond:Boolean = true):void
		{
			var node:XML = XML(__switchables[__currentIndex]) ;
			var chInd:int = node.childIndex() ;
			var i:int = __currentIndex ;
			var id:String ;
			if (node.hasOwnProperty("@id")) {
				id = node.@id.toXMLString() ;
			}else {
				if (node.hasOwnProperty("@name")) {
					id = node.@name.toXMLString() ;
				}else {
					id = String(chInd + 1) ;
				}
			}
			var step:VirtualSteps = __nav3D.currentStep ;
			var d:int = step.depth ;
			if (cond) {
				var downStp:VirtualSteps = step.gates.merged[chInd] ;
				if (downStp is PortfolioItemSteps || downStp is NewsItemSteps || downStp is NewsInsideSteps) {
					var infos:XML ;
					if (downStp is PortfolioItemSteps) {
						infos = PortfolioItemSteps(step.gates.merged[chInd]).infos ;
						id = infos.usename[0] ;
					}else if (downStp is NewsItemSteps || downStp is NewsInsideSteps) {
						infos = VirtualSteps(step.gates.merged[chInd]).xml ;
						id = infos.@usename.toXMLString() ;
					}
				}
				__displayer.addHover(id.replace(/&amp;/gi, "&"),__currentIndex,d,cond) ;
			}else {
				__displayer.addHover(id,__currentIndex,d,cond) ;
			}
		}
		
		
		public function play():void
		{
			__displayer.render(true) ;
		}
		public function stop():void
		{
			__displayer.render(false) ;
		}
		public function reset():void
		{
			__displayer.reset() ;
		}
		public function levelOne(cond:Boolean):void {
			__displayer.levelOne(cond) ;
		}
		public function finalEvents(i:int,cond:Boolean = true):void
		{
			//g3D.finalEvents(_step,cond) ;
		}
		
		public function fillMedias(_step:VirtualSteps,cond:Boolean = true):void
		{
			if (cond) {
				__displayer.addTextPage(_step, cond) ;
				__displayer.redrawPage() ;
				//__displayer.addMediasInfos(_step.xml) ;
			}else {
				__displayer.addTextPage(_step, cond) ;
				//__displayer.removeMediasInfos() ;
			}
		}
		
		
		public function fillNews(_step:VirtualSteps,cond:Boolean):void
		{
			if (cond) {
				__displayer.addNewsInfos(_step["infos"]) ;
			}else {
				__displayer.removeNewsInfos() ;
			}
		}
		
		public function fillInfos(_step:VirtualSteps,cond:Boolean):void
		{
			if (cond) {
				__displayer.addPortfolioInfos(_step["infos"]) ;
			}else {
				__displayer.removePortfolioInfos() ;
			}
		}
		
		public function addSubSection(_step:VirtualSteps,cond:Boolean):void
		{
			var s:String = _step.xml.@usename.toXMLString().replace(/&amp;/gi,"&") ;
			__displayer.addSubSection(_step.depth, s==""? String(_step.id) : s ,cond) ;
		}
		
		public function fill(_step:VirtualSteps,cond:Boolean):void
		{
			if (cond) {
				var s:String = _step.xml.@usename.toXMLString().replace(/&amp;/gi,"&") ;
				__displayer.addTitle() ;
				__displayer.fillTitle(s==""? String(_step.id) : s) ;
			}else {
				__displayer.removeTitle() ;
			}
		}
		
		public function appendText(step:VirtualSteps,cond:Boolean):void
		{
			var page:XML ;
			if (cond) {
				__displayer.addTextPage(step, cond) ;
				for each(page in step.xml.source) {
					__displayer.fillTextPage(step,page,cond) ;
				}
				__displayer.redrawPage() ;
			}else {
				for each(page in step.xml.page) {
					__displayer.fillTextPage(step,page,cond) ;
				}
				__displayer.addTextPage(step,cond) ;
			}
		}
		
		
		
		public function evaluate(_steps:VirtualSteps):void {
			if (__nav3D.currentStep.userData && __nav3D.currentStep.userData.switchables) {
				__switchables = __nav3D.currentStep.userData.switchables ;
				sliceArr(0) ;
				setCurrent() ;
			}else {
				__switchables = new Array(7) ;
				var xml:XML = _steps.xml ;
				if (xml && xml.hasComplexContent()) {
					var length:int = xml.hasComplexContent()? xml.*.length() :  0 ;
					for (var i:int = 0; i < length ; i++ ) {
						var item:XML = xml.*[i] ;
						__switchables[i] = item ;
					}
					var cur:int ;
					var availableLength:int = __displayer.__totalAvailable ;
					if (length < availableLength >> 1) {
						switch(length) {
							case 1:
								cur = 3 ;
							break ;
							case 2:
								cur = 3
							break ;
							case 4:
							case 3:
								cur = availableLength - length ;
							break ;
						}
					}else {
						if(length <= availableLength){
							cur = 3 ;
						}else {
							cur = 3 ;
						}
					}
					sliceArr(cur) ;
					setCurrent(cur) ;
				}
			}
			
			
			
		}
		
		internal function sliceArr(dif:int):void
		{
			if (__currentIndex) addHover(false) ;
			
			var l:int = __switchables.length ;
			__switchables = __switchables.splice( -dif).concat(__switchables.slice(0, l - dif)) ;
		}
	}
	
}