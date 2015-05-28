package org.w3c.xml
{
	import f6.lang.reflect.Type;
	import org.w3c.dom.Node;
		
	public class XMLParser
	{
		public static const EVERY:String = "every";
		public static const FILTER:String = "filter";
		public static const FOREACH:String = "forEach";
		public static const FORIN:String = "forIn";
		public static const MAP:String = "map";
		public static const SOME:String = "some";
		
		public static function parse(input:Object, output:Object=null):XMLParser
		{
			var parser:XMLParser = new XMLParser(input, output);
			parser.output = treat(parser.input, parser.output);
			return parser;
		}
		
		public static function traverse(node:XML, datas:Object):Object
		{
			var list:XMLList = node.descendants();
			var l:int = list.length();
			var xml:XML, i:int=0;
			if (datas.children == null)
				datas.children = [];
			for (; i < l; i++ ) {
				xml = list[i] as XML;
				datas.children[i] = Type.getInstance(Type.getFullyQualifiedClassName(datas));
				datas.children[i] = treat(xml, datas.children[i]);
			}
			return datas;
		}
		
		public static function treat(node:XML, datas:Object):Object
		{
			var xml:XML, name:String;
			for each(xml in node) {
				name = xml.localName();
				if (name != null) {
					datas["__localName__"] = name;				
					datas = walk(xml, datas);
					if (xml.children() != null)
						datas = traverse(xml, datas);
				}
			}
			return datas;			
		}
		
		public static function walk(node:XML, datas:Object):Object
		{
			var list:XMLList, l:int, i:int=0, xml:XML;
			list = node.attributes();
			if (list != null) {
				l = list.length();				
				for (; i < l; i++ ) {
					xml = list[i] as XML;
					datas[xml.name().toString()] = xml;	
				}	
			}
			return datas;
		}
		
		private var _input:XML;
		private var _output:Object;
		
		public function XMLParser(input:Object, output:Object=null)
		{
			super();
			if (input is String)
				_input = new XML(input as String);
			else if (input is XML)
				_input = input as XML;
			else 
				throw new TypeError();
			_output = output || new Node();
		}
		
		public function iterate(filter:String, callback:Function, scope:Object=null, node:Object=null):void
		{			
			if (node == null)
				node = output;
			if (filter == FORIN) {
				var p:String, index:int=0;
				for (p in node) {
					callback(p, index, node);
					index++;
				}
			} else {
				if (node.children != null) {
					var array:Array = node.children as Array;	
					switch(filter) {
						case EVERY:
							array.every(callback, scope);
						break;
						case FILTER:
							array.filter(callback, scope);
						break;
						case FOREACH:
							array.forEach(callback, scope);
						break;
						case MAP:
							array.map(callback, scope);
						break;
						case SOME:
							array.some(callback, scope);
						break;
					}
				}
			}
		}
		
		//analysis
		
		public function get input():XML
		{
			return _input;
		}
		
		public function set input(value:XML):void
		{
			_input = value;
		}
		
		public function get output():Object 
		{ 
			return _output; 
		}
		
		public function set output(value:Object):void 
		{
			_output = value;
		}
	}
}