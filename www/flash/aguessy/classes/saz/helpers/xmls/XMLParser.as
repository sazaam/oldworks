package framework.required.xmls 
{
	import saz.controllers.events.xml.*
	
	
	/**
	* @author saz
	*/
	public class XMLParser extends XMLLoader
	{
		public static var DAYZ:Array = []
		private var DAYZ_VID:Array
		
		//	Parsing
		public function parseXML(e:XMLEvent):void
		{
			var _xml:XML = e.XMLData as XML
			var i:int
			for each(var content:XML in _xml.day)
			{
				DAYZ_VID = []
				var j:int = 0
				
				for each(var contVid:XML in content.video)
				{
					DAYZ_VID[j] = contVid
					DAYZ_VID[j].url = contVid.@url
					j++
				}
				DAYZ[i]=DAYZ_VID
				DAYZ[i].name = content.@name
				DAYZ[i].month = content.@month
				DAYZ[i].digit = content.@digit
				DAYZ[i].available = content.@available
				//trace("____________________________________")
				//trace(DAYZ_VID[0].url)
				i++
			}
			//trace(DAYZ[0][0].url)
			//e.XMLCallBack(e)
		}
	}
}