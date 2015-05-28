package saz.helpers.xmls 
{
	import flash.display.*
	import flash.events.*
	import saz.helpers.events.*
	import saz.helpers.loadlists.LoadList
	
	/**
	* @author saz
	*/
	public class XMLLoader
	{
		private var xmlCD:XMLCompleteDispatcher
		public var loadList:LoadList
		private static var INDEX:int = 0
		private var callBack:Function
		private var specialCallBack:Function
		private var Dispatcher:EventDispatcher
		private var fakeToKill:Object
		private var bytesTotal:int = 0
		
		public function XMLLoader()
		{
			loadList = new LoadList()
		}
		
		public function add(_xmlItem:XMLItem):void 
		{
			loadList.add(_xmlItem)
		}
		
		private function detectBytesTotal(e:XMLProgressEvent):void 
		{
			if(fakeToKill == e.currentTarget) return 
			fakeToKill = e.currentTarget
			e.XI.currentBytesIn = bytesTotal
			bytesTotal += e.bytesTotal
			if (e.XI.index == e.XI.listedItems) 
			{
				callBack()
			}
		}
		public function checkAll(_tg:EventDispatcher,_callBack:Function):void 
		{
			callBack = _callBack
			Dispatcher = _tg as EventDispatcher
			var scope:XMLLoader = this
			var xI:XMLItem
			var list:Array = loadList.List
			var length:int = list.length
			for (var i:int; i < length; i++ )
			{
				//	fake loading request
				xI = list[i] as XMLItem
				xI.index = i
				xI.listedItems = length-1
				var fakeCD:XMLCompleteDispatcher = new XMLCompleteDispatcher()
				fakeCD.addEventListener(XMLProgressEvent.XMLProgress, detectBytesTotal)
				fakeCD.loadXML(xI)
				//	
			}
		}
		
		public function launch(e:* = null):void
		{
			var xI:XMLItem
			var scope:XMLLoader = this
			var CD:XMLCompleteDispatcher
			var list:Array = loadList.List
			var length:int = list.length
			for (var i:int; i < length; i++ )
			{
				xI = list[i] as XMLItem
				
				xI.loadList = loadList
				xI.bytesTotalList = bytesTotal
				CD = xI.CompleteDispatcher = new XMLCompleteDispatcher()
				CD.addEventListener(XMLEvent.XMLLoaded, onXMLComplete)
				CD.addEventListener(XMLProgressEvent.XMLProgress, onXMLProgress)
			}
			load(loadList.List[0])
		}
		
		private function onXMLProgress(e:XMLProgressEvent):void 
		{
			Dispatcher.dispatchEvent(new XMLProgressEvent(XMLProgressEvent.XMLProgress,e.XI))
		}
		
		public function load(_xmlItem:XMLItem):void
		{
			_xmlItem.CompleteDispatcher.loadXML(_xmlItem)
		}
		
		private function onXMLComplete(e:XMLEvent):void 
		{
			INDEX++
			Dispatcher.dispatchEvent(new XMLEvent(XMLEvent.XMLLoaded,e.XI))
			if(loadList.List[INDEX] is XMLItem) load(loadList.List[INDEX] as XMLItem)
		}
	}
}