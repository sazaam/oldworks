package pro.steps 
{
	import begin.eval.Eval;
	import begin.eval.evaluate;
	import begin.type.Type;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import naja.tools.commands.I.ICommand;
	import naja.tools.lists.Gates;
	import naja.tools.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class DynScript extends EventDispatcher
	{
		private const MYSTEP:String = "naja::MyStep" ;
		
		private var __stepClass:Class ;
		private var __scriptName:String;
		private var current:String;
		private static var __evaluatedClasses:Dictionary = new Dictionary() ;
		public function evaluateScriptVStep(_ns:String, _className:String, _constrBody:String , _id:Object = null, _commandOpen:ICommand = null, _commandClose:ICommand = null, _steps:Gates = null):void
		{
			current = _className ;
			var ns:String = _ns ;
			if (__evaluatedClasses[current] == null) {
				
				trace('ici ou pas')			
				var s:String = 'namespace naja = "' + ns + '";use namespace ' + ns + ';namespace steps = "naja.tools.steps";use namespace steps;'
				s += "naja class "+ current +" extends VirtualSteps{naja function " + current +"(...params) {" + _constrBody +"}}" ;	
				trace(s)
				var ev:Eval = evaluate(s, 'papi', onStepDispatch) ;
				
			}else {
				//trace('ben non')
				//onStep() ;
			}
			
		}
		
		private function onStepDispatch(e:Event):void 
		{
			trace('>>>>>>>>>>>>>> step should be created') ;
			var c:Class ;
			if (Boolean(__evaluatedClasses[current])) {
				c = Class(__evaluatedClasses[current]) ;
			}else {
				trace(current) ;
				c = Eval(e.target).getEvalLoader().getDefinition('naja::'+current) as Class ;
			}
			
			trace(c) ;
			//__evaluatedClasses[] =  ;
		}
		
		public function DynScript(scr:XML = null, scrName:String = null) 
		{
			__scriptName = scrName ;
			init(scr || __script) ;	
		}	
		
		private function init(scr:XML):void 
		{
			evaluate(scr.toString(), __scriptName || "NajaJS", evalStep);	
		}
		
		protected function evalStep(evt : Event) : void 
		{
			__stepClass = Eval(evt.target).getEvalLoader().getDefinition(MYSTEP) as Class ;
			dispatchEvent(new Event(Event.COMPLETE)) ;
		}
		
		public function get scriptName():String { return __scriptName; }
		
		public function get stepClass():Class { return __stepClass; }
		
		private var __script : XML = <![CDATA[
			namespace naja = "naja";
			use namespace naja;
			
			namespace steps = "naja.tools.steps";
			use namespace steps;
			
			naja class MyStep extends VirtualSteps {
				naja function MyStep(...params) {
					init.apply(null, params) ;
					trace('object Step created')
				}					
			}
		]]> ;
		
		
		private var __script2 : XML = <![CDATA[
			namespace naja = "naja";
			use namespace naja;
			
			namespace steps = "naja.tools.steps";
			use namespace steps;
			
			naja class ASStep extends VirtualSteps {
				naja function ASStep(...params) {
					init.apply(null, params) ;
					trace('object ASStep created')
				}					
			}
			
		]]> ;
	}
}