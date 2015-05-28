package modules.foundation.events
{
	import flash.events.Event;

	/**
	 * Simple Event wrapper
	 * 
	 * @author biendo@fullsix.com
	 */
	public class ModuleListener extends ModuleEvent
	{
		/**
		 * Creates an Event object to pass as a parameter to event listeners.
		 * @param	type String - The type of the event, accessible as Event.type.
		 * @param	listener Function (default = null) - The listener function that processes the event. This function must accept an event 
		 * 			object as its only parameter and must return nothing. 
		 * @param	useCapture Boolean (default = false) - Determines whether the listener works in the capture phase or the target 
		 * 			and bubbling phases. If useCapture is set to true, the listener processes the event only during the capture 
		 * 			phase and not in the target or bubbling phase. If useCapture is false, the listener processes the event only 
		 * 			during the target or bubbling phase. To listen for the event in all three phases, call addEventListener() twice, 
		 * 			once with useCapture set to true, then again with useCapture set to false. 
		 * @param	priority int (default = 0) - The priority level of the event listener. Priorities are designated by a 32-bit 
		 * 			integer. The higher the number, the higher the priority. All listeners with priority n are processed before 
		 * 			listeners of priority n-1. If two or more listeners share the same priority, they are processed in the order 
		 * 			in which they were added. The default priority is 0. 
		 * @param	useWeakReference
		 * @param	bubbles Boolean (default = false) - Determines whether the Event object participates in the bubbling stage of 
		 * 			the event flow. The default value is false.
		 * @param	cancelable Boolean (default = false) - Determines whether the Event object can be canceled. The default values is false. 
		 * @param	source * (default = null) - Optianal object to pass in parameters
		 */
		public function ModuleListener(type:String, listener:Function=null, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false, source:*=null)
		{
			_listener = listener;
			_useCapture = useCapture;
			_priority = priority;
			_useWeakReference = useWeakReference;
			super(type, bubbles, cancelable, source);
		}	
		
		/**
		 * Duplicates an instance of an Event subclass.
		 * Returns a new Event object that is a copy of the original instance of the Event object. You do not normally call clone(); 
		 * the EventDispatcher class calls it automatically when you redispatch an eventthat is, when you call dispatchEvent(event) 
		 * from a handler that is handling event.
		 * @return Event - Return a clone of this EventListener
		 */
		public override function clone():Event 
		{ 
			return new ModuleListener(type, listener, useCapture, priority, useWeakReference, bubbles, cancelable, source);
		} 
		
		/**
		 * 
		 * @param	o Object - 
		 * @return
		 */
		public function equals(o:Object):Boolean
		{
			if (o == this)
				return true;
    		if (!o is ModuleListener)
    			return false;
			var evt:ModuleListener, p:String;
			evt = ModuleListener(o);
			return  listener == evt.listener && type == evt.type && priority == evt.priority && useCapture == evt.useCapture && useWeakReference == evt.useWeakReference && source == evt.source;			
		}
		
		/**
		 * Clean references variables in the specified EventListener
		 */
		public function finalize():void
		{
			listener = null;
			useCapture = false;
			priority = 0;
			source = null;
			useWeakReference = false;
		}
		
		/**
		 * Return the representation string of the specified EventListener
		 * @return String - representation string of this EventListener
		 */
		override public function toString():String
		{
			return 	formatToString("type", "listener", "priority", "source", "useCapture", "useWeakReference", "bubbles", "cancelable", "source");
		}
		
		////////////////////////////////////////// public properties /////////////////////////////////////////
		
		
		public function get listener():Function
		{
			return _listener;
		}
		
		public function set listener(value:Function):void
		{
			_listener = value;
		}
		
		public function get priority():int
		{
			return _priority;
		}
		
		public function set priority(value:int):void
		{
			_priority = value;
		}
		
		public function get useCapture():Boolean
		{
			return _useCapture;
		}
		
		public function set useCapture(value:Boolean):void
		{
			_useCapture = value;
		}
		
		public function get useWeakReference():Boolean
		{
			return _useWeakReference;
		}
		
		public function set useWeakReference(value:Boolean):void
		{
			_useWeakReference = value;
		}

		////////////////////////////////////////// privates properties /////////////////////////////////////////

		private var _listener:Function;
		private var _priority:int;
		private var _useCapture:Boolean;
		private var _useWeakReference:Boolean;		
	}
}