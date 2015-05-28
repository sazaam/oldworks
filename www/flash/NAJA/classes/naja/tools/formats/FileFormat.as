	/*
	 * Version 1.0.0
	 * Copyright BOA 2009
	 * 
	 * 
                                                                      SSSSSS
                                                                      SSSSSS
                                                                      SSSSSS
                                                                      3SSSSS



                    SSSSS                      ASSSSSS                                     SSSSSSA                 3ASSSSSS
        ASSSS    SSSSSSSSSSS               SSSSSSSSSSSSSSS            3SSSSS          3SSSSSSSSSSSSSS         S3SSSS SA3 3 SA3S
        ASSSS  SSSSSSSSSSSSSSS           SSSSSSSSSSSSSSSSSS           3SSSSS        SSSSSSSSSSSSSSSSSSS     SSS3SSSSSSSS3 SS S33
        ASSSS3SSSSSSA3SSSSSSSSS         SSSSSSS3    3SSSSSSS          3SSSSS        SSSSSSS     SSSSSSSS   A3ASS3SSSSSSSSASSSSSAS
        ASSSSSSSS        SSSSSS         SSS            SSSSSS         3SSSSS        SSS            SSSSS3 3SSSSSSSSSSSASA    33
        ASSSSSSS          SSSSSS                        SSSSS         3SSSSS                       SSSSSS 33SSSSSS3SSSSA
        ASSSSS             SSSSS                        SSSSS         3SSSSS                        SSSSSSS SSSSSSS3AS
        ASSSSS             SSSSS                        SSSSS3        3SSSSS                        SSSSSSSSSS 33SS3A3
        ASSSSS             SSSSS                        SSSSS3        3SSSSS                        SSSSS3SSSSSSSSSSSS
        ASSSSS             SSSSS               SSSSSSSSSSSSSS3        3SSSSS              3SSSSSSSSSSSSSSSASS SSSS
        ASSSSS             SSSSS           SSSSSSSSSSSSSSSSSS3        3SSSSS          3SSSSSSSSSSSSSSSSSSSSS3 SSSSSS3
        ASSSSS             SSSSS         SSSSSSSSSSSSSSSSSSSS3        3SSSSS        3SSSSSSSSSSSSSSSSSSSSSSS 3SSS 33
        ASSSSS             SSSSS        SSSSSS          SSSSS3        3SSSSS       SSSSSSS          SSSSSSSS   SSSS
        ASSSSS             SSSSS       SSSSSS           SSSSS3        3SSSSS       SSSSS            SSSSSS   3 SSS3
        ASSSSS             SSSSS       SSSSS            SSSSS3        3SSSSS      ASSSSS            SSSSSSA   A AA
        ASSSSS             SSSSS       SSSSS            SSSSS3        3SSSSS      SSSSSS            SSSSSS  ASA3S
        ASSSSS             SSSSS       SSSSS           SSSSSS3        3SSSSS      ASSSSS           SSSSSSS    3AS
        ASSSSS             SSSSS       SSSSSS        SSSSSSSS3        3SSSSS       SSSSSS        SSSSSSSSS    3A
        ASSSSS             SSSSS        SSSSSSSSSSSSSSSSSSSSS3        3SSSSS       ASSSSSSSSSSSSSSSSSSSSSS    S
        ASSSSS             SSSSS         SSSSSSSSSSSSSS  SSSS3        3SSSSS         SSSSSSSSSSSSSS 3SSSS
        3SSSS3             SSSSS           SSSSSSSSSS    SSSS         3SSSSS           SSSSSSSSSA    SSSS    A
                                                                      3SSSSS                             A  S
                                                                      ASSSSS                               3
                                                                      SSSSSA
                                                                      SSSSS
                                                                SSSSSSSSSSS
                                                                SSSSSSSSSS
                                                                SSSSSSSSA
                                                                   33
	 
	 * 
	 * 
	 *  
	 */

package naja.tools.formats 
{	
	import naja.model.control.regexp.BasicRegExp;
	/**
	 * The FileFormat class is part of the Naja Data API.
	 * 
     * @version 1.0.0
	 */
	
    public class FileFormat
    {
        public static const XML:String       						= "xml";
		public static const ZIP:String       						= "zip";
		public static const SVG:String       						= "svg";
		public static const HTML:String       					= "HTML";
		public static const HTM:String       					= "HTM";
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
        public static const EXTENDED_XML:String		= "extended_xml";
        public static const PDF:String       						= "pdf";
        public static const RTF:String      						= "rtf";
        public static const DOC:String 							= "doc";
        public static const TXT:String       						= "txt";
        public static const TEXT:String      					= "text";
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