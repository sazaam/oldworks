package saz.helpers.xmls 
{
	import saz.helpers.events.XMLCompleteDispatcher
	import saz.helpers.loadlists.LoadList
	
	/**
	* @author saz
	*/
	public class XMLItem 
	{
		public var ref:String
		public var url:String
		public var bytesLoaded:int
		public var bytesTotal:int
		public var data:XML
		public var listedItems:int
		public var loadList:LoadList
		public var bytesTotalList:int
		public var currentBytesIn:int
		public var index:int
		public var CompleteDispatcher:XMLCompleteDispatcher
		
		public function XMLItem(_ref:String,_url:String)
		{
			ref = _ref
			url = _url
		}
		
	}
}