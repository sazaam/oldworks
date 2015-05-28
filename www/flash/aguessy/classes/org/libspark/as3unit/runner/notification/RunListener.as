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
	 * If you need to respond to the events during a test run, extend <code>RunListener</code>
	 * and override the apporiate methods. If a listener throws an exception while processing a
	 * test event, it will be removed for the remainder of the test run.
	 * 
	 * For example, suppose you have a <code>Cowbell</code>
	 * class that you want to makes a noise whenever a test fails. You could wirte:
	 * <code>
	 * public class RingingListener extends RunListener {
	 *     public override function testFailure(failure:Failure):void {
	 *         Cowbell.ring();
	 *     }
	 * }
	 * </code>
	 * 
	 * To invoke your listener, you need to run your tests throwugh <code>AS3UnitCore</code>.
	 * <code>
	 * var core:AS3UnitCore = new AS3UnitCore();
	 * core.addListener(new RingingListener());
	 * core.runClasses(MyTestClass);
	 * </code>
	 * 
	 * @see org.libspark.as3unit.runner.AS3UnitCore
	 */	
	import org.libspark.as3unit.runner.Description;
	
	public class RunListener
	{
		/**
		 * Called before any tests have been run.
		 * @param description describes the tests to be run
		 */
		public function testRunStarted(description:Description):void
		{
		}
		
		/**
		 * Called when all tests have finished
		 * @param result the summary of the test run. Including all the tests that failed.
		 */
		public function testRunFinished(result:Result):void
		{
		}
		
		/**
		 * Called when an atomic test is about to be started.
		 * @param description the description of the test that is about to be run (generally a class and method name)
		 */
		public function testStarted(description:Description):void
		{
		}
		
		/**
		 * Called when an atomic test has finished, whether the test succseds or fails.
		 * @param description the description of the test that just ran
		 */
		public function testFinished(description:Description):void
		{
		}
		
		/**
		 * Called when an atomic test fails.
		 * @param failure describes the test that failed and the exception that was thrown
		 */
		public function testFailure(failure:Failure):void
		{
		}
		
		/**
		 * Called when a test will not be run.
		 * @param description describes the test that will not be run
		 */
		public function testIgnored(description:Description):void
		{
		}
	}
}