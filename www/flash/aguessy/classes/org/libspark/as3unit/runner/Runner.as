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
	import org.libspark.as3unit.runner.notification.RunNotifier;
	
	/**
	 * A <code>Runner</code> runs tests and notifies a <code>RunNotifier</code>
	 * of signifciant events as it does so. You will need subclass <code>Runner</code>
	 * when using <code>RunWith to invoke a custom runner. When creating
	 * a custom runner, in addition to implementing the abstract method here you must
	 * also provide a constructor that takes as an argument the <code>Class</code> containing
	 * the tests.
	 * 
	 * @see org.libspark.as3unit.runner.Description
	 */
	public class Runner
	{
		/**
		 * @return a <code>Description</code> showing the tests to be run by the reciver.
		 */
		public function get description():Description
		{
			throw new DefinitionError('You must override this method.');
			return null;
		}
		
		/**
		 * Run the tests for this runner.
		 * @param notifier will be notified or events while tests are being run-tests
		 *                 being started, finishing, and failing
		 */
		public function run(notifier:RunNotifier):void
		{
			throw new DefinitionError('You must override this method.');
		}
		
		/**
		 * @return the number of tests to be run by the receiver
		 */
		public function get testCount():uint
		{
			return description.testCount;
		}
	}
}