package cv.modules 
{
	import asSist.$;
	import cv.deposit.Deposit;
	import cv.exec.Executer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import gs.easing.Expo;
	import gs.TweenLite;
	import saz.geeks.graphix.deco.Typographeur;
	import saz.helpers.layout.items.LayoutItem;
	import saz.helpers.loadlists.loaders.E.LoadProgressEvent;
	import saz.helpers.math.RatioPreserver;
	import saz.helpers.sprites.Smart;
	import saz.helpers.stage.StageProxy;
	
	/**
	 * ...
	 * @author saz
	 */
	public class BackgroundsView 
	{
		//////////////////////////////////////////////////////////////TEXTFORMATS
		private var aaa_project_title_tf:XML = <flash.text.TextField id="title" name="title" gridFitType="pixel" antiAliasType="advanced" selectable="false" x="25" y="45" autoSize="none" width="175" height="28" multiline="true">
																				<defaultTextFormat>
																					<flash.text.TextFormat font="Trajan Pro" letterSpacing="1" align="right" size="18" bold="false"  color="0xFFFFFF" />
																				</defaultTextFormat>
																			</flash.text.TextField> ;
		private var aaa_project_year_tf:XML = <flash.text.TextField id="year" name="year" gridFitType="pixel" antiAliasType="advanced" selectable="false" x="0" y="118" alpha=".65" autoSize="none" width="175" height="15" multiline="true">
																				<defaultTextFormat>
																					<flash.text.TextFormat font="Arno Pro" letterSpacing="1" align="right" size="12" bold="false" color="0xFFFFFF" />
																				</defaultTextFormat>
																			</flash.text.TextField> ;
		private var aaa_project_number_tf:XML = <flash.text.TextField id="number" name="number" gridFitType="pixel" antiAliasType="advanced" selectable="false" x="2" y="90" alpha=".65" autoSize="none" width="175" height="25" multiline="true">
																				<defaultTextFormat>
																					<flash.text.TextFormat font="Trajan Pro" letterSpacing="0" align="right" size="25" bold="true" color="0xFFFFFF" />
																				</defaultTextFormat>
																			</flash.text.TextField> ;
		///////////////////////////////////////////////////////////////////////////////////VARS
		public var backgrounds:Sprite;
		private var projectLength:int;
		private var background:Backgrounds;
		private var idPage:uint;
		///////////////////////////////////////////////////////////////////////////////////CTOR
		public function BackgroundsView(_target:Backgrounds) 
		{
			background = _target ;
			backgrounds = $("#background")[0] ;
		}
		///////////////////////////////////////////////////////////////////////////////////ADD PROJECT
		public function addProject(_project:LayoutItem):void
		{
			var project:LayoutItem = _project ;
			var i:int = project.properties.index ;
			$(project).attr({id:"project_" + i,name : "project_" + i}) ;
			project.properties.pages = [] ;
			background.projects.push(project) ;
			//project.visible = false ;
			backgrounds.addChild(project) ;
			projectLength = i +1 ;
		}
		///////////////////////////////////////////////////////////////////////////////////ADD PAGE
		public function addPage(_page:Smart):void
		{
			var page:Smart = _page ;
			var i:int = _page.properties.index ;
			var project:LayoutItem = $("#project_" + int(projectLength - 1))[0] ;
			$(page).attr( { id:"project_" + project.properties.index + "_" + "page_" + i , name : "page_" + i } ) ;
			//trace("project_" + project.properties.index + "_" + "page_" + i) ;
			project.properties.pages.push(page) ;
			page.visible = false ;
			project.addChildAt(page,0) ;
		}
		///////////////////////////////////////////////////////////////////////////////////PROGRESS
		public function displayProgress(_page:Smart,e:LoadProgressEvent):void
		{
			if (e.index == 0) {
				var bar:Sprite = $("#bar")[0] ; 
				bar.width = e.bytesLoaded / e.bytesTotal * 175 ;
			}else {
				var l:int = background.currentProject.properties.requests.length;
				var multiple:int = (175 / l ) ;
				var space:int = 1 ;
				var s:Sprite = $('#loadingshape_' + e.index)[0] ;
				s.graphics.clear() ;
				s.graphics.beginFill(0x0) ;
				s.graphics.drawRect(0, 0, e.bytesLoaded / e.bytesTotal * multiple, 2) ;
				s.graphics.endFill() ;
			}
		}
		public function endProgress(i:int):void
		{
			var secundBar:Sprite =  $("#secondbar")[0] ;
			var s:Sprite = $('#loadingshape_' + i)[0] ;
			TweenLite.to(s, .4, { height:7, onComplete:function() {
				s.addEventListener(MouseEvent.CLICK, background.onShapeClicked) ;
			}})
			if (background.currentProject.properties.page is Smart && i == background.currentProject.properties.page.properties.index) {
				if (i == background.currentProject.properties.requests.length - 1) {
					checkPageNavigation(i) ;
				}
			}
		}
		public function killNavIndicators():void {
			$("#secondbar Sprite").remove();
		}
		public function startProgress(i:int):void
		{
			var l:int = background.currentProject.properties.requests.length;
			var secundBar:Sprite =  $("#secondbar")[0] ;
			var multiple:int = (175 / l ) ;
			var space:int = 1 ;
			if (secundBar.getChildAt(0) is Shape ) {
				secundBar.removeChildAt(0) ;
			}
			var s:Sprite = new Sprite();
			s.graphics.clear() ;
			s.graphics.beginFill(0x0) ;
			s.graphics.drawRect(0, 0, multiple, 2) ;
			s.graphics.endFill() ;
			s.x = i * (multiple +1)  ;
			secundBar.addChild(s) ;
			$(s).attr({id:"loadingshape_"+i,name:"loadingshape_"+i,alpha:.7}) ;
		}
		///////////////////////////////////////////////////////////////////////////////////SET PAGE
		public function setPage(_page:Smart,b:BitmapData):void
		{
			if (_page.numChildren == 0) {
				var bitmap:Bitmap = new Bitmap(b, "auto", true) ;
				var ratio:Point = RatioPreserver.preserveRatio(new Point(bitmap.width, bitmap.height) , StageProxy.stageRect) ;
				bitmap.width = ratio.x ;
				bitmap.height = ratio.y ;
				_page.addChild(bitmap) ;
			}
		}
		///////////////////////////////////////////////////////////////////////////////////RESIZE
		private function onBckResize(e:Event):void 
		{
			if(e.target.numChildren > 0) {
				var bitmap:Bitmap = Bitmap(e.target.getChildAt(0)) ;
				var ratio:Point = RatioPreserver.preserveRatio(new Point(bitmap.width, bitmap.height) , StageProxy.stageRect) ;
				bitmap.width = ratio.x ;
				bitmap.height = ratio.y ;
				if(e.target.scrollRect) e.target.scrollRect =  StageProxy.stageRect ;
			}
			var grid:Sprite = $('#grid')[0] ;
			if(grid.width < StageProxy.stageRect.width || grid.height < StageProxy.stageRect.height) Executer.graphix.createGrid() ;
		}
		///////////////////////////////////////////////////////////////////////////////////LAUNCH PROJECT
		public function launchProject():void
		{
			addNav(background.currentProject.properties.index) ;
			checkProjectNavigation(background.currentProject.properties.index) ;
		}
		///////////////////////////////////////////////////////////////////////////////////ADDING NAV
		private function addNav(_num:int):void
		{
			var nav:Sprite = $(new Deposit.NavInside()).attr( { id:"navInside", name:"navInside" } ).appendTo("#nav")[0] ;
			$(nav.getChildByName('backnav')).attr( { id:'backnav' } ) ;
			$(nav.getChildByName("navigation") ).attr( { id:"navigation" } ) ;
			$($("#navigation")[0].getChildByName("bar")).attr({id:"bar"}) ;
			$($("#navigation")[0].getChildByName("futureloading")).attr({id:"secondbar"}) ;
			$($("#navigation")[0].getChildByName("right")).attr({id:"arrowright"}).bind(MouseEvent.CLICK,background.onNavClicked) ;
			$($("#navigation")[0].getChildByName("left")).attr({id:"arrowleft"}).bind(MouseEvent.CLICK,background.onNavClicked) ;
			$($("#navigation")[0].getChildByName("up")).attr({id:"arrowup"}).bind(MouseEvent.CLICK,background.onNavClicked) ;
			$($("#navigation")[0].getChildByName("down")).attr({id:"arrowdown"}).bind(MouseEvent.CLICK,background.onNavClicked) ;
			fillNav(_num) ;
		}
		private function fillNav(_num:int):void
		{
			var nav:Sprite = $("#navInside")[0] ;
			var xml:XML = background.projects[_num].properties.xml ;
			var name:String = xml.@name.toUpperCase() ;
			var year:String = xml.@year.toUpperCase() ;
			var i:int = xml.childIndex() ;
			var projectNumber:String = (int(i+1)<10)? "# " +  "0"+int(i+1) : "# " + int(i+1) ;
			var titleColor:uint = uint(xml.@titleColor.toXMLString()) || 0xFFFFFF ;
			var titleAlpha:Number = xml.@titleAlpha.toXMLString() || .9 ;
			var tint:uint = uint(xml.@color.toXMLString()) == 0 ? 0x0 :  uint(xml.@color.toXMLString()) || 0xFFFFFF ;
			var backNavColor:uint = uint(xml.@backNavColor.toXMLString()) || 0x0 ;
			var backNavAlpha:Number = Number(xml.@opacity.toXMLString()) || 0 ;
			aaa_project_title_tf.@text = name ;
			var tf:TextField = $(aaa_project_title_tf)[0] ;
			var fmt:TextFormat = tf.getTextFormat() ;
			fmt.color = titleColor ;
			tf.setTextFormat(fmt) ;
			tf.alpha = titleAlpha ;
			$(tf).appendTo(nav) ;
			aaa_project_year_tf.@text = year ;
			$(aaa_project_year_tf).appendTo(nav.getChildByName('navigation')) ;
			aaa_project_number_tf.@text = projectNumber ;
			$(aaa_project_number_tf).appendTo(nav.getChildByName('navigation')) ;
			TweenLite.to($("#nav3D")[0],.3,{tint:tint}) ;
			TweenLite.to($("#backnav")[0],0,{tint:tint,alpha:.5}) ;
			TweenLite.to($("#backnav")[0],.5,{tint:backNavColor,alpha:backNavAlpha}) ;
			TweenLite.to($("#navigation")[0],.5,{tint:tint}) ;
			TweenLite.to($("#logo")[0],.5,{tint:tint,alpha:.65}) ;
			TweenLite.to($("#spacenav")[0], .8, { tint:tint, alpha:.65 } ) ;
			Deposit.projectColor = tint ;
		}
		///////////////////////////////////////////////////////////////////////////////////PROJECT NAVIGATION CHECKS
		public function checkProjectNavigation(i:int):void
		{
			var project:LayoutItem = background.projects[i] ;
			displayProjectArrows() ;
			if (project.properties.index == background.projects.length-1) {
				displayProjectArrows("nonext") ;
			}else if (project.properties.index == 0) {
				displayProjectArrows("noprev") ;
			}
		}
		private function displayProjectArrows(_way:String = "both"):void
		{
			switch(_way) {
				case "nonext" :
					$('#arrowdown').attr( { alpha:.4 } ) ;
				break ;
				case "noprev" :
					$('#arrowup').attr( { alpha:.4 } ) ;
				break ;
				default :
					$('#arrowdown').attr( { alpha:1 } ) ;
					$('#arrowup').attr( { alpha:1 } ) ;
				break ;
			}
		}
		public function checkPageNavigation(i:int):void
		{
			var page:Smart = background.currentProject.properties.pages[i] ;
			displayPageArrows() ;
			if (page.properties.index == background.currentProject.properties.pages.length-1) {
				displayPageArrows("nonext") ;
			}else if (page.properties.index == 0) {
				displayPageArrows("noprev") ;
			}
			$("#secondbar Sprite").attr({alpha:.4}) ;
			$("#loadingshape_"+i).attr({alpha:.7}) ;
		}
		private function displayPageArrows(_way:String = "both"):void
		{
			switch(_way) {
				case "nonext" :
					$('#arrowright').attr( { alpha:.4 } ) ;
				break ;
				case "noprev" :
					$('#arrowleft').attr( { alpha:.4 } ) ;
				break ;
				default :
					$('#arrowleft').attr( { alpha:1 } ) ;
					$('#arrowright').attr( { alpha:1 } ) ;
				break ;
			}
		}
		
		
		
		
		
		
		
		
		public function closeProjectPage(id:String):void
		{
			var _page:Smart = $(id)[0] ;
			var r1:Rectangle = _page.scrollRect ;
			
			if (background.way == "next") {
				TweenLite.to(r1, .3,
				{ 
					top:StageProxy.stage.stageHeight, 
					onUpdate:function() {
						_page.scrollRect  = r1 ;
					},
					onComplete:function() {
						_page.visible = false ;
					}
				}) ;
			}else {
				TweenLite.to(r1, .3,
				{ 
					top:-StageProxy.stage.stageHeight, 
					onUpdate:function() {
						_page.scrollRect  = r1 ;
					},
					onComplete:function() {
						_page.visible = false ;
					}
				}) ;
			}
			if (_page.hasEventListener(Event.RESIZE)) _page.removeEventListener(Event.RESIZE, onBckResize) ;
		}
		public function openProjectPage(id:String):void
		{
			var r1:Rectangle,r:Rectangle ;
			var _page:Smart = $(id)[0] ;
			_page.visible = true ;
			if (background.way == "next") {
				r1 = new Rectangle(0,0,StageProxy.stage.stageWidth,StageProxy.stage.stageHeight) ;
				r1.top = -500 ;
				_page.scrollRect  = r1 ;
				r = _page.scrollRect ;
				TweenLite.to(r, .3,
				{ 
					top:0, 
					onUpdate:function() {
						_page.scrollRect  = r ;
					}
				}) ;
			}else {
				r1 = new Rectangle(0,0,StageProxy.stage.stageWidth,StageProxy.stage.stageHeight-200) ;
				r1.top = 500 ;
				_page.scrollRect  = r1 ;
				r = _page.scrollRect ;
				TweenLite.to(r, .3,
				{ 
					height:StageProxy.stage.stageHeight, 
					top:0, 
					onUpdate:function() {
						_page.scrollRect  = r ;
					}
				}) ;
			}
			if (!_page.hasEventListener(Event.RESIZE)) _page.addEventListener(Event.RESIZE, onBckResize) ;
			_page.dispatchEvent(new Event(Event.RESIZE)) ;
		}
		public function closePage(id:String):void
		{
			var _page:Smart = $(id)[0] ;
			var r1:Rectangle = _page.scrollRect ;
			if (background.way == "prev") {
				TweenLite.to(r1, .3,
				{
					left:-StageProxy.stage.stageWidth, 
					onUpdate:function() {
						_page.scrollRect  = r1 ;
					},
					onComplete:function() {
						_page.visible = false ;
					}
				}) ;
			}
			else {
				TweenLite.to(r1, .3,
				{
					left:StageProxy.stage.stageWidth,
					onUpdate:function() {
						_page.scrollRect  = r1 ;
					},
					onComplete:function() {
						_page.visible = false ;
					}
				}) ;
			}
			if (_page.hasEventListener(Event.RESIZE)) _page.removeEventListener(Event.RESIZE, onBckResize) ;
		}
		public function openPage(id:String):void
		{
			var r1:Rectangle, r:Rectangle ;
			var _page:Smart = $(id)[0] ;
			if (background.way == "prev") {
				r1 = new Rectangle(0, 0, StageProxy.stage.stageWidth - 200, StageProxy.stage.stageHeight) ;
				r1.left = StageProxy.stage.stageWidth ;
				_page.scrollRect  = r1 ;
				_page.visible = true ;
				r = _page.scrollRect ;
				TweenLite.to(r, .3,
				{ 
					width:StageProxy.stage.stageWidth, 
					left:0,
					onUpdate:function() {
						_page.scrollRect  = r ;
					}
				}) ;
			}else {
				r1 = new Rectangle(0, 0, StageProxy.stage.stageWidth, StageProxy.stage.stageHeight) ;
				r1.left = -StageProxy.stage.stageWidth ;
				_page.scrollRect  = r1 ;
				_page.visible = true ;
				r = _page.scrollRect ;
				TweenLite.to(r, .3,
				{ 
					left:0,
					onUpdate:function() {
						_page.scrollRect  = r ;
					}
				}) ;
			}
			if (!_page.hasEventListener(Event.RESIZE)) _page.addEventListener(Event.RESIZE, onBckResize) ;
			_page.dispatchEvent(new Event(Event.RESIZE)) ;
		}

		private function tweenOutProject(_project:LayoutItem):void
		{
			_project.visible = false ;
		}
		private function tweenInProject(_project:LayoutItem):void
		{
			_project.visible = true ;
		}
		///////////////////////////////////////////////////////////////////////////////////KILL PROJECT
		public function killProject(_project:LayoutItem):void
		{
			killNavIndicators() ;
			$("#navInside").remove() ;
		}
		///////////////////////////////////////////////////////////////////////////////////KILL
		public function kill():void
		{
			background.projects.forEach(function(el, i, arr) { $(el).remove() ; delete arr[i] ; } ) ;
		}
	}
	
}