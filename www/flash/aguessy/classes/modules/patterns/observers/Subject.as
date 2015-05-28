package modules.patterns.observers
{
	import modules.foundation.ADT;
	import modules.patterns.proxies.DynamicProxy;
	
	public class Subject extends Object implements Observable
	{
		/**
		 * Construct an Observable with zero Observers.
		 */
		public function Subject()
		{
			super();
			observers = DynamicProxy.getProxyInstance();//create default proxy with array behvior
			//lock abstract constructor
			ADT.assertAbstractTypeError(this, Subject);
		}
		
		/**
		 * Adds an observer to the set of observers for this object, provided that it 
		 * is not the same as some observer already in the set.
		 * @param o Observer - An observer to be added.
		 */
		public function addObserver(o:Observer):void
		{
			if (observers.indexOf(o) != -1)
				return;
			observers.push(o);
		}
		
		/**
		 * Indicates that this object has no longer changed, or that it has already 
		 * notified all of its observers of its most recent change, so that the 
		 * hasChanged method will now return false.
		 */
		public function clearChanged():void
		{
			changes = false;
		}
		
		/**
		 * Returns the number of observers of this Observable object.
		 */
		public function countObservers():int
		{
			return observers.length;
		}
		
		/**
		 * Deletes an observer from the set of observers of this object.
		 * @param o Observer - 
		 */
		public function removeObserver(o:Observer):void
		{
			var l:int = countObservers();
			while(l--) {
				if (observers[l] == o) {
					observers.slice(l, 1);
					return;
				}
			}
		}
		
		/**
		 *  Clears the observer list so that this object no longer has any observers.
		 */
		public function deleteObservers():void
		{
			if (observers != null)
				observers = null;
			observers = DynamicProxy.getProxyInstance();
		}
		
		/**
		 * Tests if this object has changed.
		 */
		public function hasChanged():Boolean
		{
			return changes;
		}
		
		/**
		 *  If this object has changed, as indicated by the hasChanged method, then 
		 * notify all of its observers and then call the clearChanged method to 
		 * indicate that this object has no longer changed.
		 */
		public function notifyObservers(arg:Object=null):void
		{
			if (hasChanged()) {
				observers.forEach(function(el:*, i:int, arr:Arr):void {
					Observer(el).update.apply(this, [arg]);
				});
			}
			clearChanged();
		} 
		
		/**
		 * Marks this Observable object as having been changed; the hasChanged method 
		 * will now return true.
		 */
		public function setChanged():void
		{
			changes = true;
		}
		
		
		protected var changes:Boolean;
		protected var observers:DynamicProxy;
	}
}