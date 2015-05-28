package org.libspark.as3unit.runner 
{
	import org.libspark.as3unit.runner.notification.RunListener;
	import org.libspark.as3unit.runner.Result;
	import org.libspark.as3unit.runner.notification.Failure;
	import org.libspark.as3unit.runner.Description;
	import flash.utils.getTimer;
	
	public class Listener extends RunListener
	{
		private var value:ResultValue;
		
		public function Listener(value:ResultValue)
		{
			this.value = value;
		}
		
		public override function testRunStarted(description:Description):void
		{
			value.startTime = getTimer();
		}
		
		public override function testRunFinished(result:Result):void
		{
			var endTime:uint = getTimer();
			value.runTime += (endTime - value.startTime);
		}
		
		public override function testStarted(description:Description):void
		{
			value.count++;
		}
		
		public override function testFailure(failure:Failure):void
		{
			value.failures.push(failure);
		}
		
		public override function testIgnored(description:Description):void
		{
			value.ignoreCount++;
		}
	}
	
}