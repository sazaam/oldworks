package sketchbook.data
{
	import flash.net.URLRequestMethod;
	import flash.text.TextDisplayMode;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.net.URLLoaderDataFormat;
	import flash.display.StageQuality;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	/**
	 * 一般的な定数へのショートカット用クラスです(将来的に削除される可能性があります)。
	 */
	public class C
	{
		//Stage
		public static const STAGE_QUALITY_BEST:String = StageQuality.BEST
		public static const STAGE_QUALITY_HIGH:String = StageQuality.HIGH
		public static const STAGE_QUALITY_LOW:String = StageQuality.LOW
		public static const STAGE_QUALITY_MEDIUM:String = StageQuality.MEDIUM
		
		//StageAlign
		public static const STAGE_ALIGN_BOTTOM:String = StageAlign.BOTTOM
		public static const STAGE_ALIGN_BOTTOM_LEFT:String = StageAlign.BOTTOM_LEFT
		public static const STAGE_ALIGN_BOTTOM_RIGHT:String = StageAlign.BOTTOM_RIGHT
		public static const STAGE_ALIGN_LEFT:String = StageAlign.LEFT
		public static const STAGE_ALIGN_RIGHT:String = StageAlign.RIGHT
		public static const STAGE_ALIGN_TOP:String = StageAlign.TOP
		public static const STAGE_ALIGN_TOP_LEFT:String = StageAlign.TOP_LEFT
		public static const STAGE_ALIGN_TOP_RIGHT:String = StageAlign.TOP_RIGHT
		
		//StageScaleMode
		public static const STAGE_SCALE_MODE_NO_BORDER:String = StageScaleMode.NO_BORDER
		public static const STAGE_SCALE_MODE_EXACT_FIT:String = StageScaleMode.EXACT_FIT
		public static const STAGE_SCALE_MODE_NO_SCALE:String =  StageScaleMode.NO_SCALE
		public static const STAGE_SCALE_MODE_SHOW_ALL:String = StageScaleMode.SHOW_ALL
		
		//TextFieldAutoSize
		public static const TEXT_FIELD_AUTOSIZE_CENTER:String = TextFieldAutoSize.CENTER
		public static const TEXT_FIELD_AUTOSIZE_LEFT:String = TextFieldAutoSize.LEFT
		public static const TEXT_FIELD_AUTOSIZE_NONE:String = TextFieldAutoSize.NONE
		public static const TEXT_FIELD_AUTOSIZE_RIGHT:String = TextFieldAutoSize.RIGHT
		
		//TextFieldType
		public static const TEXT_FIELD_TYPE_DYNAMIC:String = TextFieldType.DYNAMIC
		public static const TEXT_FIELD_TYPE_INPUT:String = TextFieldType.INPUT
		
		//TextFormatAlign
		public static const TEXT_FORMT_ALIGN_CENTER:String = TextFormatAlign.CENTER
		public static const TEXT_FORMT_ALIGN_JUSTIFY:String = TextFormatAlign.JUSTIFY
		public static const TEXT_FORMT_ALIGN_LEFT:String = TextFormatAlign.LEFT
		public static const TEXT_FORMT_ALIGN_RIGHT:String = TextFormatAlign.RIGHT
		
		//URLLoaderDataFormat
		public static const URL_LOADER_DATA_FORMAT_BINARY:String = URLLoaderDataFormat.BINARY
		public static const URL_LOADER_DATA_FORMAT_TEXT:String = URLLoaderDataFormat.TEXT
		public static const URL_LOADER_DATA_FORMAT_VARIABLES:String = URLLoaderDataFormat.VARIABLES
		
		//URLRequestMethod
		public static const URL_REQUEST_METHOD_GET:String = URLRequestMethod.GET
		public static const URL_REQUEST_METHOD_POST:String = URLRequestMethod.POST
	}
}