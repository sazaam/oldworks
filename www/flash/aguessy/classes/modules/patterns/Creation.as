package modules.patterns 
{
	import modules.patterns.Singleton;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Creation extends Singleton
	{
		/**
		 * 
		 * @param	lock
		 */
		public function Creation(lock:Function=null) 
		{
			super(lock);	
		}
		
		
		
		/**
		 * 
		 * @return
		 */
		public static function getInstance():Creation
		{
			return Singleton.getInstance(Creation, arguments.callee) as Creation;
		}
	}
	
}