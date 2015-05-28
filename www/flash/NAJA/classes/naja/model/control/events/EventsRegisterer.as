package naja.model.control.events 
{
	import asSist.as3Query;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import naja.model.control.context.Context;
	
	/**
	 * ...
	 * @author saz
	 */
	public class EventsRegisterer
	{
		////////////////////////////////////////////// VARS
		static private var __events:Dictionary ;
		static private var __instance:EventsRegisterer;
		//////////////////////////////////////////////////////////////////// CTOR
		public function EventsRegisterer() 
		{
			//trace("CTOR > " + this)
			__instance = this ;
			__events = new Dictionary() ;
		}
		public function init():EventsRegisterer 
		{
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
				var tgQuery:as3Query = Context.$query() ;
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
				var tgQuery:as3Query = Context.$query() ;
				if (tgQuery.length < 1) throw(new ReferenceError("Stage is inaccessible right now..." + this)) ;
				else tg = tgQuery[0] ;
			}else if (!tg is IEventDispatcher) {
				throw(new ArgumentError("is not an IEventDispatcher... "+this)) ;
			}
			else tg = eventDispatcher as IEventDispatcher ;
			var closure:Function = rest.shift() ;
			tg.removeEventListener.apply(tg, [type, __events[tg][closure]].concat(rest)) ;
		}
		
		static public function init():EventsRegisterer { return instance.init() }
		static public function get instance():EventsRegisterer { return __instance || new EventsRegisterer() }
		static public function get hasInstance():Boolean { return  Boolean(__instance) }
	}
}