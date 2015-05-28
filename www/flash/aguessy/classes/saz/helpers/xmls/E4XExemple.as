package saz.helpers.xmls 
{
	import flash.display.Sprite ;
	import tests.E4XParser ;
	import saz.helpers.events.XMLEvent ;
	/**
	 * ...
	 * @author saz
	 */
	public class E4XExemple extends Sprite
	{
		
		public function E4XExemple() 
		{
			var xmlLoader:XMLLoader = new XMLLoader() ;
			xmlLoader.add(new XMLItem("VIDEOS", "xml/videos.xml"))
			addEventListener(XMLEvent.XMLLoaded, onXMLLoaded)
			xmlLoader.checkAll(this,xmlLoader.launch)
		}
		
		private function onXMLLoaded(e:XMLEvent):void 
		{
			if(e.XI.index == e.XI.listedItems)
			{
				//instanciate E4XParser Class
				var xmlXP:E4XParser = new E4XParser(e.XI.data)
				//settings
				xmlXP.recursive = true
				
				// 	will keep specified childs of the XML, and return an XMLList out of it,
				//	which will still be treatable afterwards
				
				//	let's look for the basic childrenNodes named "child", just like [xml.child] does
				//trace(xmlXP.search("child")) //will appear alltogether, since "recursive" is set to true
				//trace("==============================================================================")
				
				//	let's look for only the ones that has the attribute "mode"
				//trace(xmlXP.search("child", "mode"))
				//trace("==============================================================================")
				
				//	now let's specialize a bit more
				//trace(xmlXP.search("child", "mode").(@mode == "Perso"))
				//trace("==============================================================================")
				
				//	and decline as you wish with some further-specifying
				//trace(xmlXP.search("child", "mode").child.(hasOwnProperty("@mode") && @mode == "Perso"))
				//trace("==============================================================================")
			}
		}
	}
	
}