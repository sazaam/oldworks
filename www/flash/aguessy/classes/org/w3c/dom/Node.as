package org.w3c.dom
{
	import f6.core.Core;

	public dynamic class Node extends Core
	{
		public static const ELEMENT_NODE:int = 1;
		public static const ATTRIBUTE_NODE:int = 2;
		public static const TEXT_NODE:int = 3;
		public static const CDATA_SECTION_NODE:int = 4;
		public static const COMMENT_NODE:int = 8;
		public static const DOCUMENT_NODE:int = 9;
		public static const DOCUMENT_TYPE_NODE:int = 10;
		public static const DOCUMENT_FRAGMENT_NODE:int = 11;
		
		private var _nodeType:int;
				
		public function Node()
		{
			super();
		}
		/*
		public function get nodeType():int
		{
			return _nodeType;	
		} 
		
		public function set nodeType(value:int):void
		{
			_nodeType = value;	
		}
				
		public function toXml():XML
		{
			return null;
		}
		*/
	}
}