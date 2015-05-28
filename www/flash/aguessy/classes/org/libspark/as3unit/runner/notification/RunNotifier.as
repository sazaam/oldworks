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

package org.libspark.as3unit.runner.notification
{
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.Result;
	
	/**
	 * If you write custom runners, you may need to notify AS3Unit of your progress running tests.
	 * Do this by invoking the <code>RunNotifier</code> passed to your implementation of
	 * <code>Runner.run(notifier:RunNotifier)</code>. Future evolution of this class is likely to
	 * move <code>fireTestRunStarted()</code> and <code>fireTestRunFinished()</code>
	 * to a separate class since they should only be called once per run.
	 */
	public class RunNotifier
	{
		private var listeners:Array;
		private var fPleaseStop:Boolean;
		
		public function RunNotifier()
		{
			listeners = new Array();
			fPleaseStop = false;
		}
		
		/**
		 * Internal use only
		 */
		public function addListener(listener:RunListener):void
		{
			listeners.push(listener);
		}
		
		/**
		 * Internal use only
		 */
		public function removeListener(listener:RunListener):void
		{
			var listeners_:Array = listeners;
			var len:uint = listeners_.length;
			for (var i:uint = 0; i < len; ++i) {
				if (listeners_[i] == listener) {
					listeners_.splice(i, 1);
					return;
				}
			}
		}
		
		private function notifyListener(operation:Function):void
		{
			var listeners_:Array = listeners;
			var len:uint = listeners_.length;
			for (var i:uint = 0; i < len;) {
				try {
					operation(listeners_[i]);
					++i;
				}
				catch (e:Error) {
					listeners_.splice(i, 1);
					len = listeners_.length;
					fireTestFailure(new Failure(Description.TEST_MECHANISM, e));
				}
			}
		}
		
		/**
		 * Do not invoke.
		 */
		public function fireTestRunStarted(description:Description):void
		{
			notifyListener(function(each:RunListener):void {
				each.testRunStarted(description);
			});
		}
		
		/**
		 * Do not invoke.
		 */
		public function fireTestRunFinished(result:Result):void
		{
			notifyListener(function(each:RunListener):void {
				each.testRunFinished(result);
			});
		}
		
		/**
		 * Invoke to tell listeners that an atomic test is about to start.
		 * @param description the description of the atomic test (generally a class and method name)
		 * @throws StoppedByUserException thrown if a user has requested that the test run stop
		 */
		public function fireTestStarted(description:Description):void
		{
			if (fPleaseStop) {
				throw new StoppedByUserException();
			}
			notifyListener(function(each:RunListener):void {
				each.testStarted(description);
			});
		}
		
		/**
		 * Invoke to tell listeners that an atomic test failed.
		 * @param failure the description of the test that failed and the exception thrown
		 */
		public function fireTestFailure(failure:Failure):void
		{
			notifyListener(function(each:RunListener):void {
				each.testFailure(failure);
			});
		}
		
		/**
		 * Invoke to tell listeners that an atomic test was igonred.
		 * @param description the description of the ignored test
		 */
		public function fireTestIgnored(description:Description):void
		{
			notifyListener(function(each:RunListener):void {
				each.testIgnored(description);
			});
		}
		
		/**
		 * Invoke to tell listeners that an atomic test finished. Always invoke <code>fireTestFinished()</code>
		 * if you invoke <code>fireTestStarted()</code> as listeners are likely to expect them to come in pairs.
		 * @param description the description of the test that finished.
		 */
		public function fireTestFinished(description:Description):void
		{
			notifyListener(function(each:RunListener):void {
				each.testFinished(description);
			});
		}
		
		/**
		 * Ask that the tests run stop before starting the next test. Phrased polltely because
		 * the test currently running will not be interrupted. It seems a little odd to put this
		 * functionality here, but the <code>RunNotifier</code> is the only object guranteed
		 * to be shared amongst the many runners invoked.
		 */
		public function pleaseStop():void
		{
			fPleaseStop = true;
		}
        
        public function addFirstListener(listener:RunListener):void
        {
            listeners.unshift(listener);
        }
        
        public function testAborted(description:Description, cause:Object):void
        {
            fireTestStarted(description);
            fireTestFailure(new Failure(description, cause));
            fireTestFinished(description);
        }
	}
}