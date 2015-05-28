package of.app.required.dialog 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public class JSCommand 
	{
		
		public function JSCommand(name_:String, comand_:XML) 
		{
			_name = name_;
			_comand = comand_;
		}
		
		public function get command():XML { return _comand; }
		
		public function set command(value:XML):void 
		{
			_comand = value;
		}
		
		public function get name():String { return _name; }
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		private var _comand:XML;
		private var _name:String;

		
	}
	
}