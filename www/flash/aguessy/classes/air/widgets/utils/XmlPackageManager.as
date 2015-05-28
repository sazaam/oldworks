package air.widgets.utils  
{
	import com.labanquepostale.widget.utils.WriteFile;
	import com.carlcalderon.arthropod.Debug
	import com.labanquepostale.widget.sections.AgendaSection;
	import flash.xml.XMLDocument;

	public class XmlPackageManager 
	{
		public static function getEventTemplate():XML
		{
			return new XML("<event year='' month='' startdate='' enddate='' object='' subject=''/>");			
		}
		
		private var agenda:AgendaSection;
		private var defaultFileName:String;
		private var writer:WriteFile;
		
		private var _xmlFile:XML;
		private var _file:String;
		//<event year='' month='' startdate='' endDate='' object='' coments=''/>
		static private var XML_BASE:String = "<?xml version=\"1.0\" encoding=\"utf-8\" ?><events></events>"
		
		public function XmlPackageManager() 
		{

		}
		

		
		public function init(_tg:AgendaSection,_date:Date = null):XmlPackageManager
		{
			agenda = _tg as AgendaSection
			defaultFileName = dayToString()
			//var fileName:String = "evenements_" + (agenda.calendar.dynamicDate.getMonth() + 1) + "_" + agenda.calendar.dynamicDate.getFullYear();
			writeFile(requestFile(defaultFileName));
				
			return this
		}
		
		private function requestFile(name:String):Boolean
		{
			writer = new WriteFile();
			return writer.lecture(name) != "empty"
		}
		
		public function writeFile(cond:Boolean):void
		{
			var contenu:String
			if (!cond) {
				contenu = defineContenu()
				writer.ecriture(defaultFileName, contenu)
			}
			else {
				contenu = writer.lecture(defaultFileName)
			}
			_file = contenu;
			_xmlFile = new XML(contenu);
			
		}
		
		public function rewrite(_xml:XML):void
		{
			//XML.ignoreWhitespace = true
			//xmlRoot.events.appendChild(_xml)
			var doc:XMLDocument = new XMLDocument(_xml.toString())
			XML.prettyPrinting = false
			var s:String = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>";
			s += _xml.toString();
			writer.ecriture(defaultFileName, s)
		}
		
		private function defineContenu():String
		{
			return XML_BASE 
		}
		
		private function dayToString():String
		{
			return "string" 
		}
		
		public function get xmlFile():XML { return _xmlFile; }
		
		public function get file():String { return _file; }

		
	}
	
}