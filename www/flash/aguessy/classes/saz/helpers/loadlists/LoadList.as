package saz.helpers.loadlists 
{
	
	
	/**
	* @author saz
	*/
	public class LoadList
	{
		public var List:Array
		
		public function LoadList(_n:Number = 0)
		{
			List = new Array(_n)
		}
		
		public function add(item:Object):void
		{
			List.push(item)
		}
	}
}