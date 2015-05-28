package SWFDialog.dialogs 
{
	
	/**
	 * ...
	 * @author ornorm
	 */
	public class Caller 
	{
		
		public var method:Function;
		public var scope:Object;
		public var count:int;
		
		public function Caller(_scope:Object, _method:Function=null) 
		{	
			scope = _scope;
			method = _method;
			count  = 0;
		}
		
        public function execute(recursive:Boolean=true):void
		{
            trace(count + ": execute");
            if(recursive && method) {
                recurse(arguments.callee);
            } else {
                trace("CALLS STOPPED");
				method.apply(scope, [arguments.callee]);
            }
        }

        protected function recurse(caller:Function):void
		{
            trace(count + ": recurse\n");
            count++;
			if (method)
				method.apply(scope, [caller]);
            caller(false);
        } 
		
	}
	
}