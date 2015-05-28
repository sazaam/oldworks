package modules.patterns.proxies
{
	/**
	 * ProxyHandler is the interface implemented by the handler of a proxy instance.
	 */
	public interface ProxyHandler
	{
		/**
		 * Each proxy instance has an associated invocation handler. When a method is
		 * invocked on a proxy instance, the method invocation is encoded and dispatched
		 * to the invoke method of its handler.
		 * @param scope Object -
		 * @param methodName * -
		 * @param ... args (default=Array) - 
		 * @return Object -
		 */
		function invoke(scope:Object, methodName:*, ... args:Array):*;
		
	}
}