package org.libspark.as3unit.runner 
{
	
	/**
	 * ...
	 * @author saz
	 */
	import org.libspark.as3unit.runner.notification.RunNotifier;
	import org.libspark.as3unit.runner.notification.Failure;
	import org.libspark.as3unit.runner.Description;
	import org.libspark.asunit.framework.TestListener;
	import org.libspark.asunit.framework.Test;
	import org.libspark.asunit.framework.TestCase;
	import org.libspark.asunit.framework.TestSuite;
	import org.libspark.asunit.framework.AS3UnitTestCaseFacade;
	import org.libspark.asunit.framework.AssertionFailedError;

	import flash.utils.getQualifiedClassName;

	public class OldTestClassAdaptingListener implements TestListener
	{
		private var notifier:RunNotifier;
		
		public function OldTestClassAdaptingListener(notifier:RunNotifier)
		{
			this.notifier = notifier;
		}
		
		public function endTest(test:Test):void
		{
			notifier.fireTestFinished(asDescription(test));
		}
		
		public function startTest(test:Test):void
		{
			notifier.fireTestStarted(asDescription(test));
		}
		
		public function addError(test:Test, e:Object):void
		{
			var failure:Failure = new Failure(asDescription(test), e);
			notifier.fireTestFailure(failure);
		}
		
		private function asDescription(test:Test):Description
		{
			if (test is AS3UnitTestCaseFacade) {
				return AS3UnitTestCaseFacade(test).description;
			}
			return Description.createTestDescription(Object(test).constructor, getName(test));
		}
		
		private function getName(test:Test):String
		{
			if (test is TestCase) {
				return TestCase(test).getName();
			}
			else {
				return String(test);
			}
		}
		
		public function addFailure(test:Test, t:AssertionFailedError):void {
			addError(test, t);
		}
	}
	
}