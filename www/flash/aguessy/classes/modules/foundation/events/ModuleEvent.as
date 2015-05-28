/**
 * @author biendo@fullsix.com 
 */
package modules.foundation.events
{
	import flash.events.Event;
	
	import modules.foundation.Type;
	
	public class ModuleEvent extends Event
	{
		
		public static const EVENT_ADDED:String = "event_added";
		public static const EVENT_REMOVED:String = "event_removed";	
		
		/**
		 * Creates an ModuleEvent object to pass as a parameter to event listeners.
		 *
		 * @param	type String — The type of the event, accessible as Event.type.
		 * @param	listener Function (default = null) — The listener function that processes the event. This function must accept an event 
		 * 			object as its only parameter and must return nothing. 
		 * @param	useCapture Boolean (default = false) — Determines whether the listener works in the capture phase or the target 
		 * 			and bubbling phases. If useCapture is set to true, the listener processes the event only during the capture 
		 * 			phase and not in the target or bubbling phase. If useCapture is false, the listener processes the event only 
		 * 			during the target or bubbling phase. To listen for the event in all three phases, call addEventListener() twice, 
		 * 			once with useCapture set to true, then again with useCapture set to false. 
		 * @param	priority int (default = 0) — The priority level of the event listener. Priorities are designated by a 32-bit 
		 * 			integer. The higher the number, the higher the priority. All listeners with priority n are processed before 
		 * 			listeners of priority n-1. If two or more listeners share the same priority, they are processed in the order 
		 * 			in which they were added. The default priority is 0. 
		 * @param	useWeakReference
		 * @param	bubbles Boolean (default = false) — Determines whether the Event object participates in the bubbling stage of 
		 * 			the event flow. The default value is false.
		 * @param	cancelable Boolean (default = false) — Determines whether the Event object can be canceled. The default values is false. 
		 * @param	source * (default = null) - Optianal object to pass in parameters
		 */
		public function ModuleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, source:*=null) 
		{
			_parameters = [].concat(arguments);
			_source  = source;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Duplicates an instance of an ModuleEvent subclass.
		 * Returns a new Event object that is a copy of the original instance of the Event object. You do not normally call clone(); 
		 * the EventDispatcher class calls it automatically when you redispatch an event—that is, when you call dispatchEvent(event) 
		 * from a handler that is handling event.
		 * @return Event - Return a clone of this DispatcherListEvent
		 */
		override public function clone():Event 
		{ 
			return Type.getInstance.apply(null, _parameters) as Event;
		}
		
		/**
		 * 
		 * @return
		 */ 
		public function toSource():String
		{
			return Type.toXml(this).toXMLString();
		} 
		
		/**
		 * 
		 * @return
		 */
		override public function toString():String 
		{ 
			var members:Array = [];
			Type.getDefinition(this).accessors.forEach(function(el:*, i:int, arr:Array):void { 
				members.push(el.name); 
			});
			return formatToString.apply(this, [Type.getClassName(this)].concat(members)); 
		}
						
		public function get source():* 
		{ 
			return _source; 
		}
		
		public function set source(value:*):void 
		{
			_source = value;
		}

	   	override public function get type():String
	   	{
	    	return _type;
	    }

	    public function set type(value:String):void
	    {
	    	_type = value;
	   	}
	   	
	   	private var _parameters:Array;
		private var _source:*;
   		private var _type:String;	
	}
}

/*


   1.
      function makeArray(a) {
   2.
        for (var b = [], i = 0; i < a.length; i++)
   3.
          b.push(a[i]);
   4.
        return b;
   5.
      }
   6.
      function bind(f, a) {
   7.
        var g = function() {
   8.
          var c = arguments.callee;
   9.
          return c._func.apply(
  10.
            null,
  11.
            c._args.concat(makeArray(arguments))
  12.
          );
  13.
        }
  14.
        g._func = f;
  15.
        g._args = a ? makeArray(a) : [];
  16.
        return g;
  17.
      }
  18.
      function partialize(f, n) {
  19.
        var g = function() {
  20.
          var c = arguments.callee;
  21.
          if (c._len <= arguments.length)
  22.
            return c._func.apply(null, arguments);
  23.
          return bind(c, arguments);
  24.
        }
  25.
        g._len = n || f.length;
  26.
        g._func = f;
  27.
        return g;
  28.
      } 
	  
Function.prototype.toSelfCurrying = function(n) {
  n = n || this.length;
  var method = this;
  return function() {
    if (arguments.length >= n) return method.apply(this, arguments);
    return method.curry.apply(arguments.callee, arguments);
  };
};

Make a simple function:

var adder = function(a,b,c) {
  return a + b + c;
};

And curry away:

var add = adder.toSelfCurrying();

add(1)(2)(3)  // --> 6
add(7,8)(23)  // --> 38


function curry(f, n) {
  var g = function() {
    var c = arguments.callee;
    if (c._len <= arguments.length)
      return c._func.apply(null, arguments);
    return bind(c, arguments);
  }
  g._len = n || f.length;
  g._func = f;
  return g;
}
function uncurry(f) {
  return f._func || f;
}
var a = function(a,b) {return a+b;}
assert(a == uncurry(curry(a)));


*/