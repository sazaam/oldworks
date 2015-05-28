package project 
{
	import asSist.*;
	import f6.utils.IDictionary;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import mvc.behavior.commands.Command;
	import mvc.behavior.commands.CommandQueue;
	import mvc.behavior.commands.Wait;
	import mvc.behavior.commands.WaitCommand;
	import mvc.behavior.steps.E.StepEvent;
	import mvc.behavior.steps.Step;
	import mvc.behavior.steps.StepList;
	import mvc.behavior.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestSteps extends MovieClip
	{
		private var list:VirtualSteps;
		
		public function TestSteps() 
		{
			$(this).bind(Event.ADDED_TO_STAGE, onStage) ;
		}
		
		private function onStage(e:Event):void
		{
			trace("Instanciated && On Stage") ;
			
			var steps:Array = [new Step("sazaam", new CommandQueue(new Command(null,stepOne),new WaitCommand(2000),new Command(null,stepOne),new Command(null,stepOne))),new Step(1, new Command(null, stepOne)),new Step(2, new Command(null, stepOne))] ;
			
			list = new VirtualSteps(steps);
			list.launch() ;
			
			stage.addEventListener(MouseEvent.CLICK, onStageClicked) ;
			//list.prev() ;
			//trace(list.history.length)
			
			/*
			var step:Step = new Step("sazaam",new Command(null,stepOne)) ;
			//var step:Step = new Step("sazaam",new CommandQueue(new Command(null,stepOne),new Command(null,stepOne),new Command(null,stepOne),new Command(null,stepOne))) ;
			step.addEventListener(StepEvent.OPEN, onStepOneOpen) ;
			step.addEventListener(StepEvent.CLOSE, onStepOneClose) ;
			stage.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) { step.close(); trace(e) } )
			step.launch() ;
			*/
		}
		
		private function onStageClicked(e:MouseEvent):void 
		{
			//trace("HISTORYTEST : " + Step(list.history[list.playhead]).id) ;
			var n:int = list.next() ;
			//
			//trace("PREV : "+list.hasPrev())
			//trace("NEXT : "+list.hasNext())
		}
		
		private function onStepOneClose(e:StepEvent):void 
		{
			trace("CLOSING step : 1 ") ;
		}
		
		private function onStepOneOpen(e:StepEvent):void 
		{
			trace(e.name) ;
		}
		
		private function stepOne():void
		{
			trace("step : 1") ;
		}
		
	}
	
}