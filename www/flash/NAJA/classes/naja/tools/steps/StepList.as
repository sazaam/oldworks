package naja.tools.steps
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import naja.tools.steps.I.IStep;
	import naja.tools.steps.I.IStepList;
	import naja.tools.lists.Gates;
	
	import naja.dns.naja_local ;
	/**
	 * ...
	 * @author saz
	 */
	
	public class StepList extends EventDispatcher implements IStepList
	{
		use namespace naja_local ;
		naja_local var __gates:Gates;
///////////////////////////////////////////////////////////////////////////CONSTRUCTOR
		public function StepList(__g:Gates = null) 
		{
			//super() ;
			init(__g) ;
		}
		
		protected function init(...params:Array):void 
		{
			__gates = params[0] || new Gates() ;
		}
		
///////////////////////////////////////////////////////////////////////////SPECIALS
		public function dump():String
		{
			for (var i:* in __gates) {
				trace(i + "  :  " + __gates[i]) ;
			}
			return '--------------------------------------- DUMPING COMPLETE' ;
		}
///////////////////////////////////////////////////////////////////////////ADD
		public function add(step:IStep):IStep {
			return __gates.add(step, step.id) ;
		}
///////////////////////////////////////////////////////////////////////////REMOVE
		public function remove(_id:Object = null):IStep {
			return __gates.remove(_id) ;
		}
///////////////////////////////////////////////////////////////////////////GETTER & SETTERS
		public function get length():int { return __gates.merged.length }
		public function get numChildren():int { return __gates.merged.length }
		public function get gates():Gates { return __gates }
///////////////////////////////////////////////////////////////////////////TOSTRING
		override public function toString():String 
		{return "[ Object StepList  "+__gates+" ]" }
	}
	
}