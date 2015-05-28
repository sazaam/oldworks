package of.app.required.steps 
{
	import flash.events.EventDispatcher;
	import of.app.required.steps.AddressChanger;
	import of.app.XConsole;
	/**
	 * ...
	 * @author saz
	 */
	public class AddressChanger extends EventDispatcher
	{
		internal var __futurePath:String;
		protected var __currentPath:String;
		protected var __home:String ;
		protected var __hierarchy:Hierarchy ;
		protected var __value:String ;
		public function AddressChanger() 
		{
			
		}
		
		public function setHome(path:String):void { __home  = path }
		public function setHierarchy(_hierarchy:Hierarchy):void { __hierarchy = _hierarchy }
		public function get home():String { return __home }
		public function get hierarchy():Hierarchy{ return __hierarchy }
		public function get value():String {
			
			XConsole.log(__value[__value.length-1])
			return __value[__value.length-1] == '/'? __value.substring(-1) : __value }
		public function set value(newVal:String):void
		{ __value = newVal ; hierarchy.redistribute(__value) }
		public function get currentPath():String { return __currentPath }
		public function set currentPath(value:String):void { __currentPath = value }
		public function get futurePath():String { return __futurePath }
	}

}