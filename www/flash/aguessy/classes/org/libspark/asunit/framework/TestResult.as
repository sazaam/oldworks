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

package org.libspark.asunit.framework
{
	/**
	 * A <code>TestResult</code> collects the results of executing
	 * a test case. It is an instance of the Collecting Parameter pattern.
	 * The test framework distinguishes between <i>failures</i> and <i>erorrs</i>.
	 * A failure is anticipated and checked for with assertions. Errors are
	 * unanticipated problems like an <code>RangeError</code>.
	 * 
	 * @see Test
	 */
	import org.libspark.asunit.framework.Protectable;
	
	public class TestResult
	{
		protected var failures_:Array;
		protected var errors_:Array;
		protected var listeners:Array;
		protected var runTests:int;
		private var stop_:Boolean;
		
		public function TestResult() {
			failures_ = new Array();
			errors_ = new Array();
			listeners = new Array();
			runTests = 0;
			stop_ = false;
		}
		
		/**
		 * Adds an error to the list of errors.
		 */
		public function addError(test:Test, e:Object):void
		{
			errors_.push(new TestFailure(test, e));
			eachListener(function(listener:TestListener):void {
				listener.addError(test, e);
			});
		}
		
		/**
		 * Adds a failure to the list of failures.
		 */
		public function addFailure(test:Test, e:AssertionFailedError):void
		{
			failures_.push(new TestFailure(test, e));
			eachListener(function(listener:TestListener):void {
				listener.addFailure(test, e);
			});
		}
		
		/**
		 * Registers a TestListener.
		 */
		public function addListener(listener:TestListener):void
		{
			listeners.push(listener);
		}
		
		/**
		 * Unregisters a TestListener.
		 */
		public function removeListener(listener:TestListener):void
		{
			for (var i:uint = 0; i < listeners.length; ++i) {
				if (listener[i] == listener) {
					listeners = listeners.splice(i, 1);
					break;
				}
			}
		}
		
		protected function eachListener (f:Function):void
		{
			var listeners_:Array = listeners;
			var count:uint = listeners_.length;
			for (var i:uint = 0; i < count; ++i) {
				f((listeners_[i] as TestListener));
			}
		}
		
		/**
		 * Informs the result that a test was completed.
		 */
		public function endTest(test:Test):void
		{
			eachListener(function(listener:TestListener):void {
				listener.endTest(test);
			});
		}
		
		/**
		 * Gets the number of detected errors.
		 */
		public function get errorCount():uint
		{
			return errors_.length;
		}
		
		/**
		 * Gets the array of errors.
		 */
		public function get errors():Array
		{
			return errors_;
		}
		
		/**
		 * Gets the number of detected failures.
		 */
		public function get failureCount():uint
		{
			return failures_.length;
		}
		
		/**
		 * Gets the array of failures.
		 */
		public function get failures():Array
		{
			return failures_;
		}
		
		/**
		 * Run a TestCase.
		 */
		public function run(test:*):void
		{
			startTest(test);
			runProtected(test, new TestProtect(test));
			endTest(test);
		}
		
		/**
		 * Runs a TestCase
		 */
		public function runProtected(test:Test, p:Protectable):void
		{
			try {
				p.protect();
			}
			catch (e:AssertionFailedError) {
				addFailure(test, e);
			}
			catch (e:Object) {
				addError(test, e);
			}
		}
		
		/**
		 * Gets the number of run tests.
		 */
		public function get runCount():uint
		{
			return runTests;
		}
		
		/**
		 * Check the whether the test run should stop.
		 */
		public function get shouldStop():Boolean
		{
			return stop_;
		}
		
		/**
		 * Informs the result that a test will be started.
		 */
		public function startTest(test:*):void
		{
			runTests += test.countTestCases();
			eachListener(function(listener:TestListener):void {
				listener.startTest(test);
			});
		}
		
		/**
		 * Marks that the test run should stop.
		 */
		public function stop():void
		{
			stop_ = true;
		}
		
		/**
		 * Returns whether the entire test was successful or not.
		 */
		public function get wasSuccessful():Boolean
		{
			return failureCount == 0 && errorCount == 0;
		}
	}
}
