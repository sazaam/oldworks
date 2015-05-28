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
	import org.libspark.as3unit.runner.notification.Failure;
	import org.libspark.as3unit.runner.notification.RunListener;
	
	/**
	 * A <code>Result</code> collects and summarizes inromation from running multiple
	 * tests. Since tests are expected to run correctly, successful tests are only noted in
	 * the count of tests that ran.
	 */
	public class Result
	{
		private var value:ResultValue;
		
		public function Result()
		{
			value = new ResultValue();
			value.count = 0;
			value.ignoreCount = 0;
			value.failures = new Array();
			value.runTime = 0;
		}
		
		/**
		 * @return the number or tests run
		 */
		public function get runCount():uint
		{
			return value.count;
		}
		
		/**
		 * @return the number of tests that failed during the run
		 */
		public function get failureCount():uint
		{
			return value.failures.length;
		}
		
		/**
		 * @return the number of milliseconds it took to run the entire suite to run
		 */
		public function get runTime():uint
		{
			return value.runTime;
		}
		
		/**
		 * @return the <code>Failures</code> describing tests that failed and the problems they encountered
		 */
		public function get failures():Array
		{
			return value.failures;
		}
		
		/**
		 * @return the number of tests ignored during the run
		 */
		public function get ignoreCount():uint
		{
			return value.ignoreCount;
		}
		
		/**
		 * @return true if all tests was succeeded
		 */
		public function get wasSuccessful():Boolean
		{
			return failureCount == 0;
		}
		
		/**
		 * Internal use only.
		 */
		public function createListener():RunListener
		{
			return new Listener(value);
		}
	}
}
