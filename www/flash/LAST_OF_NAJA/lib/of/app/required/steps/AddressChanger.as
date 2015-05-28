package of.app.required.steps 
{
	import of.app.required.steps.AddressChanger;
	/**
	 * ...
	 * @author saz
	 */
	public class AddressChanger 
	{
		protected var __home:String ;
		protected var __hierarchy:Hierarchy ;
		protected var __value:String ;
		public function AddressChanger() 
		{
			
		}
		
		public function setHome(path:String):void 
		{ __home  = path }
		public function setHierarchy(_hierarchy:Hierarchy):void 
		{
			__hierarchy = _hierarchy ;
		}
		public function get home():String 
		{ return __home }
		public function get hierarchy():Hierarchy
		{ return __hierarchy }
		public function get value():String 
		{ return __value }
		public function set value(newVal:String):void
		{ 
			//	probably 
			__value = newVal  ;
			//	later
			hierarchy.redistribute(__value) ;
		}
		
	}

}