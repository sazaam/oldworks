package modules.patterns.proxies
{
	
	/**
	 * @author aime@tmatik.net
	 */
	public class Handler implements ProxyHandler
	{
		/**
		 * 
		 * @param	aspect
		 */
		public function Handler(aspect:Object=null) 
		{
			_aspect = aspect || [];
			super();
		}
		
		/**
		 * 
		 * @param	target
		 * @return
		 */
		public static function getInvokerInstance(target:Object=null):DynamicProxy
		{
			return DynamicProxy.getProxyInstance(new Handler(target));
		}
		
		/**
		 * 
		 * @param	proxy
		 * @param	methodName
		 * @param	... args
		 * @return
		 */
		public function invoke(scope:Object, methodName:*, ... args):* 
		{
			return aspect[methodName].apply(scope, [].concat(args));
		}
		
		public function get aspect():Object { return _aspect; }
		
		public function set aspect(value:Object):void 
		{
			_aspect = value;
		}		
		
		private var _aspect:Object;
		
	}
	
}