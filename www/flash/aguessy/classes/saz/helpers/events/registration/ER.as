package saz.helpers.events.registration 
{
	import aguessy.control.create.Launcher;
	import aguessy.control.display.Displayer;
	import aguessy.control.enable.Context;
	import asSist.as3Query;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import saz.helpers.events.types.ME;
	
	/**
	 * ...
	 * @author saz
	 */
	public class ER 
	{
		//Events Registerer
		
		////////////////////////////////////////////// VARS
		static private var _instance:ER;
		static private var _events:Dictionary;
		//////////////////////////////////////////////////////////////////// CTOR
		public function ER() 
		{
			_instance = this ;
		}
		//////////////////////////////////////////////////////////////////// INIT
		public function init():void
		{
			_events = new Dictionary() ;
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
						trace("OOOOPS "+ e+"  "+this)
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
			if (!_events[tg]) _events[tg] = { } ;
			
			//_events[tg][closure] = with(thisObj) function(e:Event):void { closure.apply(thisObj, [e]) } 
			_events[tg][closure] = function():Function {
				return function(e:Event):void { closure.apply(thisObj, [e]) } 
			}()  ;
			tg.addEventListener.apply(thisObj, [type, _events[tg][closure]].concat(rest)) ;
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
						trace("OOOOPS "+ e+"  "+this)
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
			tg.removeEventListener.apply(tg, [type, _events[tg][closure]].concat(rest)) ;
		}
		
//////////////////////////////////////////////////////////////////// STATICS
		//static public function add(thisObj:*,eventDispatcher:*, type:String, ...rest:Array):void
		//{ _instance.add.apply(thisObj,[eventDispatcher || null, type].concat(rest)) }
		//static public function remove(eventDispatcher:*, type:String, ...rest:Array):void
		//{ _instance.remove.apply(_instance,[eventDispatcher || null, type].concat(rest)) }
//////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get instance():ER
		{ return  _instance || new ER() }
	}
}