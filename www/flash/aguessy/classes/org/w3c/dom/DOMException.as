package org.w3c.dom
{
	import f6.lang.RuntimeException;

	public class DOMException extends RuntimeException
	{
		public function DOMException(message:String=null, id:int=0)
		{
			super(message || "", id);
		}
		
	}
}