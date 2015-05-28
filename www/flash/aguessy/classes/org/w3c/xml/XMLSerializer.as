package org.w3c.xml
{
	import f6.io.ISerializable;
	
	public class XMLSerializer implements ISerializable
	{
		public function XMLSerializer()
		{
		}
		
		public function serializeToString(xml:XML):String
		{
			return xml.toXMLString();
		}
	}
}