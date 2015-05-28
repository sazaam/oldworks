/**
 * @author biendo@fullsix.com 
 */
package modules.foundation.events
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import modules.foundation.io.Serializable;
	import modules.foundation.Equal;
	import modules.foundation.Type;	
	import modules.patterns.Prototype;
	
	public class ModuleEventDispatcher implements IEventDispatcher, Prototype
	{
		/**
		 * Dispatched when a dispatcher is added from this ModuleEvent
		 * @eventType	modules.events.ModuleEvent
		 */
		[Event(name = "event_added", type = "modules.events.ModuleEvent")]
		
		/**
		 * Dispatched when a dispatcher is added from this ModuleEvent
		 * @eventType	modules.events.ModuleEvent
		 */
		[Event(name = "event_added", type = "modules.events.ModuleEvent")]
		
		/**
		 * 
		 * @param	dispatcher
		 */
		public function ModuleEventDispatcher(dispatcher:IEventDispatcher=null)
		{
			history = [];
			target = dispatcher || new EventDispatcher(this);
		}
		
		/**
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			target.addEventListener(type, listener, useCapture, priority, useWeakReference);			
			history.push(new ModuleListener(type, listener, useCapture, priority, useWeakReference, false, false, target));
			target.dispatchEvent(new ModuleEvent(ModuleEvent.EVENT_ADDED, false, true, history[history.length-1]));
		}
		
		/**
		 * 
		 * @param	source
		 * @return
		 */
		public function clone(source:Object=null):Object
		{
			if (source != null)
				return new ModuleEventDispatcher(source as IEventDispatcher);
			return Type.clone(this);
		}
		
		/**
		 * 
		 * @param	event
		 * @return
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return target.dispatchEvent(event);
		}
		
		/**
		 * 
		 * @param	T
		 * @return
		 */
		public function equals(T:Object):Boolean
		{
			if (T == this) 
				return true;
			if (!(T is ModuleEventDispatcher))
				return false;
			var module:ModuleEventDispatcher = T as ModuleEventDispatcher;
			return module.history == history && (target is Equal ? Equal(target).equals(module.target) : target == module.target) && module.hashCode == hashCode;
		}
		
		public function finalize(source:Object = null):void
		{
			
		}
		
		/**
		 * 
		 * @return
		 */
		public function getClass():Type
		{
			return Type.getDefinition(this);
		}
		
		/**
		 * 
		 * @param	type
		 * @return
		 */
		public function hasEventListener(type:String):Boolean
		{
			return target.hasEventListener(type);
		}
		
		/**
		 * 
		 * @return
		 */
		public function hashCode():int
		{
			return getClass().defaultHashCode + history.length;
		}
		
		/**
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			target.removeEventListener(type, listener, useCapture);
			var l:int = history.length;
			var evt:ModuleListener;
			while (l--) {
				evt = history[l] as ModuleListener;	
				if (evt.type == type && evt.listener == listener  && evt.useCapture == useCapture)
					history.splice(l, 1);
					break;
			}
			target.dispatchEvent(new ModuleEvent(ModuleEvent.EVENT_REMOVED, false, true, evt));
		}
		
		public function toSource():String
		{
			return Type.toXml(this).toXMLString();
		}
		
		/**
		 * 
		 * @return
		 */
		public function toString():String
		{
			return "[object ModuleEventDispatcher = (history : "+ history +", target : " + target + ")]";
		} 
		
		/**
		 * 
		 */
		public function valueOf():Object
		{
			return this;
		}
		
		/**
		 * 
		 * @param	type
		 * @return
		 */
		public function willTrigger(type:String):Boolean
		{
			return target.willTrigger(type);
		}
				
		public function get history():Array { return _history; }
		
		public function set history(value:Array):void 
		{
			_history = value;
		}
		
		public function get target():IEventDispatcher { return _target; }
		
		public function set target(value:IEventDispatcher):void 
		{
			_target = value;
		}
		
		private var _history:Array;
		private var _target:IEventDispatcher;
		
	}
}