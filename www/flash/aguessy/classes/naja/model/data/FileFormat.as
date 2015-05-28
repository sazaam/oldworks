package naja.model.data 
{
    public class FileFormat
    {
        public static const SWF:String       = "swf";
        public static const PNG:String       = "png";
        public static const JPG:String       = "jpg";
        public static const JPEG:String      = "jpeg";
        public static const GIF:String       = "gif";
        public static const BMP:String       = "bmp";
        public static const IMG:String       = "img";
        public static const FLV:String       = "flv";
        public static const F4V:String       = "f4v";
        public static const VID:String       = "vid";
        public static const XML:String       = "xml";
        public static const TXT:String       = "txt";
        public static const TEXT:String       = "text";
        public static const BINARY:String    = "binary";
        public static const VARIABLES:String = "variables";

        public function FileFormat():void
        {
            throw new ArgumentError("FileFormat couldn't be instanciated ...");
        }
		public static function test(url:String):String
		{
			var RE:RegExp = /.[\w\d]+$/i ;
			var ext:String = url.match(RE)[0] ;
			ext = ext.substr(1, ext.length) ;
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
				case TXT :
					ext = TEXT ;
				break;
			}
			return ext ;
		}
    }
}