package of.app.required.error 
{
	import flash.utils.getQualifiedClassName;
	import of.app.required.regexp.BasicRegExp;
	/**
	 * ...
	 * @author saz
	 */
	public class HierarchyError extends Error 
	{
		private var __currentPath:String;
		private var __path:String ;
		public function HierarchyError(msg:String, id:* = 0) 
		{
			super(msg, id) ;
		}
		public function toString():String {
			var str:String = String(Object(this).constructor) ;
			return str.replace(BasicRegExp.str_CLASS_TO_SIMPLECLASSNAME, '') +' #'+errorID +' : ' + message+ ' \n' ;
		}
		
		public function get currentPath():String { return __currentPath }
		public function set currentPath(value:String):void { __currentPath = value }
		
		public function get errorPath():String { return __errorPath }
		public function set errorPath(value:String):void { __errorPath = value }
	}

}