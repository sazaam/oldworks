package naja.model.steps
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import naja.model.steps.I.IStep;
	import naja.model.steps.I.IStepList;
	import naja.model.data.lists.Gates;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class StepList extends EventDispatcher implements IStepList
	{
		protected var _gates:Gates
///////////////////////////////////////////////////////////////////////////CONSTRUCTOR
		public function StepList() 
		{
			_gates = new Gates() ;
		}
///////////////////////////////////////////////////////////////////////////SPECIALS
		public function dump():String
		{
			for (var i:* in _gates) {
				trace(i + "  :  " + _gates[i]) ;
			}
			return '--------------------------------------- DUMPING COMPLETE' ;
		}
///////////////////////////////////////////////////////////////////////////ADD
		public function add(_step:IStep):IStep {
			return gates.add(_step, _step.id) ;
		}
///////////////////////////////////////////////////////////////////////////REMOVE
		public function remove(_id:Object = null):IStep {
			return gates.remove(_id) ;
		}
///////////////////////////////////////////////////////////////////////////GETTER & SETTERS
		public function get length():int { return gates.merged.length }
		public function get numChildren():int { return gates.merged.length }
		public function get gates():Gates { return _gates }
///////////////////////////////////////////////////////////////////////////TOSTRING
		override public function toString():String 
		{return "[ Object StepList  "+gates+" ]" }
	}
	
}