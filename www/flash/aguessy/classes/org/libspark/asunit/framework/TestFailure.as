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
 	 * A <code>TestFailure</code> collects a failed test together with
 	 * the caught exception.
 	 * @see TestResult
 	 */
 	public class TestFailure
 	{
 		protected var failedTest_:Test;
 		protected var thrownError_:Object;
 		
 		/**
 		 * Constructs a TestFailure with the given test and exception.
 		 */
 		public function TestFailure(failedTest:Test, thrownError:Object)
 		{
 			failedTest_ = failedTest;
 			thrownError_ = thrownError;
 		}
 		
 		/**
 		 * Gets the failed test.
 		 */
 		public function get failedTest():Test
 		{
 			return failedTest_;
 		}
 		
 		/**
 		 * Gets the thrown exception.
 		 */
 		public function get thrownError():Object
 		{
 			return thrownError_;
 		}
 		
 		/**
 		 * Returns a short description of the failure.
 		 */
 		public function toString():String
 		{
 			return (failedTest_ + ': ' + errorMessage);
 		}
 		
 		public function get trace():String
 		{
 			if (thrownError_ is Error) {
	 			return thrownError_.getStackTrace();
	 		}
	 		return '';
 		}
 		public function get errorMessage():String
 		{
 			if (thrownError_ is Error) {
	 			return thrownError_.message;
	 		}
	 		return '';
 		}
 		public function get isFailure():Boolean
 		{
 			return thrownError_ is AssertionFailedError;
 		}
 	}
 }