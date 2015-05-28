package naja.model.data.loaders 
{
	import flash.events.Event;
	import flash.events.EventDispatcher ;
	import flash.events.ProgressEvent;
	import flash.utils.getQualifiedClassName;
	import mvc.structure.data.I.IItem;
	import mvc.structure.data.items.Item;
	import mvc.structure.data.lists.List;
	import naja.model.data.loaders.E.LoadEvent;
	import naja.model.data.loaders.E.LoadProgressEvent;
	import naja.model.data.loaders.I.IXLoader;

	/**
	 * ...
	 * @author saz
	 *///////////////////////////////////////////////////////////////////////////////////////USE
	
	 /*
var xLoader:XLoader = new XLoader() ;
xLoader.loader.addEventListener(ProgressEvent.PROGRESS, onXMLProgress) ;
xLoader.loader.addEventListener(Event.COMPLETE, onXMLComplete) ;
xLoader.add(new MultiLoaderRequest("xml/datas/data_sections.xml", "data_sections")) ;
xLoader.add(new MultiLoaderRequest("xml/videos.xml", "videos")) ;
xLoader.loadAll() ;
	   */
	 
	public class XLoaderBis extends EventDispatcher implements IXLoader
	{
//////////////////////////////////////////////////////////////////////////////////////VARS
		public var list:List;
		private var _loader:MultiLoader;
		public var onSpecialComplete:Function ;
//////////////////////////////////////////////////////////////////////////////////////CTOR
		public function XLoaderBis() 
		{
			list = new List();
			_loader = new MultiLoader() ;
			//_loader.waitAllOpened = false ;
		}
		public function clearSpecialEvents():void
		{
			if(onSpecialComplete is Function) loader.removeEventListener(Event.COMPLETE, onSpecialComplete) ;
		}
//////////////////////////////////////////////////////////////////////////////////////ADD & REMOVE
		public function add(_item:Object):IItem
		{
			loader.addRequest(MultiLoaderRequest(_item)) ;
			return list.add(_item) ;
		}
		public function remove(_id:Object):IItem
		{
			loader.removeRequestById(String(_id)) ;
			return list.remove(_id) ;
		}
//////////////////////////////////////////////////////////////////////////////////////LOAD
		public function loadAll():void
		{
			for (var i:int = 0 ; i < list.list.length ;i++ )
            {
				var request:MultiLoaderRequest = list.list[i].item ;
				request.index = i ;
				request.addEventListener(ProgressEvent.PROGRESS,function(e:ProgressEvent) {
					var loadProgress:LoadProgressEvent = new LoadProgressEvent(MultiLoaderRequest(e.target), false, false,MultiLoaderRequest(e.target).index) ;
					loadProgress.bytesLoaded = e.bytesLoaded ;
					loadProgress.bytesTotal = e.bytesTotal ;
					dispatchEvent(loadProgress) ;
				}) ;
				request.addEventListener(Event.COMPLETE, function(e:Event) {
					var loadComp:LoadEvent = new LoadEvent(MultiLoaderRequest(e.target), LoadEvent.COMPLETE, false, false,MultiLoaderRequest(e.target).index) ;
					loadComp.content = loader.getResponseById(e.target.id);
					e.target.removeEventListener(ProgressEvent.PROGRESS,onProgress) ;
					e.target.removeEventListener(Event.COMPLETE, onComplete) ;
					clearSpecialEvents() ;
					dispatchEvent(loadComp) ;
				}) ;
            }
			if(onSpecialComplete is Function) loader.addEventListener(Event.COMPLETE, onSpecialComplete) ;
			loader.load();
		}
		//////////////////////////////////////////////////////////////////////////////////////PROGRESS & COMPLETE
		private function onComplete(e:Event):void 
		{
			
		}
		private function onProgress(e:ProgressEvent):void 
		{
			
		}
		
		public function get loader():MultiLoader { return _loader; }
	}
}