package org.libspark.disassemble.abc
{
	public class NS
	{
		public function NS(type:String, uri:String)
		{
			_type = type;
			_uri = uri;
		}
		
		private var _type:String;
		private var _uri:String;
		
		public function get type():String
		{
			return _type;
		}
		
		public function get uri():String
		{
			return _uri;
		}
		
		public function toString():String
		{
			return (type != null && type.length > 0 ? type + '::' : '') + uri;
		}
	}
}