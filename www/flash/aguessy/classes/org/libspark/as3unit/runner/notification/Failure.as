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
	
	/**
	 * A <code>Failure</code> holds a description of the failed test and the
	 * exception that was thrown while running it. In most cases the <code> Description</code>
	 * will be of a single test. However, if problems are encountered while constructing the
	 * test (for example, if a <code>beforeClass</code> method is not static). It may describe
	 * something other than a single test.
	 */
	public class Failure
	{
		private var fDescription:Description;
		private var fThrownException:Object;
		
		/**
		 * Constructs a <code>Failure</code> with the given description and exception.
		 * @param description a <code>Description</code> of the test that failed.
		 * @param thrownException the exception that was thrown while running the test.
		 */
		public function Failure(description:Description, thrownException:Object)
		{
			fThrownException = thrownException;
			fDescription = description;
		}
		
		/**
		 * @return a user-understandable label for the test
		 */
		public function get testHeader():String
		{
			return fDescription.displayName;
		}
		
		/**
		 * @return the raw description of the context of the failure.
		 */
		public function get description():Description
		{
			return fDescription;
		}
		
		/**
		 * @return the exception thrown
		 */
		public function get exception():Object
		{
			return fThrownException;
		}
		
		public function toString():String
		{
			return testHeader + ": " + message;
		}
		
		/**
		 * Convenience method
		 * @return the printed from of the exception
		 */
		public function get trace():String
		{
			if (exception is Error) {
				return exception.getStackTrace();
			}
			return '';
		}
		
		/**
		 * Convenience method
		 * @return the message of the thrown exception
		 */
		public function get message():String
		{
			if (exception is Error) {
				return exception.message;
			}
			return '';
		}
	}
}