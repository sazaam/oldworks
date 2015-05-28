package cv.deposit 
{
	import cv.exec.Executer;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Deposit 
	{
		public static var XML_SECTIONS:XML ;
		public static var XMLS:Array ;
		public static var SWF:Array ;
		public static var FONTS:Array ;
		public static var IMG:Array ;
		
		///////////////////////////////////////////////////CLIPS
		public static var NavInside:Class ;
		public static var Logo:Class ;
		public static var cardA:Class ;
		public static var cardB:Class ;
		public static var FontAll:Class ;
		public static var FontSpecial:Class ;
		public static var projectColor:uint = 0xFFFFFF;
		
		private static var _embedContents:Boolean;
		//////////////////////////////////////////////////////////DEBUG
		public static function set embedContents(val:Boolean):void {
			_embedContents = val ;
		}
		///////////////////////////////////////////////////CTOR
		public function Deposit() 
		{
			
		}
		///////////////////////////////////////////////////INIT
		public function init():Deposit
		{
			if (!_embedContents) {
				NavInside = SWF["clips"].loaderInfo.applicationDomain.getDefinition('NavInside') as Class ;
				Logo = SWF["clips"].loaderInfo.applicationDomain.getDefinition('Logo') as Class ;
				FontAll = FONTS["ALL"] as Class ;
				FontSpecial = FONTS["SPECIAL"] as Class ;
			}else {
				NavInside = ApplicationDomain.currentDomain.getDefinition('NavInside') as Class ;
				Logo = ApplicationDomain.currentDomain.getDefinition('Logo') as Class ;
				cardA = ApplicationDomain.currentDomain.getDefinition('frontCard') as Class ;
				cardB = ApplicationDomain.currentDomain.getDefinition('backCard') as Class ;
				FontAll = getDefinitionByName("ALL") as Class ;
				FontSpecial = getDefinitionByName("SPECIAL") as Class ;
			}
			
			return this ;
		}
	}
	
}