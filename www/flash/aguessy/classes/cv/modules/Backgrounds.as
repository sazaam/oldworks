package cv.modules 
{
	import asSist.$;
	import cv.exec.Controller;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import mvc.behavior.commands.Command;
	import mvc.behavior.steps.E.StepEvent;
	import mvc.behavior.steps.Step;
	import mvc.behavior.steps.VirtualSteps;
	import saz.helpers.layout.items.LayoutItem;
	import saz.helpers.loadlists.loaders.E.LoadEvent;
	import saz.helpers.loadlists.loaders.E.LoadProgressEvent;
	import saz.helpers.loadlists.loaders.MultiLoader;
	import saz.helpers.loadlists.loaders.MultiLoaderRequest;
	import saz.helpers.loadlists.loaders.XLoader;
	import saz.helpers.sprites.Smart;
	import saz.helpers.stage.StageProxy;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Backgrounds 
	{
		private static var cache:Dictionary = new Dictionary() ;
		private var mainController:Controller;
		public var view:BackgroundsView;
		private var steps:VirtualSteps;
		private var STEPS:Dictionary;
		
		public var projects:Array;
		public var currentProject:LayoutItem;
		public var oldProject:LayoutItem;
		public var currentPage:Smart;
		public var oldPage:Smart;
		
		private var currentInfos:NavigationInfos;
		private var oldInfos:NavigationInfos;
		
		public var pageWay:String;
		public var way:String ;
		private var closingPageID:String;
		private var openingPageID:String;
		
		public function Backgrounds(_tg:Controller) 
		{
			projects = [] ;
			mainController = _tg ;
			view = new BackgroundsView(this) ;
			STEPS = new Dictionary() ;
			steps = new VirtualSteps( ) ;
		}
		///////////////////////////////////////////////////////////////////////////////////INIT
		public function init(_xml:XML):void
		{
			var _node:XML = _xml ;
			for each(var project:XML in _node.project) {
				var proj:LayoutItem = new LayoutItem( { index:project.childIndex(), xml:project ,requests:[] } ) ;
				view.addProject(proj) ;
				for each(var page:XML in project.page) {
					var reqID:String = page.@img.toXMLString() ;
					proj.properties.requests.push(new MultiLoaderRequest(reqID, page.childIndex(), null)) ;
					var pageSmart:Smart = new Smart( { index:page.childIndex() , xml: page , project:proj } ) ;
					pageSmart.name = "page_" + page.childIndex() ;
					addPageStep(pageSmart) ;
					view.addPage( pageSmart ) ;
				}
			}
		}
		private function addPageStep(_page:Smart):Step
		{
			var id:String = _page.properties.project.name + "/" + _page.name ; 
			var step:Step = new Step(_page.properties.project.name + "/" + _page.name, new Command(null, openPage, id), new Command(null, closePage, id)) ;
			//trace(step.id)
			step.addEventListener(StepEvent.OPEN,onOpenPage) ;
			step.addEventListener(StepEvent.CLOSE,onClosePage) ;
			steps.add(step) ;
			STEPS[id] = step ;
			return step ;
		}
		private function onClosePage(e:StepEvent):void 
		{
			trace("closing...")
			if (oldInfos.projectName != oldInfos.projectName) {
				$("#" + currentInfos.projectName)[0] ;
				closeLoadings($("#"+currentInfos.projectName)[0]) ;
			}
		}
		private function onOpenPage(e:StepEvent):void 
		{
			trace("opening...")
			// si pas à l'init
			if (oldInfos) {
				// si on change de projet
				if (currentInfos.projectName != oldInfos.projectName) {
					var oldProject:LayoutItem = $("#" + oldInfos.projectName)[0] ;
					view.closeProjectPage(oldInfos.pageID) ;
					killProject(oldProject) ;
					launchLoading(currentInfos.projectIndex) ;
					view.openProjectPage(currentInfos.pageID) ;
				}
				else {
					view.closePage(oldInfos.pageID) ;
					view.openPage(currentInfos.pageID) ;
				}
			}else {
				// à l'init
				launchLoading(currentInfos.projectIndex) ;
				view.openPage(currentInfos.pageID) ;
			}
			view.checkProjectNavigation(currentInfos.projectIndex) ;
			view.checkPageNavigation(currentInfos.pageIndex) ;
		}
		
		private function removePageStep(_page:Smart):Step
		{
			var id:String = _page.properties.project.name + "/" + _page.name ;
			var step:Step = STEPS[id] ;
			steps.remove(step.id) ;
			STEPS[id] = null ;
			delete STEPS[id] ;
			return step ;
		}
		private function closePage(_id:String):void
		{
			oldInfos = getNavInfos(_id) ;
			oldProject = $("#" + oldInfos.projectName)[0] ;
			oldPage = $(oldInfos.pageID)[0] ;
		}
		private function openPage(_id:String):void
		{
			currentInfos = getNavInfos(_id) ;
			currentProject = $("#" + currentInfos.projectName)[0] ;
			currentPage = $(currentInfos.pageID)[0] ;
		}
		private function getNavInfos(_id:String):NavigationInfos
		{
			var indexes:Array = _id.split("/") ;
			var projectName:String = indexes[0] ;
			var pageName:String = indexes[1] ;
			var projectIndex:int = int(projectName.substr(projectName.indexOf("_")+1,projectName.length)) ;
			var pageIndex:int = int(pageName.substr(pageName.indexOf("_") + 1, pageName.length)) ;
			var pageID:String = "#" + projectName + "_" + pageName ;
			return $(NavigationInfos).attr({id:_id,projectName:projectName,pageName:pageName,projectIndex:projectIndex,pageIndex:pageIndex,pageID:pageID})[0] ;
		}
		public function onShapeClicked(e:MouseEvent):void
		{
			var n:int = e.target.name.substr( -1, e.target.name.lastIndexOf('_')) ;
			
			if ( n == currentInfos.pageIndex ) return ;
			way = (n < currentInfos.pageIndex)? "prev" : "next" ;
			launchPage(n) ;
		}
		///////////////////////////////////////////////////////////////////////////////////NAVIGATION
		//////////////////////////////////////////////////////////NAV
		public function onNavClicked(e:MouseEvent):void
		{
			switch(e.currentTarget.name) {
				case 'right' :
					nextPage() ;
				break ;
				case 'left' :
					prevPage() ;
				break ;
				case 'up' :
					prevProject() ;
				break ;
				case 'down' :
					nextProject() ;
				break ;
			}
		}
		//////////////////////////////////////////////////////////PROJECT
		public function nextProject():void
		{
			way = "next" ;
			launchProject(currentInfos.projectIndex + 1) ;
		}
		public function prevProject():void
		{
			way = "prev" ;
			launchProject(currentInfos.projectIndex - 1) ;
		}
		//////////////////////////////////////////////////////////PAGE
		public function nextPage():void
		{
			way = "next" ;
			if (currentInfos.pageIndex < currentProject.properties.pages.length-1) steps.next() ;
		}
		public function prevPage():void
		{
			way = "prev" ;
			if (currentInfos.pageIndex > 0) steps.prev() ;
		}
		///////////////////////////////////////////////////////////////////////////////////LAUNCH PROJECT
		public function launch(_num:int = -1):void
		{
			way = "next" ;
			if (_num == -1) steps.next() 
			else {
				launchProject(_num) ;
			}
		}
		public function launchProject(_num:int = -100):void
		{
			if (_num == -100) _num = 0 ;
			else if (_num >=  projects.length)
			_num = 0 ;
			else if (_num < 0)
			_num = projects.length -1 ;
			
			steps.launch("project_" + _num + "/" + "page_0") ;
			if (mainController.stepOnePassedThrough && mainController.isLaunching != true) {
				mainController.graphix.setNav3D(true) ;
			}
		}
		///////////////////////////////////////////////////////////////////////////////////LAUNCH PROJECT
		public function launchPage(_num:int):void
		{
			if (_num == currentInfos.pageIndex) return ;
			if (_num >=  currentProject.properties.pages.length) {
				_num = 0 ;
			}
			if (_num < 0) {
				_num = currentProject.properties.pages.length - 1 ;
			}
			steps.launch("project_" + currentInfos.projectIndex + "/" + "page_"+_num) ;
		}
		///////////////////////////////////////////////////////////////////////////////////KILL PROJECT
		private function killProject(_project:LayoutItem):void
		{
			if (mainController.stepOnePassedThrough) mainController.graphix.killOldAwaitingSection() ;
			view.killProject(_project) ;
			if (_project.properties.loading) closeLoadings(_project) ;
		}
		///////////////////////////////////////////////////////////////////////////////////LAUNCH LOADINGS
		private function launchLoading(_num:int):void
		{
			// if project doesn't exist bounce off
			if (!Boolean(projects[_num] as LayoutItem)) return ;
			var project:LayoutItem = projects[_num] ;
			view.launchProject() ;
			// set loader
			project.properties.loader = new XLoader() ;
			var loader:XLoader = project.properties.loader ;
			// set embedded results
			project.properties.results = [] ;
			// check awaiting results
			var results:Array = checkLoadedPages(project) ;
			// launch all project loadings if some are missing
			if (results.length != 0) {
				loader.addEventListener(LoadProgressEvent.PROGRESS, onProgress) ;
				loader.addEventListener(LoadEvent.COMPLETE, onComplete) ;
				loader.loadAll() ;
				project.properties.loading = true ;
			}
			// if not delete project's personal Loader
			else {
				project.properties.loading = false ;
				
				for (var i:int = 0 , l:int = project.properties.requests.length ; i < l ; i++ ) {
					view.endProgress(i) ;
				}
				//view.launchPage( currentPage.properties.index || 0 ) ;
				project.properties.loader = null ;
				delete project.properties.loader ;
			}
		}
		private function onComplete(e:LoadEvent):void 
		{
			var xLoader:XLoader = XLoader(e.currentTarget) ;
			var mLoader:MultiLoader = e.currentTarget.loader ;
			var req:MultiLoaderRequest = e.req ;
			var bmp:Bitmap = e.currentTarget.loader.getResponseById(e.req.id) ;
			//	take care of the data
			cache[e.req.url] = bmp.bitmapData ;
			currentProject.properties.results.push(cache[e.req.url]) ;
			currentProject.properties.requests[int(e.req)] = cache[e.req.url] ;
			//	place page in view
			view.endProgress(int(MultiLoaderRequest(e.req).id)) ;
			view.setPage( currentProject.properties.pages[int(MultiLoaderRequest(e.req).id)] , cache[e.req.url]) ;
			//	if all list is clear bounce off
			if (currentProject.properties.results.length == currentProject.properties.requests.length) {
				currentProject.properties.loading = false ;
				removeEventsFromProject(currentProject) ;
				//trace('ok all loaded') ;
			}
		}
		
		private function onProgress(e:LoadProgressEvent):void 
		{
			if (currentProject.properties.loading) {
				view.displayProgress( currentProject.properties.pages[int(MultiLoaderRequest(e.req).id)] , e)
			}
			//trace(e.bytesLoaded / e.bytesTotal) 
			if (e.bytesLoaded / e.bytesTotal == 1) {
				//trace("YO")
			}
		}
		
		private function closeLoadings(_project:LayoutItem):void
		{
			if (_project.properties.loading) {
				// remove downloading events
				removeEventsFromProject(_project) ;
				for (var i:int = 0 ; i < _project.properties.requests.length ; i++ ) {
					if (_project.properties.requests[i] as MultiLoaderRequest) {
						//  close loading process if there is one working
						try {  Loader(MultiLoaderRequest(_project.properties.requests[i]).LOADER).close() ;  }
						catch (e:Error) {/*	trace(i + " is not a MultiLoaderRequest")    */}
					}
				}
				_project.properties.loading = false ;
			}
		}
		
		private function removeEventsFromProject(_project:LayoutItem):void
		{
			if (_project.properties.loader && _project.properties.loader.hasEventListener(LoadEvent.COMPLETE) ) _project.properties.loader.removeEventListener(LoadEvent.COMPLETE , onComplete) ;
			if (_project.properties.loader && _project.properties.loader.hasEventListener(ProgressEvent.PROGRESS) ) _project.properties.loader.removeEventListener(ProgressEvent.PROGRESS , onProgress) ;
			
		}
		private function checkLoadedPages(project:LayoutItem):Array
		{
			var l:int = project.properties.requests.length ;
			var p:Array = new Array() ;
			for (var i:int = 0 ; i < l ; i++ ) {
				view.startProgress(i) ;
				var page:Smart = Smart(project.properties.pages[i]) ;
				if (project.properties.requests[i] as MultiLoaderRequest) {
					var pageID:String = MultiLoaderRequest(project.properties.requests[i]).url ;
					if (cache[pageID] is BitmapData) {
						//trace("Already Has it !! " + pageID) ;
						view.endProgress(page.properties.index) ;
						view.setPage( page , cache[pageID]) ;
					}else {
						//trace("HERE : " + project.properties.index) ;
						//trace("adding request : "+pageID) ;
						XLoader(project.properties.loader).add(project.properties.requests[i]) ;
						p.push( project.properties.requests[i] ) ;
					}
				}else if (project.properties.requests[i] is BitmapData) {
					//trace("yes it is a Bitmap")
					view.endProgress(page.properties.index) ;
					view.setPage( page , project.properties.requests[i]) ;
				}
			}
			return p ;
		}
		/////////////////////////////////////////////////////////////////////////////////KILL
		public function kill():void
		{
			if (currentProject) {
					killProject(currentProject) ;
				}
			view.kill() ;
			delete this ;
		}
	}
}