/*
 * Copyright(c) 2006 the Spark project.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */

package org.libspark.as3unit.runner
{
	import org.libspark.as3unit.inter.runners.TextListener;
	import org.libspark.as3unit.runner.notification.RunListener;
	import org.libspark.as3unit.runner.notification.RunNotifier;
	import org.libspark.asunit.framework.Test;
	import org.libspark.as3unit.inter.runners.OldTestClassRunner;
	
	/**
	 * <code>AS3UnitCore</code> is a facade for running tests. It supports running AS3Unit tests,
	 * ASUnit tests, and mixtures. For one-shot test runs, use the static method <code>main(...classes)</code>.
	 * If you want to add special runners, create an instance of <code>AS3UnitCore</code> first
	 * and use it to run the tests.
	 * 
	 * @see org.libspark.as3unit.runner.Result
	 * @see org.libspark.as3unit.runner.notification.RunListener
	 * @see org.libspark.as3unit.runner.Request
	 */
	public class AS3UnitCore
	{
		private var notifier:RunNotifier;
		
		/**
		 * Create a new <code>AS3UnitCore</code> to run tests.
		 */
		public function AS3UnitCore()
		{
			notifier = new RunNotifier();
		}
		
		/**
		 * Run the tests contained in <code>classes</code>. Write feedback while the tests
		 * are running and write stack traces for all failed tests after all tests complete.
		 * @param classes Classes in which to find tests
		 * @return a <code>Result</code> describing the details of the test run and the failed tsts
		 */
		public static function main(...classes:Array):void
		{
			new AS3UnitCore().runMain(classes);
		}
		
		public static function classes(...classes:Array):Result
		{
			var core:AS3UnitCore = new AS3UnitCore();
			return core.runClasses.apply(core, classes);
		}
		
		/**
		 * Do not use. Testing purposes only.
		 */
		public function runMain(classes:Array):Result
		{
			addListener(new TextListener());
			return runClasses.apply(this, classes);
		}
		
		/**
		 * Run all the tsts in <code>classes</code>.
		 * @param classes the classes containing tests
		 * @return a <code>Result</code> describing the details of the test run and the failed tests
		 */
		public function runClasses(...classes:Array):Result
		{
			return run(Request.classes('All', classes));
		}
		
		/**
		 * Run all the tests containing in <code>Request</code>.
		 * @param request the request describing tests.
		 * @return a <code>Result</code> describing the details of the test run and the failed tests
		 */
		public function run(request:Request):Result
		{
			return runWithRunner(request.getRunner());
		}
		
		/**
		 * Run all the tests contained in ASUnit <code>test</code>. Here for backward compatibillity.
		 * @param test the old-style test
		 * @return a <code>Result</code> describing the details of the test run and the failed tests
		 */
		public function runOldTest(test:*):Result
		{
			return runWithRunner(new OldTestClassRunner(test));
		}
		
		/**
		 * Do not use. Testing purposes only.
		 */
		public function runWithRunner(runner:Runner):Result
		{
			var result:Result = new Result();
			var listener:RunListener = result.createListener();
			var description:Description = runner.description;
			addFirstListener(listener);
			try {
				notifier.fireTestRunStarted(runner.description);
				runner.run(notifier);
                notifier.fireTestRunFinished(result);
			}
			finally {
				removeListener(listener);
			}
			return result;
		}
        
        private function addFirstListener(listener:RunListener):void
        {
            notifier.addFirstListener(listener);
        }
		
		/**
		 * Add a listener to be notified as the tests run.
		 * @param listener the listener
		 * @see org.libspark.as3unit.runner.notification.RunListener
		 */
		public function addListener(listener:RunListener):void
		{
			notifier.addListener(listener);
		}
		
		/**
		 * Remove a listener
		 * @param listener the listener to remove
		 */
		public function removeListener(listener:RunListener):void
		{
			notifier.removeListener(listener);
		}
	}
}