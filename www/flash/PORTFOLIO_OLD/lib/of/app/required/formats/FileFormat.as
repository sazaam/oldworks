package of.app.required.formats 
{
	import of.app.required.regexp.BasicRegExp;
	
    public class FileFormat
    {
        public static const XML:String       						= "xml";
		public static const ZIP:String       						= "zip";
		public static const SVG:String       						= "svg";
		public static const HTML:String       					= "HTML";
		public static const HTM:String       						= "HTM";
        public static const SWF:String       						= "swf";
        public static const FONTS:String       					= "fonts";
        public static const PNG:String       						= "png";
        public static const JPG:String       						= "jpg";
        public static const JPEG:String      						= "jpeg";
        public static const GIF:String       						= "gif";
        public static const BMP:String       						= "bmp";
        public static const IMG:String       						= "img";
        public static const FLV:String       						= "flv";
        public static const F4V:String       						= "f4v";
        public static const VID:String       						= "vid";
        public static const MP3:String       						= "mp3";
        public static const EXTENDED_XML:String			= "extended_xml";
        public static const PDF:String       						= "pdf";
        public static const RTF:String      						= "rtf";
        public static const DOC:String 							= "doc";
        public static const TXT:String       						= "txt";
        public static const TEXT:String      						= "text";
        public static const BINARY:String    					= "binary";
        public static const VARIABLES:String 				= "variables";
//////////////////////////////////////////////////////// CTOR
		/**
		 * Constructs an XModel
		 */	
        public function FileFormat():void
        {
            throw new ArgumentError("FileFormat shouldn't be instanciated ...");
        }
		///////////////////////////////////////////////////////////////////////////////// TEST
		/**
		 * Tests on a String for extension type
		 * @param
		 * @return String - A String representating the type (for group of extensions)
		 * - 'vid' : stands for '.flv','.f4v', 
		 * - 'img' : stands for '.jpeg','.jpg','.gif','.bmp','.png',
		 * - 'xml' : stands for '.xml',
		 * - 'text' : stands for '.txt', '.doc', '.rtf'
		 */	
		public static function test(url:String):String
		{
			var ext:String = url.match(BasicRegExp.url_EXTENSION_RE)[0] ;
			switch(ext) {
				case FLV :
				case F4V :
					ext = VID ;
				break;
				case PNG :
				case JPG :
				case JPEG :
				case GIF :
				case BMP :
					ext = IMG ;
				break;
				case RTF :
				case DOC :
				case TXT :
					ext = TEXT ;
				break;
			}
			return ext ;
		}
    }
}