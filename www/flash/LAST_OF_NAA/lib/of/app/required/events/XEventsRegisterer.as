package of.app.required.events 
{
	import asSist.as3Query;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import of.app.required.context.XContext;
	
	/**
	 * ...
	 * @author saz
	 */
	public class XEventsRegisterer
	{
		////////////////////////////////////////////// VARS
		static private var __events:Dictionary ;
		static private var __instance:XEventsRegisterer;
		//////////////////////////////////////////////////////////////////// CTOR
		public function XEventsRegisterer() 
		{
			//trace("CTOR > " + this)
			__instance = this ;
		}
		public function init():XEventsRegisterer 
		{
			__events = new Dictionary() ;
			
			trace(this, ' inited...')
			return this ;
		}
/////////////////////////////////////////////////////////////////////////////////////////////////////////// ADD
		public function add(thisObj:* , eventDispatcher:*, type:String, ...rest:Array):void
		{
			var tg:IEventDispatcher ;
			if (eventDispatcher is as3Query || eventDispatcher is Array) {
				var l:int = eventDispatcher["length"] ;
				for (var i:int = 0 ; i < l ; i++ ) {
					try 
					{
						add.apply(thisObj, [thisObj, IEventDispatcher(eventDispatcher[i]), type].concat(rest)) ;
					}catch (e:Error)
					{
						//trace("OOOOPS "+ e+"  "+this)
					}
				}
				return;
			}
			if (eventDispatcher == null) {
				var tgQuery:as3Query = XContext.$query() ;
				if (tgQuery.length < 1) throw(new ReferenceError("Stage is inaccessible right now..." + this)) ;
				else tg = IEventDispatcher(tgQuery[0]) ;
			}else if (!tg is IEventDispatcher) {
				throw(new ArgumentError("is not an IEventDispatcher... "+this)) ;
			}
			else tg = eventDispatcher as IEventDispatcher ;
			var closure:Function = rest.shift() ;
			if (!__events[tg]) __events[tg] = { } ;
			
			__events[tg][closure] = function():Function {
				return function(e:Event):void { closure.apply(thisObj, [e]) } 
			}()  ;
			tg.addEventListener.apply(thisObj, [type, __events[tg][closure]].concat(rest)) ;
		}
/////////////////////////////////////////////////////////////////////////////////////////////////////////// REMOVE
		public function remove(eventDispatcher:*, type:String, ...rest:Array):void
		{
			var tg:IEventDispatcher ;
			if (eventDispatcher is as3Query || eventDispatcher is Array) {
				var l:int = eventDispatcher["length"] ;
				for (var i:int = 0 ; i < l ; i++ ) {
					try 
					{
						remove.apply(null, [eventDispatcher[i], type].concat(rest)) ;
					}catch (e:Error)
					{
						//trace("OOOOPS "+ e+"  "+this)
					}
				}
				return ;
			}
			if (eventDispatcher == null) {
				var tgQuery:as3Query = XContext.$query() ;
				if (tgQuery.length < 1) throw(new ReferenceError("Stage is inaccessible right now..." + this)) ;
				else tg = tgQuery[0] ;
			}else if (!tg is IEventDispatcher) {
				throw(new ArgumentError("is not an IEventDispatcher... "+this)) ;
			}
			else tg = eventDispatcher as IEventDispatcher ;
			var closure:Function = rest.shift() ;
			tg.removeEventListener.apply(tg, [type, __events[tg][closure]].concat(rest)) ;
		}
		
		static public function init():XEventsRegisterer { return instance.init() }
		static public function get instance():XEventsRegisterer { return __instance || new XEventsRegisterer() }
		static public function get hasInstance():Boolean { return  Boolean(__instance as XEventsRegisterer) }
	}
}