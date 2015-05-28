package of.app.required.regexp 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public class BasicRegExp 
	{
		static public var ext_STRICT_RE:RegExp = /((jp(e)?g)|png|bmp|gif|xml|swf|zip|svg|pdf|fl(v|4)|txt|doc|rtf)$/i ;
		static public var ext_IMG_RE:RegExp = /((jp(e)?g)|png|bmp|gif)/;
		static public var ext_VID_RE:RegExp = /(fl(4|v))/ ;
		static public var ext_TEXT_RE:RegExp = /(txt|doc|rtf)/ ;
		static public var ext_PDF_RE:RegExp = /(pdf)/ ;
		static public var ext_XML_RE:RegExp = /(xml)/ ;
		static public var ext_ZIP_RE:RegExp = /(zip)/ ;
		static public var ext_MP3_RE:RegExp = /(mp3)/ ;
		static public var ext_EXTENDED_XML_RE:RegExp = /(htm(l)?|php|xml|svg)/ ;
		
		static public var url_VARIABLE_PATH_MULTI:RegExp = /\<([\w\d]+)\>/gi ;
		
		static public var url_PARAMS_RE:RegExp = /\?.*$/ ;
		static public var url_LEVELS_RE:RegExp = /\.\.?\// ;
		static public var url_EXTENSION_RE:RegExp = /.[\w\d]+$/i ;
		static public var url_ID_FROM_URL_RE:RegExp = /(?<=\/)[\w]*(?=[.])/i ;
		static public var url_KEEP_FILENAME:RegExp = /(?<=\/)[^\/]+$/i ;
		static public var url_KEEP_DIRECTORY:RegExp = /^[\w\d\/]+\//i ;
		static public var url_IS_FOLDER_SLASHED:RegExp = /\/$/i ;
		static public var url_CLEAN_URL:RegExp = /^\/|\/$/g ;
		static public var url_SPLITTER:RegExp = /[\d\w]+[^\/]/g ;
		
		static public var str_NAJA_PROTECTED_TO_ID:RegExp = /(?<=__).+(?=__)/i ;
	}
}