package org.libspark.disassemble.abc
{
	public class MultiName
	{
		public function MultiName(name:String, namespaces:Array, typeParams:Array = null)
		{
			_name = name;
			_namespaces = namespaces;
			_typeParams = typeParams || [];
		}
		
		private var _name:String;
		private var _namespaces:Array;
		private var _typeParams:Array;
		
		public function get name():String
		{
			return _name;
		}
		
		public function get namespace():NS
		{
			return _namespaces[0];
		}
		
		public function get namespaces():Array
		{
			return _namespaces;
		}
		
		public function get typeParameters():Array
		{
			return _typeParams;
		}
		
		public function toString():String
		{
			var result:String = _namespaces.join(',');
			if (result != '') {
				result += '::';
			}
			result += _name;
			if (typeParameters.length > 0) {
				result += '.<' + typeParameters.join(',') + '>';
			}
			return result;
		}
	}
}